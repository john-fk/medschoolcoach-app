import 'package:Medschoolcoach/providers/analytics_constants.dart';
import 'package:Medschoolcoach/utils/super_state/super_state.dart';
import 'package:Medschoolcoach/providers/analytics_provider.dart';
import 'package:Medschoolcoach/repository/flashcard_repository.dart';
import 'package:Medschoolcoach/repository/repository_result.dart';
import 'package:Medschoolcoach/ui/flash_card/card/flash.dart';
import 'package:Medschoolcoach/ui/flash_card/widgets/no_flashcards_widget.dart';
import 'package:Medschoolcoach/utils/api/models/flashcards_stack_model.dart';
import 'package:Medschoolcoach/utils/style_provider/style.dart';
import 'package:Medschoolcoach/utils/responsive_fonts.dart';
import 'package:Medschoolcoach/widgets/empty_state/empty_state.dart';
import 'package:Medschoolcoach/widgets/empty_state/refreshing_empty_state.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:Medschoolcoach/widgets/progress_bar/button_progress_bar.dart';
import 'package:Medschoolcoach/widgets/modals/explanation_modal.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:Medschoolcoach/widgets/app_bars/questions_app_bar.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:Medschoolcoach/utils/sizes.dart';
import 'package:injector/injector.dart';
import 'flash_cards_stack.dart';
import 'dart:ui';
typedef ChangeCardIndex({bool increase, FlashcardStatus cardstatus});

class FlashCardScreen extends StatefulWidget {
  final FlashcardsStackArguments arguments;

  const FlashCardScreen(this.arguments);

  @override
  _FlashCardScreenState createState() => _FlashCardScreenState();
}

