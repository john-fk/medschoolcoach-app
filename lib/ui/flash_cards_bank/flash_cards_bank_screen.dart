import 'package:Medschoolcoach/repository/repository_result.dart';
import 'package:Medschoolcoach/ui/flash_cards_bank/wigets/flash_cards_subjects.dart';
import 'package:Medschoolcoach/ui/flash_cards_bank/wigets/review_by_status_widget.dart';
import 'package:Medschoolcoach/ui/home/home_section.dart';
import 'package:Medschoolcoach/utils/super_state/super_state.dart';
import 'package:Medschoolcoach/widgets/app_bars/custom_app_bar.dart';
import 'package:Medschoolcoach/widgets/empty_state/refreshing_empty_state.dart';
import 'package:Medschoolcoach/widgets/navigation_bar/navigation_bar.dart';
import 'package:Medschoolcoach/widgets/progrss_bar/progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

class FlashCardsBankScreen extends StatefulWidget {
  @override
  _FlashCardsBankScreenState createState() => _FlashCardsBankScreenState();
}

class _FlashCardsBankScreenState extends State<FlashCardsBankScreen> {
  RepositoryResult _result;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _fetchFlashcardsSections(),
    );
  }

  Future<void> _fetchFlashcardsSections({bool forceApiRequest = false}) async {
    setState(() {
      _loading = true;
    });

    final result = await SuperStateful.of(context).updateFlashcardsSectionsList(
      forceApiRequest: forceApiRequest,
    );

    setState(() {
      _loading = false;
      _result = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(),
      body: Column(
        children: <Widget>[
          CustomAppBar(
            title: FlutterI18n.translate(
              context,
              "common.flash_cards",
            ),
          ),
          Expanded(
            child: _buildContent(context),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    final sections = SuperStateful.of(context).flashcardsSections;
    if (_loading)
      return Center(
        child: ProgressBar(),
      );
    if (_result is RepositoryErrorResult || sections.isEmpty)
      return RefreshingEmptyState(
        refreshFunction: () => _fetchFlashcardsSections(forceApiRequest: true),
        repositoryResult: _result,
      );
    return RefreshIndicator(
      onRefresh: () => _fetchFlashcardsSections(forceApiRequest: true),
      child: ListView(
        shrinkWrap: true,
        children: <Widget>[
          _buildReviewByStatus(context),
          _buildSubjects(context),
        ],
      ),
    );
  }

  Widget _buildSubjects(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        left: 12,
        right: 12,
        top: 8,
      ),
      child: HomeSection(
        sectionTitle: FlutterI18n.translate(
          context,
          "flashcards_bank.pick_subject",
        ),
        sectionWidget: FlashCardsSubjects(),
      ),
    );
  }

  Padding _buildReviewByStatus(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 12,
        right: 12,
        bottom: 8,
      ),
      child: HomeSection(
        sectionTitle: FlutterI18n.translate(
          context,
          "flashcards_bank.review_by_status",
        ),
        sectionWidget: ReviewByStatusWidget(),
      ),
    );
  }
}
