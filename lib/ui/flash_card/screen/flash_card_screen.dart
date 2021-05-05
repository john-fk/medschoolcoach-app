import 'package:Medschoolcoach/providers/analytics_constants.dart';
import 'package:Medschoolcoach/providers/analytics_provider.dart';
import 'package:Medschoolcoach/repository/flashcard_repository.dart';
import 'package:Medschoolcoach/repository/repository_result.dart';
import 'package:Medschoolcoach/ui/flash_card/widgets/no_flashcards_widget.dart';
import 'package:Medschoolcoach/utils/api/models/flashcards_stack_model.dart';
import 'package:Medschoolcoach/utils/style_provider/style.dart';
import 'package:Medschoolcoach/utils/responsive_fonts.dart';
import 'package:Medschoolcoach/widgets/empty_state/empty_state.dart';
import 'package:Medschoolcoach/widgets/empty_state/refreshing_empty_state.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:Medschoolcoach/widgets/progress_bar/button_progress_bar.dart';
import 'package:Medschoolcoach/ui/flash_card/card/flash_card_bottom.dart';
import 'package:Medschoolcoach/widgets/modals/explanation_modal.dart';
import 'package:flutter/material.dart';
import 'package:Medschoolcoach/widgets/app_bars/questions_app_bar.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_html/style.dart' as medstyles;
import 'package:Medschoolcoach/utils/sizes.dart';
import 'package:injector/injector.dart';
import 'flash_cards_stack.dart';

typedef ChangeCardIndex({bool increase});

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

  RepositoryResult<FlashcardsStackModel> _result;
  bool _loading = false;
  int _cardIndex = 0;
  bool _front = true;
  Size cardArea;

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
  }

  void _changeCardIndex({bool increase = true}) {
    if (!increase && _cardIndex == 0) return;

    if (increase)
      _cardIndex++;
    else
      _cardIndex--;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
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
                questionsSize: _result != null
                    ? (_result as RepositorySuccessResult<FlashcardsStackModel>)
                        .data
                        .items
                        .length
                    : 0,
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
    double bottomHeight = (MediaQuery.of(context).size.width / 15) +
        50 +
        whenDevice(
          context,
          large: 5,
          tablet: 15,
        ) +
        whenDevice(
          context,
          large: 20,
          small: 15,
          tablet: 30,
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
      if (flashcardsStack.items.length == 0) {
        _analyticsProvider.logScreenView(AnalyticsConstants.screenNoFlashcard,
            AnalyticsConstants.screenFlashcards);
        return NoFlashcardsWidget(widget.arguments);
      }
      return FlashCardsStack(
        changeCardIndex: _changeCardIndex,
        cardArea: cardArea,
        cardIndex: _cardIndex + 1,
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

  void openModal() {
    openExplanationModal(
      context: context,
      fitHeight: true,
      title: FlutterI18n.translate(context, "flashcards_tips.welcome"),
      content: _explanationContent(),
    );
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
                    child: SvgPicture.asset(
                      Style.of(context).svgAsset.flipTips +
                          tipsNumber.toString() +
                          ".svg",
                    ))),
            SizedBox(
                width: whenDevice(
              context,
              medium: 25,
              large: 45,
              tablet: 90,
            )),
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
