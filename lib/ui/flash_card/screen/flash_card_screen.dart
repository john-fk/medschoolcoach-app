import 'package:Medschoolcoach/providers/analytics_constants.dart';
import 'package:Medschoolcoach/providers/analytics_provider.dart';
import 'package:Medschoolcoach/repository/flashcard_repository.dart';
import 'package:Medschoolcoach/repository/repository_result.dart';
import 'package:Medschoolcoach/ui/flash_card/how_to/flashcards_how_to.dart';
import 'package:Medschoolcoach/ui/flash_card/widgets/no_flashcards_widget.dart';
import 'package:Medschoolcoach/utils/api/models/flashcards_stack_model.dart';
import 'package:Medschoolcoach/utils/style_provider/style.dart';
import 'package:Medschoolcoach/widgets/empty_state/empty_state.dart';
import 'package:Medschoolcoach/widgets/empty_state/refreshing_empty_state.dart';
import 'package:Medschoolcoach/widgets/progress_bar/button_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/svg.dart';
import 'package:injector/injector.dart';

import 'flash_card_bar.dart';
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
  static const _howToFrontKey = "flashcardsHowToFront";
  static const _howToBackKey = "flashcardsHowToBack";
  static const _howToSeen = "seen";

  final _flashcardsRepository =
      Injector.appInstance.getDependency<FlashcardRepository>();
  final AnalyticsProvider _analyticsProvider =
      Injector.appInstance.getDependency<AnalyticsProvider>();

  RepositoryResult<FlashcardsStackModel> _result;
  bool _loading = false;
  int _cardIndex = 0;
  Animation<double> _animation;
  AnimationController _animationController;
  bool _front = true;
  bool _showBackHowTo = false;

  @override
  void initState() {
    super.initState();
    _fetchFlashcards();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
    ]);

    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));

    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController)
      ..addListener(() {
        setState(() {});
      });

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

    if (_result is RepositorySuccessResult<FlashcardsStackModel> &&
        (_result as RepositorySuccessResult<FlashcardsStackModel>)
                .data
                .items
                .length !=
            0) _showFlashcardsHowTo();
  }

  void _showFlashcardsHowTo() async {
    final storage = FlutterSecureStorage();

    final valueFront = await storage.read(key: _howToFrontKey);
    final valueBack = await storage.read(key: _howToBackKey);

    if (valueFront == null || valueFront != _howToSeen) {
      await storage.write(key: _howToFrontKey, value: _howToSeen);
      _animationController.forward();
    }

    if (valueBack == null || valueBack != _howToSeen) {
      _showBackHowTo = true;
    }
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
              FlashCardBar(),
              Expanded(
                child: _buildContent(),
              ),
            ],
          ),
          Positioned.fill(
            child: Opacity(
              opacity: _animation.value,
              child: _animation.value == 0
                  ? Container()
                  : FlashcardsHowTo(
                      front: _front,
                      gotIt: _hideHowTo,
                    ),
            ),
          ),
        ],
      ),
    );
  }

  void _hideHowTo() {
    if (_animation.value == 1) _animationController.reverse();
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
    if (!front && _showBackHowTo) {
      setState(() {
        _showBackHowTo = false;
      });
      final storage = FlutterSecureStorage();
      storage.write(key: _howToBackKey, value: _howToSeen);

      _animationController.forward();
    }
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    super.dispose();
  }
}
