import 'package:Medschoolcoach/providers/analytics_constants.dart';
import 'package:Medschoolcoach/utils/navigation/routes.dart';
import 'package:Medschoolcoach/utils/responsive_fonts.dart';
import 'package:Medschoolcoach/utils/sizes.dart';
import 'package:Medschoolcoach/utils/style_provider/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum NavigationPage {
  Home,
  More,
  Search,
  Tutoring,
  None,
  Schedule,
}

class NavigationBar extends StatelessWidget {
  final NavigationPage page;
  final VoidCallback runOnTap;

  const NavigationBar({
    this.page = NavigationPage.None,
    this.runOnTap,
  });

  @override
  Widget build(BuildContext context) {
    final iconSize = whenDevice(context, large: 40.0, tablet: 64.0);
    return Container(
      height: whenDevice(
        context,
        large: 60,
        tablet: 100,
      ),
      margin:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewPadding.bottom),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Column(
            children: <Widget>[
              _customInkWell(
                context,
                key: const Key("home"),
                icon: SvgPicture.asset(
                  page == NavigationPage.Home
                      ? Style.of(context).svgAsset.homeActive
                      : Style.of(context).svgAsset.home,
                  height: iconSize,
                  width: iconSize,
                ),
                onPressed: () => _openHomeScreen(context),
              ),
              Text(
                FlutterI18n.translate(
                  context,
                  "navigation_bar.home",
                ),
                style: _getTextStyle(
                  context,
                  NavigationPage.Home,
                ),
              ),
            ],
          ),
          Column(
            children: <Widget>[
              _customInkWell(
                context,
                key: const Key("tutoring"),
                icon: SvgPicture.asset(
                  page == NavigationPage.Tutoring
                      ? Style.of(context).svgAsset.tutoringNavigationIconActive
                      : Style.of(context).svgAsset.tutoringNavigationIcon,
                  height: iconSize,
                  width: iconSize,
                ),
                onPressed: () => _openTutoringScreen(context),
              ),
              Text(
                FlutterI18n.translate(context, "navigation_bar.tutoring"),
                style: normalResponsiveFont(
                  context,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          Column(
            children: <Widget>[
              InkWell(
                borderRadius: BorderRadius.all(
                  Radius.circular(50),
                ),
                splashColor: Style.of(context).colors.accent.withOpacity(0.2),
                key: const Key("schedule"),
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: SvgPicture.asset(
                    page == NavigationPage.Schedule
                        ? Style.of(context).svgAsset.scheduleActive
                        : Style.of(context).svgAsset.schedule,
                    height: iconSize - 9,
                    width: iconSize - 9,
                  ),
                ),
                onTap: () => _openScheduleScreen(context),
              ),
              Text(
                FlutterI18n.translate(context, "navigation_bar.schedule"),
                style: _getTextStyle(
                  context,
                  NavigationPage.Schedule,
                ),
              ),
            ],
          ),
          Column(
            children: <Widget>[
              _customInkWell(
                context,
                key: const Key("search"),
                icon: SvgPicture.asset(
                  page == NavigationPage.Search
                      ? Style.of(context).svgAsset.searchActive
                      : Style.of(context).svgAsset.search,
                  height: iconSize,
                  width: iconSize,
                ),
                onPressed: () => _openSearchScreen(context),
              ),
              Text(
                FlutterI18n.translate(context, "navigation_bar.search"),
                style: _getTextStyle(
                  context,
                  NavigationPage.Search,
                ),
              ),
            ],
          ),
          Column(
            children: <Widget>[
              _customInkWell(
                context,
                key: const Key("more"),
                icon: SvgPicture.asset(
                  page == NavigationPage.More
                      ? Style.of(context).svgAsset.close
                      : Style.of(context).svgAsset.more,
                  height: iconSize,
                  width: iconSize,
                  color: Style.of(context).colors.content,
                ),
                onPressed: () => _openMoreScreenOrClose(context),
              ),
              Text(
                FlutterI18n.translate(
                  context,
                  page == NavigationPage.More
                      ? "navigation_bar.close"
                      : "navigation_bar.more",
                ),
                style: normalResponsiveFont(
                  context,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _openSearchScreen(BuildContext context) {
    if (page == NavigationPage.Search) return;
    runOnTap?.call();
    Navigator.of(context).pushNamed(Routes.search);
  }

  void _openHomeScreen(BuildContext context) {
    if (page == NavigationPage.Home) return;
    runOnTap?.call();
    Navigator.of(context).pushNamed(Routes.home);
  }

  void _openScheduleScreen(BuildContext context) {
    if (page == NavigationPage.Schedule) return;
    runOnTap?.call();
    Navigator.of(context)
        .pushNamed(Routes.schedule, arguments: AnalyticsConstants.screenHome);
  }

  void _openTutoringScreen(BuildContext context) {
    if (page == NavigationPage.Tutoring) return;
    runOnTap?.call();
    Routes.navigateToTutoringScreen(context, AnalyticsConstants.screenHome,
        isNavBar: true);
  }

  void _openMoreScreenOrClose(BuildContext context) {
    runOnTap?.call();
    if (page == NavigationPage.More)
      Navigator.of(context).pop();
    else
      Navigator.of(context).pushNamed(Routes.more);
  }

  TextStyle _getTextStyle(
    BuildContext context,
    NavigationPage thisPage,
  ) {
    if (thisPage == page)
      return normalResponsiveFont(
        context,
        fontColor: FontColor.Accent,
        fontWeight: FontWeight.w500,
      );
    return normalResponsiveFont(
      context,
      fontWeight: FontWeight.w500,
    );
  }

  InkWell _customInkWell(
    BuildContext context, {
    @required SvgPicture icon,
    @required Function onPressed,
    Key key,
  }) {
    return InkWell(
      key: key,
      borderRadius: BorderRadius.all(Radius.circular(50)),
      splashColor: Style.of(context).colors.accent.withOpacity(0.2),
      onTap: onPressed,
      child: icon,
    );
  }
}
