import 'dart:io';

import 'package:Medschoolcoach/config.dart';
import 'package:Medschoolcoach/providers/analytics_constants.dart';
import 'package:Medschoolcoach/providers/analytics_provider.dart';
import 'package:Medschoolcoach/ui/empty_state/empty_state.dart';
import 'package:Medschoolcoach/ui/home/get_started.dart';
import 'package:Medschoolcoach/ui/home/home_schedule.dart';
import 'package:Medschoolcoach/ui/home/home_section.dart';
import 'package:Medschoolcoach/ui/home/recently_watched.dart';
import 'package:Medschoolcoach/utils/navigation/routes.dart';
import 'package:Medschoolcoach/utils/sizes.dart';
import 'package:Medschoolcoach/utils/style_provider/style.dart';
import 'package:Medschoolcoach/utils/super_state/super_state.dart';
import 'package:Medschoolcoach/widgets/app_bars/home_app_bar.dart';
import 'package:Medschoolcoach/widgets/cards/practice_section_card.dart';
import 'package:Medschoolcoach/widgets/navigation_bar/navigation_bar.dart';
import 'package:Medschoolcoach/widgets/progress_bar/progress_bar.dart';
import 'package:Medschoolcoach/widgets/search_bar/search_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:injector/injector.dart';

class HomeScreen extends StatefulWidget {
  final String source;

  const HomeScreen({Key key, this.source}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AnalyticsProvider _analyticsProvider =
      Injector.appInstance.getDependency<AnalyticsProvider>();

  bool _scheduleLoading = true;
  bool _lastWatchedLoading = true;
  static final FlutterLocalNotificationsPlugin notifsPlugin =
  FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    _analyticsProvider.logScreenView(
        AnalyticsConstants.screenHome, widget.source);
    WidgetsBinding.instance.addPostFrameCallback(
      (_) async {
        _fetchLastWatched();
        _fetchSchedule(forceApiRequest: true);

        final NotificationAppLaunchDetails notificationAppLaunchDetails =
            await notifsPlugin.getNotificationAppLaunchDetails();

        if (notificationAppLaunchDetails.didNotificationLaunchApp == true
            && Config.enteredAppFromQOTDNotification == true) {
          print("handling notif from home and marking false");
          Config.enteredAppFromQOTDNotification = false;
          Navigator.pushNamed(context,
              Routes.questionOfTheDayScreen, arguments: "notification");
        }
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
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: whenDevice(context, large: 8, medium: 4, small: 4)),
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
      ),
    );
  }

  Widget _buildContent() {
    var recentlyWatched = SuperStateful.of(context).recentlyWatched;
    var todaySchedule = SuperStateful.of(context).todaySchedule;

    if (_lastWatchedLoading && _scheduleLoading) {
      return _buildLoading();
    } else if (!_lastWatchedLoading
        && !_scheduleLoading
        && recentlyWatched == null
        && todaySchedule == null) {
      return EmptyStateView(
          title: FlutterI18n.translate(
              context,
              "empty_state.title"),
          message: FlutterI18n.translate(
              context,
              "empty_state.message"),
          ctaText: FlutterI18n.translate(
              context,
              "empty_state.button"),
          image: Image.asset(Style.of(context).pngAsset.emptyState),
          onTap: () {
            _lastWatchedLoading = true;
            _scheduleLoading = true;
            _refresh();
      });
    }
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

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed(Routes.search);
                },
                child: Hero(
                    tag: "search_bar",
                    child: SearchBar(
                      isEnabled: false,
                    ))),
          ),
          SizedBox(
            height: 20,
          ),
          _buildPracticeSection(),
          const SizedBox(
            height: 20,
          ),
          _buildOnboardingView(),
          _buildRecentlyWatchedSection(),
          const SizedBox(
            height: 20,
          ),
          _buildTodaySchedule(),
          // _buildGlobalProgress(),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  Widget _buildOnboardingView() {
    final _recentlyWatched = SuperStateful.of(context).recentlyWatched;
    if (_recentlyWatched == null) {
      return GetStarted();
    } else {
      return Container();
    }
  }

  Widget _buildRecentlyWatchedSection() {
    final _recentlyWatched = SuperStateful.of(context).recentlyWatched;
    if (_recentlyWatched == null) {
      return Container();
    }

    return RecentlyWatched(
      recentlyWatched: _recentlyWatched,
      analyticsProvider: _analyticsProvider,
    );
  }

  Widget _buildTodaySchedule() {
    final _todaySchedule = SuperStateful.of(context).todaySchedule;
    if (!_scheduleLoading && (_todaySchedule?.items?.isNotEmpty ?? false)) {
      return HomeSchedule(analyticsProvider: _analyticsProvider);
    } else {
      return Container();
    }
  }

  Future<void> _fetchLastWatched() async {
    var recentlyWatched = SuperStateful.of(context).recentlyWatched;
    setState(() {
      _lastWatchedLoading = recentlyWatched == null ? true : false;
    });

    await SuperStateful.of(context).updateRecentlyWatchedVideo();
    setState(() {
      _lastWatchedLoading = false;
    });
  }

  Future<void> _fetchSchedule({
    bool forceApiRequest,
  }) async {
    var todaySchedule = SuperStateful.of(context).todaySchedule;
    setState(() {
      _scheduleLoading = todaySchedule == null ? true : false;
    });

    await SuperStateful.of(context).updateTodaySchedule(
      forceApiRequest: true,
    );

    setState(() {
      _scheduleLoading = false;
    });
  }

  Future<void> _refresh() async {
    _fetchLastWatched();
    _fetchSchedule(forceApiRequest: true);
    return null;
  }

  Widget _buildPracticeSection() {
    return Container(
        child: HomeSection(
      sectionTitle: FlutterI18n.translate(context, "home_screen.practice"),
      sectionWidget: GridView.count(
        primary: false,
        shrinkWrap: true,
        padding: const EdgeInsets.all(0),
        crossAxisSpacing: 4,
        childAspectRatio: 1.8 / 1,
        mainAxisSpacing: 4,
        crossAxisCount: 2,
        children: <Widget>[
          PracticeCard(
              bgColor: Style.of(context).colors.premium,
              text: FlutterI18n.translate(context, "home_screen.lessons"),
              iconData: Icons.play_circle_outline,
              route: Routes.videos),
          PracticeCard(
            bgColor: Style.of(context).colors.accent4,
            text: FlutterI18n.translate(
                context, "home_screen.question_of_the_day"),
            iconData: Icons.forum_outlined,
            route: Routes.questionOfTheDayScreen,
          ),
          PracticeCard(
              bgColor: Style.of(context).colors.accent,
              text: FlutterI18n.translate(context, "home_screen.flashcards"),
              iconData: Icons.bolt,
              route: Routes.flashCardsMenu),
          PracticeCard(
              bgColor: Style.of(context).colors.questions,
              text: FlutterI18n.translate(context, "home_screen.question_bank"),
              iconData: Icons.help_outline_rounded,
              route: Routes.questionBank),
        ],
      ),
    ));
  }
}