class _FlashCardScreenState extends State<FlashCardScreen>
    with SingleTickerProviderStateMixin {
  final _flashcardsRepository =
      Injector.appInstance.getDependency<FlashcardRepository>();
  final AnalyticsProvider _analyticsProvider =
      Injector.appInstance.getDependency<AnalyticsProvider>();
  final String _howToSeen = "seen";
  final String _howToFlashcard = "Flashcard_tutorial";

  RepositoryResult<FlashcardsStackModel> _result;
  bool _loading = false;
  int _cardIndex = 0;
  bool _front = true;
  Size cardArea;
  int _totalCards = 0;
  @override
  void initState() {
    super.initState();
    _fetchFlashcards();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
    ]);

    _analyticsProvider.logScreenView(
        AnalyticsConstants.screenFlashcards, widget.arguments.source);
    //reset consecutive flashcard counter;
    WidgetsBinding.instance
        .addPostFrameCallback((_) =>
            SuperStateful.of(context).popupFlashcard(notConfident: false));
  }

  Future<void> _fetchFlashcards({bool forceApiRequest = false}) async {
    setState(() {
      _loading = true;
    });

    final result = await _flashcardsRepository.getFlashcardsStack(
      arguments: widget.arguments,
      forceApiRequest: forceApiRequest,
    );

    setState(() {
      _result = result;
      _loading = false;
    });

    if (_result is RepositorySuccessResult<FlashcardsStackModel>) {
      _totalCards = (_result as RepositorySuccessResult<FlashcardsStackModel>)
          .data
          .items
          .length;
      if (_totalCards > 0) {
        _cardIndex = (_result as RepositorySuccessResult<FlashcardsStackModel>)
            .data
            .position;
      }
    }
  }

  void _showFlashcardsHowTo() async {
    if (await FlutterSecureStorage().read(key: _howToFlashcard) == null) {
      openModal(true);
    }
  }

  void _changeCardIndex(
      {bool increase = true,
      FlashcardStatus cardstatus = FlashcardStatus.Seen}) {
    if (!increase && _cardIndex == 0) return;

    if (increase) {

      //save current emoji
      (_result as RepositorySuccessResult<FlashcardsStackModel>)
          .data
          .items[_cardIndex]
          .status = cardstatus;

      //add card count
      SuperStateful.of(context).popupAddCard();
      //update confidence count for popup trigger
      SuperStateful.of(context).popupFlashcard(
          notConfident : cardstatus == FlashcardStatus.Negative);

      _cardIndex++;
    } else
      _cardIndex--;

    if (_cardIndex + 1 > _totalCards) {
      _totalCards = 0;
      _flashcardsRepository.clearCacheKey(widget.arguments);
    } else {
      (_result as RepositorySuccessResult<FlashcardsStackModel>).data.position =
          _cardIndex;
      //updates the cache
      _flashcardsRepository.updateCard(widget.arguments,
          (_result as RepositorySuccessResult<FlashcardsStackModel>).data);
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    _showFlashcardsHowTo();
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            width: size.width,
            height: size.height,
            child: SvgPicture.asset(
              Style.of(context).svgAsset.flashCardBackground,
              fit: BoxFit.cover,
            ),
          ),
          Column(
            children: <Widget>[
              QuestionAppBar(
                onChange: updateHeader,
                isFlashCard: true,
                onHowtoTap: openModal,
                category: widget.arguments.subjectName ??
                    widget.arguments.status.toString().split(".")[1],
                currentQuestion: _cardIndex + 1,
                questionsSize: _result != null ? _totalCards : 0,
              ),
              Expanded(
                child: _buildContent(),
              )
            ],
          ),
        ],
      ),
    );
  }

  void updateHeader(Size header) {
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    double bottomHeight = (MediaQuery.of(context).size.width / 15) +
        50 +
        whenDevice(
          context,
          large: isPortrait ? 5 : 0,
          tablet: isPortrait ? 15 : 0,
        ) +
        whenDevice(
          context,
          large: isPortrait ? 20 : 0,
          small: isPortrait ? 15 : 0,
          tablet: isPortrait ? 30 : 0,
        );
    setState(() {
      cardArea = Size(MediaQuery.of(context).size.width,
          MediaQuery.of(context).size.height - header.height - bottomHeight);
    });
  }

  Widget _buildContent() {
    if (_loading)
      return Center(
        child: ButtonProgressBar(),
      );
    if (_result is RepositoryErrorResult)
      return RefreshingEmptyState(
        refreshFunction: () => _fetchFlashcards(forceApiRequest: true),
        repositoryResult: _result,
      );
    if (_result is RepositorySuccessResult<FlashcardsStackModel>) {
      final flashcardsStack =
          (_result as RepositorySuccessResult<FlashcardsStackModel>).data;
      if (_totalCards == 0) {
        _analyticsProvider.logScreenView(AnalyticsConstants.screenNoFlashcard,
            AnalyticsConstants.screenFlashcards);
        return NoFlashcardsWidget(widget.arguments);
      }
      return FlashCardsStack(
        changeCardIndex: _changeCardIndex,
        cardArea: cardArea,
        cardIndex: _cardIndex,
        front: _front,
        flashcardsStackModel: flashcardsStack,
        setFront: setFront,
        analyticsProvider: _analyticsProvider,
      );
    }

    return EmptyState();
  }

  void setFront({@required bool front}) {
    setState(() {
      _front = front;
    });
  }

  void openModal([bool isFirst=false]) {
    _analyticsProvider.logEvent(AnalyticsConstants.flashcardTutorial);
    openExplanationModal(
      context: context,
      fitHeight: isPortrait(context) ? true : false,
      title: FlutterI18n.translate(context, "flashcards_tips.welcome"),
      content: _explanationContent(),
      closeBarrierContent: isFirst ? _firstTimer : null
    );
    if (isFirst) {
      FlutterSecureStorage().write(key: _howToFlashcard, value: _howToSeen);
    }
  }

  void _firstTimer(double height){
    showGeneralDialog<void>(
      barrierDismissible: true,
      barrierLabel: '',
      barrierColor: Color(0x00000000),
      transitionDuration: Duration(milliseconds: 200),
      pageBuilder: (ctx, anim1, anim2) =>
          Material(
          type: MaterialType.transparency,
            child:  Wrap(
                children:[
              Container(
                height: height,
                child:
                Center(
                    child:
                    Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children:[
                          Image(
                              image: AssetImage(
                                  Style.of(context).pngAsset.handwave),
                              height:MediaQuery.of(context).size.height * 0.1,
                          ),
                          SizedBox(
                              height:MediaQuery.of(context).size.height * 0.01),
                          Text(FlutterI18n.translate(
                              context, "flashcards_tips.first_load_text"),
                            style: biggerResponsiveFont(context,
                                fontColor: FontColor.DividerColor)
                                .copyWith(fontWeight: FontWeight.w500),
                          )
                        ])
                )
            )])
          ),
      transitionBuilder: (ctx, anim1, anim2, child) =>
          FadeTransition(
            child: child,
            opacity: anim1,
          ),
      context: context,
    ).then((value) {
      Navigator.of(context, rootNavigator: true).pop();
    });
  }

  Widget _explanationContent() {
    List<int> tips = [1, 2, 3, 4, 5];

    return Column(children: [for (var i in tips) _buildTips(i)]);
  }
  Widget _buildTips(int tipsNumber) {
    return Container(
        margin: EdgeInsets.only(bottom: biggerResponsiveFont(context).fontSize),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
                height: whenDevice(
                  context,
                  medium: 50,
                  large: 80,
                  tablet: 90,
                ),
                child: Container(
                    alignment: Alignment.center,
                    child: Image(
                      image: AssetImage(Style.of(context).pngAsset.flipTips +
                          tipsNumber.toString() +
                          ".png"),
                    ))),
            SizedBox(
                width: whenDevice(context, medium: 15, large: 20, tablet: 32)),
            SizedBox(
                width: whenDevice(
                  context,
                  small: 155,
                  medium: 165,
                  large: 175,
                  tablet: 250,
                ),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        FlutterI18n.translate(
                            context, "flashcards_tips.tips${tipsNumber}_title"),
                        style: biggerResponsiveFont(context,
                                fontColor: FontColor.DividerColor)
                            .copyWith(fontWeight: FontWeight.w400),
                      ),
                      Text(
                        FlutterI18n.translate(context,
                            "flashcards_tips.tips${tipsNumber}_subtitle"),
                        style: mediumResponsiveFont(context,
                            fontColor: FontColor.DividerColor),
                      )
                    ]))
          ],
        ));
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    super.dispose();
  }


}
