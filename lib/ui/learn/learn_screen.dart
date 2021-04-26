import 'package:Medschoolcoach/providers/analytics_constants.dart';
import 'package:Medschoolcoach/providers/analytics_provider.dart';
import 'package:Medschoolcoach/ui/learn/lesson_tab.dart';
import 'package:Medschoolcoach/ui/learn/schedule_tab.dart';
import 'package:Medschoolcoach/utils/responsive_fonts.dart';
import 'package:Medschoolcoach/utils/sizes.dart';
import 'package:Medschoolcoach/utils/style_provider/style.dart';
import 'package:Medschoolcoach/utils/super_state/super_state.dart';
import 'package:Medschoolcoach/widgets/navigation_bar/navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:injector/injector.dart';

class LearnScreen extends StatefulWidget {
  final String source;

  const LearnScreen(this.source);

  @override
  _LearnScreenState createState() => _LearnScreenState();
}

class _LearnScreenState extends State<LearnScreen>
    with
        AutomaticKeepAliveClientMixin<LearnScreen>,
        SingleTickerProviderStateMixin {
  final AnalyticsProvider _analyticsProvider =
      Injector.appInstance.getDependency<AnalyticsProvider>();
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _analyticsProvider.logScreenView(
        AnalyticsConstants.screenLearn, widget.source);
    _tabController = TabController(length: 2, vsync: this, initialIndex: 0);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        bottomNavigationBar: NavigationBar(
          page: NavigationPage.Schedule,
        ),
        appBar: AppBar(
          brightness: Brightness.light,
          backgroundColor: Colors.white,
          shadowColor: Colors.black12,
          elevation: 8,
          title: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: whenDevice(context, large: 8, medium: 4, small: 4)),
            child: Text(
              "Learn",
              style: greatResponsiveFont(context, fontWeight: FontWeight.w700),
            ),
          ),
          centerTitle: false,
          titleSpacing: 12,
          automaticallyImplyLeading: false,
          bottom: ShrinkedTabBar(TabBar(
            controller: _tabController,
            indicatorWeight: 3,
            labelColor: Style.of(context).colors.accent,
            labelStyle:
                normalResponsiveFont(context, fontWeight: FontWeight.w700),
            unselectedLabelColor:
                Style.of(context).colors.content.withOpacity(0.6),
            indicatorColor: Style.of(context).colors.accent,
            isScrollable: true,
            indicatorSize: TabBarIndicatorSize.tab,
            onTap: (int index) {
              var tabName = index == 0 ? "tab_schedule" : "tab_lesson";
              _analyticsProvider
                  .logEvent("switch_learn_tab", params: {"name": tabName});
            },
            tabs: [
              Padding(
                padding: EdgeInsets.only(
                    bottom: 10.0, right: 5, left: isTablet(context) ? 2 : 0),
                child: Text("Schedule"),
              ),
              Padding(
                  padding: EdgeInsets.only(
                      bottom: 10.0, left: 5, right: isTablet(context) ? 2 : 0),
                  child: Text("All Lessons")),
            ],
          )),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [ScheduleTab(), LessonTab()],
        ));
  }

  @override
  bool get wantKeepAlive => true;
}

class ShrinkedTabBar extends StatelessWidget with PreferredSizeWidget {
  final Widget tabBar;

  ShrinkedTabBar(this.tabBar);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [tabBar, Expanded(child: Container())],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
