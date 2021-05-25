import 'package:Medschoolcoach/providers/analytics_constants.dart';
import 'package:Medschoolcoach/providers/analytics_provider.dart';
import 'package:Medschoolcoach/repository/repository_result.dart';
import 'package:Medschoolcoach/utils/api/models/lecturenote.dart';
import 'package:Medschoolcoach/utils/style_provider/style.dart' as medstyles;
import 'package:Medschoolcoach/utils/super_state/super_state.dart';
import 'package:Medschoolcoach/widgets/app_bars/custom_app_bar.dart';
import 'package:Medschoolcoach/widgets/progress_bar/progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:injector/injector.dart';

class LectureNotesScreenData {
  final String videoId;

  LectureNotesScreenData({
    @required this.videoId,
  });
}

class LectureNotesScreen extends StatefulWidget {
  final LectureNotesScreenData _lectureNotesScreenData;

  const LectureNotesScreen(this._lectureNotesScreenData);

  @override
  _LectureNotesScreenState createState() => _LectureNotesScreenState();
}

class _LectureNotesScreenState extends State<LectureNotesScreen> {
  final _scrollController = ScrollController();
  String _htmlContent = "";
  bool _loading = true;

  final AnalyticsProvider _analyticsProvider =
      Injector.appInstance.getDependency<AnalyticsProvider>();

  @override
  void initState() {
    super.initState();
    _analyticsProvider.logScreenView(AnalyticsConstants.screenLectureNotes,
        AnalyticsConstants.screenLessonVideo);
    WidgetsBinding.instance.addPostFrameCallback(
          (_) => _fetchLectureNote(
        forceApiRequest: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Column(
          children: <Widget>[
            CustomAppBar(
              title:
                  FlutterI18n.translate(context, "lesson_screen.lecture_notes"),
            ),
            Expanded(
              child: _buildContent(),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _fetchLectureNote({bool forceApiRequest = false}) async {
    final result = await SuperStateful.of(context).updateLectureNote(
      widget._lectureNotesScreenData.videoId,
      forceApiRequest: forceApiRequest,
    );
    setState(() {
      _loading = false;
      _htmlContent =
          (result as RepositorySuccessResult<LectureNote>).data.content;
      _htmlContent = _htmlContent.replaceAll("<sup>", "&#8288<sup>");
      _htmlContent = _htmlContent.replaceAll("<sub>", "&#8288<sub>");
    });
  }

  Widget _buildContent() {
    double width;
    width = MediaQuery.of(context).size.width;
    return Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
            controller: _scrollController,
            child: Column(children: <Widget>[
              const SizedBox(height: 15),
              _loading
                  ? Center(
                      child: ProgressBar(),
                    )
                  : Container(
                      margin: EdgeInsets.fromLTRB(0, 0, width/15, 0),
                      child: Html(
                        data: _htmlContent ?? "",
                        style: {
                          "html": Style.fromTextStyle(
                            medstyles.Style.of(context)
                                .font
                                .normal
                                .copyWith(fontSize: 20),
                          )
                        },
                      )),
            ])));
  }
}
