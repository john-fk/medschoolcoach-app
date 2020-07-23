import 'dart:io';

import 'package:Medschoolcoach/repository/repository_result.dart';

import 'package:Medschoolcoach/ui/lesson/lesson_video_screen.dart';
import 'package:Medschoolcoach/utils/api/api_services.dart';
import 'package:Medschoolcoach/utils/api/models/search_result.dart';
import 'package:Medschoolcoach/utils/api/models/video.dart';
import 'package:Medschoolcoach/utils/navigation/routes.dart';
import 'package:Medschoolcoach/utils/style_provider/style.dart';
import 'package:Medschoolcoach/utils/super_state/super_state.dart';
import 'package:Medschoolcoach/widgets/empty_state/empty_state.dart';
import 'package:Medschoolcoach/widgets/list_cells/search_list_cell.dart';
import 'package:Medschoolcoach/widgets/navigation_bar/navigation_bar.dart';
import 'package:Medschoolcoach/widgets/progrss_bar/progress_bar.dart';
import 'package:Medschoolcoach/widgets/search_bar/search_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

class SearchScreen extends StatefulWidget {
  final String searchPhrase;

  const SearchScreen({this.searchPhrase});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();
  final _searchInputFocusNode = FocusNode();
  RepositoryResult<SearchResult> _repositoryResult;

  bool _loading = false;
  bool _tooShortTextError = false;

  @override
  void initState() {
    super.initState();
    if (widget.searchPhrase != null) {
      _searchController.text = widget.searchPhrase;
      WidgetsBinding.instance.addPostFrameCallback((_) => _search());
    }
  }

  Future<bool> onWillPop() async {
    if (Platform.isAndroid) SystemNavigator.pop();
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          bottomNavigationBar: NavigationBar(
            page: NavigationPage.Search,
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(
                left: 12,
                right: 12,
                top: 12,
              ),
              child: Column(
                children: <Widget>[
                  SearchBar(
                    searchFunction: _search,
                    searchController: _searchController,
                    autoFocus: _searchController.text.isEmpty,
                    focusNode: _searchInputFocusNode,
                    clearFunction: _clear,
                  ),
                  Expanded(
                    child: _tooShortTextError
                        ? Center(
                            child: Text(
                              FlutterI18n.translate(
                                context,
                                "search.text_too_short",
                              ),
                              style: Style.of(context).font.error,
                              textAlign: TextAlign.center,
                            ),
                          )
                        : _loading
                            ? Center(
                                child: ProgressBar(),
                              )
                            : _repositoryResult
                                    is RepositorySuccessResult<SearchResult>
                                ? _buildListView()
                                : _repositoryResult != null
                                    ? EmptyState(
                                        repositoryResult: _repositoryResult,
                                      )
                                    : Container(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchInputFocusNode.dispose();
    super.dispose();
  }

  Widget _buildListView() {
    List<Video> videos = SuperStateful.of(context).searchResult.videos
      ..sort(
        (a, b) => a.order.compareTo(b.order),
      );

    if (videos.isEmpty) {
      return Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          const SizedBox(
            height: 200,
          ),
          Center(
            child: Text(
              FlutterI18n.translate(
                context,
                "errors.no_search_result",
              ),
              textAlign: TextAlign.center,
              style: Style.of(context).font.normalBig,
            ),
          ),
        ],
      );
    } else {
      return ListView.separated(
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        itemCount: videos.length,
        separatorBuilder: (context, index) => Container(
          height: 1,
          color: Style.of(context).colors.separator,
        ),
        itemBuilder: (context, index) => SearchListCell(
          cellData: SearchListCellData(
            imagePath: videos[index].image,
            lessonName: videos[index].name,
            percentages: videos[index].progress != null
                ? videos[index].progress.percentage
                : 0,
            totalLength: videos[index].length,
            sectionName: videos[index].section.name,
            videoId: videos[index].id,
            bookmarked: videos[index].favourite ?? false,
          ),
          onTap: () {
            Navigator.of(context).pushNamed(
              Routes.lesson,
              arguments: LessonVideoScreenArguments(
                order: videos[index].order,
                topicId: videos[index].topicId,
              ),
            );
          },
        ),
      );
    }
  }

  Future<void> _search() async {
    if (_searchController.text.length < 2) {
      setState(() {
        _tooShortTextError = true;
      });
    } else {
      if (!_loading) {
        _searchInputFocusNode.unfocus();
        setState(() {
          _tooShortTextError = false;
          _loading = true;
        });
        final result = await SuperStateful.of(context).updateSearchResult(
          SearchArguments(
            searchingTerm: _searchController.text,
          ),
        );
        setState(() {
          _loading = false;
          _repositoryResult = result;
        });
        _searchInputFocusNode.unfocus();
      }
    }
  }

  Future<void> _clear() async {
    setState(() {
      _repositoryResult = null;
    });
  }
}
