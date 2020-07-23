import 'package:Medschoolcoach/ui/home/home_section.dart';
import 'package:Medschoolcoach/utils/api/models/statistics.dart';
import 'package:Medschoolcoach/utils/navigation/routes.dart';
import 'package:Medschoolcoach/utils/sizes.dart';
import 'package:Medschoolcoach/utils/style_provider/style.dart';
import 'package:Medschoolcoach/utils/super_state/super_state.dart';
import 'package:Medschoolcoach/widgets/global_progress/widgets/global_progress_widget_cell.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_svg/svg.dart';

import 'widgets/global_progress_widget_locked_cell.dart';

class GlobalProgressWidget extends StatefulWidget {
  final bool premium = true;
  final bool showHeader;

  const GlobalProgressWidget({
    Key key,
    this.showHeader = true,
  }) : super(key: key);

  @override
  _GlobalProgressWidgetState createState() => _GlobalProgressWidgetState();
}

class _GlobalProgressWidgetState extends State<GlobalProgressWidget> {
  @override
  Widget build(BuildContext context) {
    SuperStateful.of(context).updateGlobalStatistics(forceApiRequest: true);
    final stats = SuperStateful.of(context).globalStatistics;

    final iconHeight = whenDevice(
      context,
      small: 30.0,
      large: 50.0,
      tablet: 120.0,
    );
    final spacing = whenDevice(
      context,
      large: 10.0,
      tablet: 30.0,
    );

    return HomeSection(
      sectionTitle: widget.showHeader
          ? FlutterI18n.translate(
              context,
              "global_progress.name",
            )
          : "",
      useMargin: widget.showHeader,
      sectionWidget: GridView.count(
        padding: EdgeInsets.zero,
        crossAxisCount: 2,
        shrinkWrap: true,
        childAspectRatio: 0.95,
        physics: ClampingScrollPhysics(),
        mainAxisSpacing: spacing,
        crossAxisSpacing: spacing,
        children: <Widget>[
          GlobalProgressWidgetCell(
            color: Style.of(context).colors.accent2,
            icon: Padding(
              padding: const EdgeInsets.only(top: 5),
              child: _buildCourseProgressWidget(stats.courseProgress),
            ),
            name: FlutterI18n.translate(context, "global_progress.course"),
            progress: "${stats.courseProgress}%",
            onTap: () => Navigator.pushNamed(context, Routes.schedule),
          ),
          GlobalProgressWidgetCell(
            color: Style.of(context).colors.premium,
            icon: SvgPicture.asset(
              Style.of(context).svgAsset.videos,
              color: Style.of(context).colors.content2,
              height: iconHeight,
            ),
            name: FlutterI18n.translate(context, "global_progress.watched"),
            progress: stats.lessonsWatched.toString() +
                "/" +
                stats.totalLessons.toString(),
            onTap: () => Navigator.pushNamed(context, Routes.videos),
          ),
          _buildQuestionsWidget(iconHeight, stats),
          _buildFlashcardsWidget(iconHeight, stats),
        ],
      ),
    );
  }

  Widget _buildQuestionsWidget(double iconHeight, Statistics stats) {
    return widget.premium
        ? GlobalProgressWidgetCell(
            color: Style.of(context).colors.questions,
            icon: SvgPicture.asset(
              Style.of(context).svgAsset.questions,
              color: Style.of(context).colors.content2,
              height: iconHeight,
            ),
            name: FlutterI18n.translate(context, "global_progress.questions"),
            progress: stats.questionsAnswered.toString() +
                "/" +
                stats.totalQuestions.toString(),
            onTap: () => Navigator.pushNamed(context, Routes.questionBank),
          )
        : GlobalProgressWidgetLockedCell(
            iconHeight: iconHeight,
            lockedFeature: LockedFeature.Questions,
          );
  }

  Widget _buildFlashcardsWidget(double iconHeight, Statistics stats) {
    return widget.premium
        ? GlobalProgressWidgetCell(
            color: Style.of(context).colors.accent,
            icon: SvgPicture.asset(
              Style.of(context).svgAsset.flashcards,
              color: Style.of(context).colors.content2,
              height: iconHeight,
            ),
            name: FlutterI18n.translate(
              context,
              "global_progress.flashcards",
            ),
            progress: stats.totalFlashcardsMastered.toString() +
                "/" +
                stats.totalFlashcards.toString(),
            onTap: () => Navigator.pushNamed(context, Routes.flashCardsMenu),
          )
        : GlobalProgressWidgetLockedCell(
            iconHeight: iconHeight,
            lockedFeature: LockedFeature.Flashcards,
          );
  }

  Widget _buildCourseProgressWidget(int progress) {
    final size = whenDevice(
      context,
      small: 25.0,
      large: 40.0,
      tablet: 110.0,
    );
    return Container(
      height: size,
      width: size,
      child: CircularProgressIndicator(
        backgroundColor: Style.of(context).colors.brightShadow,
        strokeWidth: whenDevice(
          context,
          small: 4,
          large: 8,
          tablet: 12,
        ),
        valueColor: AlwaysStoppedAnimation(Style.of(context).colors.content2),
        value: progress / 100,
      ),
    );
  }
}
