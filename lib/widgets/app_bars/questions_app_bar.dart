import 'package:Medschoolcoach/providers/analytics_constants.dart';
import 'package:Medschoolcoach/providers/analytics_provider.dart';
import 'package:Medschoolcoach/repository/questions_repository.dart';
import 'package:Medschoolcoach/repository/repository_result.dart';
import 'package:Medschoolcoach/utils/responsive_fonts.dart';
import 'package:Medschoolcoach/utils/sizes.dart';
import 'package:Medschoolcoach/utils/style_provider/style.dart';
import 'package:Medschoolcoach/widgets/buttons/pop_back_button.dart';
import 'package:flutter/material.dart';
import 'package:injector/injector.dart';

// ignore: must_be_immutable
class QuestionAppBar extends StatefulWidget {
  final String title;
  final String subTitle;
  final int currentQuestion;
  final int questionsSize;
  final String questionId;
  final String stem;
  bool isBookmarked;
  VoidCallback onBookmarkTap;
  bool showBookmark;

  QuestionAppBar({
    @required this.title,
    Key key,
    this.subTitle,
    this.currentQuestion,
    this.stem,
    this.questionsSize,
    this.questionId,
    this.isBookmarked,
    this.onBookmarkTap,
    this.showBookmark = true
  }) : super(key: key);

  @override
  _QuestionAppBarState createState() => _QuestionAppBarState();
}

class _QuestionAppBarState extends State<QuestionAppBar> {
  final QuestionsRepository _questionsRepository =
      Injector.appInstance.getDependency<QuestionsRepository>();
  final AnalyticsProvider _analyticsProvider =
      Injector.appInstance.getDependency<AnalyticsProvider>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          color: Colors.transparent,
          padding: EdgeInsets.fromLTRB(
            10,
            MediaQuery.of(context).padding.top,
            10,
            10,
          ),
          child: Padding(
            padding: EdgeInsets.only(
              top: 30,
              bottom: 16,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                InkWell(
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: PopBackButton(),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        widget.title ?? "",
                        style: greatResponsiveFont(
                          context,
                          fontColor: FontColor.Content2,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (widget.subTitle != null)
                        Container(
                          margin: const EdgeInsets.only(top: 8),
                          child: Text(
                            widget.subTitle,
                            style: normalResponsiveFont(
                              context,
                              fontColor: FontColor.Content2,
                            ),
                          ),
                        )
                    ],
                  ),
                ),
                widget.currentQuestion != null &&
                        widget.questionsSize != null &&
                        widget.questionsSize != 0
                    ? Padding(
                        padding: const EdgeInsets.only(
                          right: 8.0,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Container(
                              decoration: BoxDecoration(
                                color: Style.of(context).colors.content2,
                                borderRadius: BorderRadius.circular(3),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 4,
                                  horizontal: 10,
                                ),
                                child: Text(
                                  "${widget.currentQuestion}/${widget.questionsSize}",
                                  style: smallResponsiveFont(
                                    context,
                                    fontWeight: FontWeight.w500,
                                    fontColor: FontColor.Accent,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            if(widget.showBookmark)
                            _drawBookmark()
                          ],
                        ),
                      )
                    : Container(),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Container(
            height: 1,
            color: Colors.white.withOpacity(0.2),
          ),
        )
      ],
    );
  }

  InkWell _drawBookmark() {
    final size = whenDevice(context, large: 25.0, tablet: 40.0);
    return InkWell(
      child: widget.isBookmarked
          ? Icon(
              Icons.bookmark,
              color: Colors.white,
              size: size,
            )
          : Icon(
              Icons.bookmark_border,
              color: Colors.white,
              size: size,
            ),
      onTap: _onTap,
    );
  }

  Future<void> _onTap() async {
    bool initialValue = widget.isBookmarked;

    setState(() {
      widget.isBookmarked = !initialValue;
    });

    RepositoryResult response;
    if (initialValue) {
      response = await _questionsRepository.deleteFavouriteQuestion(
        questionId: widget.questionId,
      );
    } else {
      response = await _questionsRepository.addFavouriteQuestion(
          questionId: widget.questionId);
    }
    if (response is RepositoryErrorResult) {
      setState(() {
        widget.isBookmarked = initialValue;
      });
    } else {
      widget.onBookmarkTap();
    }
    _analyticsProvider.logEvent(initialValue
        ? AnalyticsConstants.tapQuestionBookmarkRemove
        : AnalyticsConstants.tapQuestionBookmarkAdd,
        params: {
          AnalyticsConstants.keyQuestionId: widget.questionId,
          AnalyticsConstants.keyStem: widget.stem
        });
  }
}
