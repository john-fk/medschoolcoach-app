import 'package:Medschoolcoach/providers/analytics_constants.dart';
import 'package:Medschoolcoach/repository/flashcard_repository.dart';
import 'package:Medschoolcoach/ui/lesson/widgets/square_feature_button.dart';
import 'package:Medschoolcoach/ui/lesson/widgets/wide_feature_button.dart';
import 'package:Medschoolcoach/ui/questions/multiple_choice_question_screen.dart';
import 'package:Medschoolcoach/ui/videos/lecture_notes_screen.dart';
import 'package:Medschoolcoach/ui/videos/whiteboard_notes_screen.dart';
import 'package:Medschoolcoach/utils/api/models/video.dart';
import 'package:Medschoolcoach/utils/navigation/routes.dart';
import 'package:Medschoolcoach/utils/responsive_fonts.dart';
import 'package:Medschoolcoach/utils/sizes.dart';
import 'package:Medschoolcoach/utils/style_provider/style.dart';
import 'package:Medschoolcoach/widgets/modals/podcast_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_svg/svg.dart';

class PremiumUserCards extends StatelessWidget {
  final double sidePaddingValue;
  final Video video;
  final VoidCallback pausePlayer;
  final VoidCallback resumePlayer;

  const PremiumUserCards({
    Key key,
    @required this.sidePaddingValue,
    @required this.video,
    @required this.pausePlayer,
    @required this.resumePlayer
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Container(
      margin: EdgeInsets.symmetric(horizontal: sidePaddingValue),
      child: Column(
        children: <Widget>[
          if (video.hasLectureNotes == true ||
              video.whiteboardNotesUrl != null ||
              video.flashcardsCount != 0 ||
              video.questionsCount != 0)
            Row(
              children: <Widget>[
                Text(
                  FlutterI18n.translate(
                    context,
                    "lesson_screen.premium_features",
                  ),
                  style:
                      bigResponsiveFont(context, fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 5),
                Icon(
                  Icons.star,
                  color: Style.of(context).colors.premium,
                  size: 15,
                ),
              ],
            ),
          if (video.hasLectureNotes == true ||
              video.whiteboardNotesUrl != null ||
              video.flashcardsCount != 0 ||
              video.questionsCount != 0)
            Padding(
              padding: const EdgeInsets.only(
                top: 10.0,
              ),
              child: _buildGrid(context),
            ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              FlutterI18n.translate(context, "lesson_screen.other_options"),
              style: bigResponsiveFont(context, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 10),
          WideFeatureButton(
            color: Style.of(context).colors.content,
            text: FlutterI18n.translate(
              context,
              "lesson_screen.tutoring",
            ),
            icon: RotatedBox(
              quarterTurns: 2,
              child: SvgPicture.asset(
                Style.of(context).svgAsset.backArrowDark,
                color: Style.of(context).colors.content2,
                width: whenDevice(
                  context,
                  large: 25,
                  tablet: 50,
                ),
              ),
            ),
            onTap: () => Routes.navigateToTutoringScreen(
                context, AnalyticsConstants.screenLessonVideo),
          ),
          const SizedBox(
            height: 10,
          ),
          WideFeatureButton(
            color: Style.of(context).colors.questions,
            text: FlutterI18n.translate(
              context,
              "lesson_screen.podcast",
            ),
            icon: Icon(
              Icons.music_note,
              color: Style.of(context).colors.content2,
              size: whenDevice(
                context,
                large: 25,
                tablet: 50,
              ),
            ),
            onTap: () => openPodcastModal(
                context, AnalyticsConstants.screenPremiumCard),
          ),
        ],
      ),
    );
  }

  Future<void> _openLectureNotesScreen(BuildContext context) async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Lecture Notes Screen.
    await Navigator.of(context).pushNamed(
             Routes.lectureNotes,
             arguments: LectureNotesScreenData(videoId: video.id));
    resumePlayer();
  }

  Future<void> _openWhiteboardNotesScreen(BuildContext context) async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Whiteboard Notes Screen.
    await Navigator.of(context).pushNamed(
        Routes.whiteboardNotes,
        arguments: WhiteboardNotesScreenData(url: video.whiteboardNotesUrl));
    resumePlayer();
  }

  Widget _buildGrid(BuildContext context) {
    final iconSize =
        whenDevice(context, large: 20.0, tablet: 40.0, small: 15.0);
    return GridView.count(
      padding: EdgeInsets.zero,
      crossAxisCount: 2,
      shrinkWrap: true,
      childAspectRatio: 1.8,
      physics: ClampingScrollPhysics(),
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      children: <Widget>[
        if (video.hasLectureNotes == true)
          SquareFeatureButton(
            color: Style.of(context).colors.premium,
            text: FlutterI18n.translate(context, "lesson_screen.lecture_notes"),
            icon: Icon(
              Icons.library_books,
              color: Style.of(context).colors.content2,
              size: iconSize,
            ),
            onTap: () => {
              pausePlayer(),
              _openLectureNotesScreen(context)
            },
          ),
        if (video.whiteboardNotesUrl != null)
          SquareFeatureButton(
            color: Color(0xFFe344ff),
            text: FlutterI18n.translate(
                context, "lesson_screen.whiteboard_notes"),
            icon: SvgPicture.asset(
              Style.of(context).svgAsset.notes,
              height: iconSize,
            ),
            onTap: () => {
              pausePlayer(),
              _openWhiteboardNotesScreen(context)
            },
          ),
        if (video.flashcardsCount != 0)
          SquareFeatureButton(
            color: Style.of(context).colors.accent,
            text: FlutterI18n.translate(context, "common.flash_cards"),
            icon: SvgPicture.asset(
              Style.of(context).svgAsset.flashcards,
              color: Style.of(context).colors.content2,
              height: iconSize,
            ),
            onTap: () => {
              pausePlayer(),
              Navigator.of(context).pushNamed(
                Routes.flashCard,
                arguments: FlashcardsStackArguments(
                    videoId: video.id,
                    source: AnalyticsConstants.screenLessonVideo),
              ),
            },
          ),
        if (video.questionsCount != 0)
          SquareFeatureButton(
            color: Style.of(context).colors.questions,
            text: FlutterI18n.translate(context, "common.questions"),
            icon: SvgPicture.asset(
              Style.of(context).svgAsset.questions,
              height: iconSize,
              color: Style.of(context).colors.content2,
            ),
            onTap: () => {
              pausePlayer(),
              Navigator.of(context).pushNamed(
                Routes.multipleChoiceQuestion,
                arguments: MultipleChoiceQuestionScreenArguments(
                  screenName: video.name,
                  videoId: video.id,
                  source: AnalyticsConstants.screenLessonVideo
                ),
              ),
            },
          ),
      ],
    );
  }
}
