import 'dart:io';

import 'package:Medschoolcoach/repository/repository_result.dart';
import 'package:Medschoolcoach/ui/home/get_started.dart';
import 'package:Medschoolcoach/ui/home/home_schedule.dart';
import 'package:Medschoolcoach/ui/home/recently_watched.dart';
import 'package:Medschoolcoach/ui/home/sections_widget.dart';
import 'package:Medschoolcoach/utils/api/models/dashboard_schedule.dart';
import 'package:Medschoolcoach/utils/api/models/last_watched_response.dart';
import 'package:Medschoolcoach/utils/api/models/section.dart';
import 'package:Medschoolcoach/utils/api/models/statistics.dart';
import 'package:Medschoolcoach/utils/super_state/super_state.dart';
import 'package:Medschoolcoach/widgets/app_bars/home_app_bar.dart';
import 'package:Medschoolcoach/widgets/global_progress/global_progress_widget.dart';
import 'package:Medschoolcoach/widgets/navigation_bar/navigation_bar.dart';
import 'package:Medschoolcoach/widgets/progrss_bar/progress_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  RepositoryResult<List<Section>> _sectionsResult;
  RepositoryResult<DashboardSchedule> _scheduleResult;
  RepositoryResult<LastWatchedResponse> _lastWatchedResult;
  RepositoryResult<Statistics> _globalProgressResult;

  bool _sectionsLoading = true;
  bool _scheduleLoading = true;
  bool _lastWatchedLoading = true;
  bool _globalProgressLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => {
        _fetchLastWatched(),
        _fetchSchedule(forceApiRequest: false),
        _fetchCategories(forceApiRequest: false),
        _fetchStatistics(
          forceApiRequest: true,
        ),
      },
    );
  }

  Future<bool> onWillPop() async {
    if (Platform.isAndroid) SystemNavigator.pop();
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        bottomNavigationBar: NavigationBar(
          page: NavigationPage.Home,
        ),
        body: SafeArea(
          child: Column(
            children: <Widget>[
              HomeAppBar(),
              Expanded(
                child: _buildContent(),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (_sectionsLoading ||
        _scheduleLoading ||
        _lastWatchedLoading ||
        _globalProgressLoading) return _buildLoading();
    return _buildFetchedItems();
  }

  Widget _buildLoading() {
    return Center(
      child: ProgressBar(),
    );
  }

  Widget _buildFetchedItems() {
    return RefreshIndicator(
      onRefresh: _refresh,
      child: ListView(
        key: const Key("home_scroll"),
        shrinkWrap: true,
        children: <Widget>[
          const SizedBox(
            height: 8,
          ),
          if (_isInitialState()) GetStarted(),
          _buildRecentlyWatchedSection(),
          const SizedBox(
            height: 20,
          ),
          _buildTodaySchedule(),
          _buildGlobalProgress(),
          const SizedBox(
            height: 20,
          ),
          SectionsWidget(
            sectionsResult: _sectionsResult,
            sectionTitle: FlutterI18n.translate(
              context,
              "home_screen.categories",
            ),
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  bool _isInitialState() {
    bool response = true;
    final recentlyWatchedVideo = SuperStateful.of(context).recentlyWatched;
    if (recentlyWatchedVideo != null) response = false;
    if (_scheduleResult is RepositorySuccessResult<DashboardSchedule> &&
        (_scheduleResult as RepositorySuccessResult<DashboardSchedule>)
            .data
            .items
            .isNotEmpty &&
        !_scheduleLoading) response = false;
    if (_sectionsResult is RepositoryErrorResult) return false;
    return response;
  }

  Widget _buildGlobalProgress() {
    final stats = SuperStateful.of(context).globalStatistics;
    if (_globalProgressLoading || _isInitialState()) return Container();
    if (_globalProgressResult is RepositoryErrorResult || stats == null) {
      print("Global progress data fetch error");
      return Container();
    }
    return GlobalProgressWidget();
  }

  Widget _buildRecentlyWatchedSection() {
    final recentlyWatchedVideo = SuperStateful.of(context).recentlyWatched;
    if (_lastWatchedResult is RepositoryErrorResult ||
        recentlyWatchedVideo == null) {
      return Container();
    }
    return RecentlyWatched(
      recentlyWatched: recentlyWatchedVideo,
    );
  }

  Widget _buildTodaySchedule() {
    if (_scheduleResult is RepositorySuccessResult<DashboardSchedule> &&
        (_scheduleResult as RepositorySuccessResult<DashboardSchedule>)
            .data
            .items
            .isNotEmpty &&
        !_scheduleLoading) {
      return HomeSchedule();
    } else {
      return Container();
    }
  }

  Future<void> _fetchStatistics({
    bool forceApiRequest = false,
  }) async {
    setState(() {
      _globalProgressLoading = true;
    });
    final result = await SuperStateful.of(context).updateGlobalStatistics(
      forceApiRequest: forceApiRequest,
    );

    setState(() {
      _globalProgressLoading = false;
      _globalProgressResult = result;
    });
  }

  Future<void> _fetchLastWatched() async {
    setState(() {
      _lastWatchedLoading = true;
    });

    final result = await SuperStateful.of(context).updateRecentlyWatchedVideo();
    setState(() {
      _lastWatchedLoading = false;
      _lastWatchedResult = result;
    });
  }

  Future<void> _fetchCategories({
    bool forceApiRequest,
  }) async {
    setState(() {
      _sectionsLoading = true;
    });
    final result = await SuperStateful.of(context).updateSectionsList(
      forceApiRequest: forceApiRequest,
    );
    setState(() {
      _sectionsLoading = false;
      _sectionsResult = result;
    });
  }

  Future<void> _fetchSchedule({
    bool forceApiRequest,
  }) async {
    setState(() {
      _scheduleLoading = true;
    });

    var scheduleResult = await SuperStateful.of(context).updateTodaySchedule(
      forceApiRequest: true,
    );

    setState(() {
      _scheduleLoading = false;
      _scheduleResult = scheduleResult;
    });
  }

  Future<void> _refresh() async {
    _fetchLastWatched();
    _fetchCategories(forceApiRequest: true);
    _fetchSchedule(forceApiRequest: true);
    return null;
  }
}
