import 'package:Medschoolcoach/repository/repository_result.dart';
import 'package:Medschoolcoach/widgets/app_bars/custom_app_bar.dart';
import 'package:Medschoolcoach/widgets/navigation_bar/navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:Medschoolcoach/utils/super_state/super_state.dart';
import 'package:Medschoolcoach/utils/api/models/lecturenote.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:Medschoolcoach/utils/style_provider/style.dart';
import 'package:Medschoolcoach/widgets/progrss_bar/progress_bar.dart';

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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
          (_) => _fetchLectureNote(
        forceApiRequest: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(),
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
    });
  }

  Widget _buildContent() {
    double width;
    width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.all(20),
      child: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: <Widget>[
            const SizedBox(height: 15),
            _loading
                ? Center(
                    child: ProgressBar(),
                  )
                : Html(
                    useRichText: true,
                    data: _htmlContent ?? "",
                    defaultTextStyle:
                        Style.of(context).font.normal.copyWith(fontSize: 20),
                    customTextAlign: (_) => TextAlign.center,
                  ),
          ],
        ),
      ),
    );
  }
}
