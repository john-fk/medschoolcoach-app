import 'package:Medschoolcoach/providers/analytics_constants.dart';
import 'package:Medschoolcoach/providers/analytics_provider.dart';
import 'package:Medschoolcoach/repository/repository_result.dart';
import 'package:Medschoolcoach/utils/api/models/bookmark.dart';
import 'package:Medschoolcoach/utils/super_state/super_state.dart';
import 'package:Medschoolcoach/widgets/app_bars/custom_app_bar.dart';
import 'package:Medschoolcoach/widgets/empty_state/refreshing_empty_state.dart';
import 'package:Medschoolcoach/widgets/list_cells/bookmark_list_cell.dart';
import 'package:Medschoolcoach/widgets/navigation_bar/navigation_bar.dart';
import 'package:Medschoolcoach/widgets/progress_bar/progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:injector/injector.dart';

class BookmarksScreen extends StatefulWidget {
  @override
  _BookmarksScreenState createState() => _BookmarksScreenState();
}

class _BookmarksScreenState extends State<BookmarksScreen> {
  final AnalyticsProvider _analyticsProvider =
      Injector.appInstance.getDependency<AnalyticsProvider>();

  bool _loading = true;
  RepositoryErrorResult _error;
  List<Bookmark> _bookmarks;

  @override
  void initState() {
    super.initState();
    _analyticsProvider.logScreenView(AnalyticsConstants.screenBookMarkedVideos,
        AnalyticsConstants.screenMore);
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _fetchData(
        forceApiRequest: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _bookmarks = SuperStateful.of(context).bookmarksList;
    return Scaffold(
      bottomNavigationBar: NavigationBar(),
      body: Column(
        children: <Widget>[
          CustomAppBar(
              title: FlutterI18n.translate(
                context,
                "bookmarks.title",
              ),
              subTitle: FlutterI18n.translate(
                context,
                "app_bar.section_subtitle",
                {
                  "number": _getLessonsCount().toString(),
                },
              )),
          Expanded(
            child: _getContent(context),
          ),
        ],
      ),
    );
  }

  int _getLessonsCount() {
    int initLength = 0;
    _bookmarks.forEach(
        (bookmark) => initLength = initLength + bookmark.videos.length);
    return initLength;
  }

  Widget _getContent(BuildContext context) {
    if (_loading)
      return Center(
        child: ProgressBar(),
      );
    if (_error != null)
      return RefreshingEmptyState(
        refreshFunction: () => _fetchData(
          forceApiRequest: true,
        ),
      );
    if (_bookmarks.isEmpty || _getLessonsCount() == 0) {
      return RefreshIndicator(
        onRefresh: () => _fetchData(
          forceApiRequest: true,
        ),
        child: Stack(
          children: <Widget>[
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.bookmark_border,
                    size: 40,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(FlutterI18n.translate(
                    context,
                    "bookmarks.empty_state",
                  )),
                ],
              ),
            ),
            ListView()
          ],
        ),
      );
    }
    return _buildSubjectsList();
  }

  Widget _buildSubjectsList() {
    return RefreshIndicator(
      onRefresh: () => _fetchData(
        forceApiRequest: true,
      ),
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
        ),
        itemCount: _bookmarks.length,
        physics: AlwaysScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          return _buildListItem(index);
        },
      ),
    );
  }

  Widget _buildListItem(int index) {
    return BookmarkListCell(
      subjectName: _bookmarks[index].name,
      initiallyExpanded: _bookmarks.length == 1,
      videos: _bookmarks[index].videos
        ..sort(
          (a, b) => a.order.compareTo(b.order),
        ),
      onVideoRemoved: _onVideoRemoved,
    );
  }

  Future<void> _fetchData({
    bool forceApiRequest = false,
  }) async {
    setState(() {
      _loading = true;
      _error = null;
    });

    final result = await SuperStateful.of(context).updateBookmarks(
      forceApiRequest: forceApiRequest,
    );

    if (result is RepositoryErrorResult<List<Bookmark>>) {
      setState(() {
        _error = result;
        _loading = false;
      });
    } else {
      setState(() {
        _loading = false;
      });
    }
  }

  void _onVideoRemoved() {
    setState(() {});
  }
}
