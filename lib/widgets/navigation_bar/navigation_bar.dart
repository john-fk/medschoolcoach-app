import 'package:Medschoolcoach/utils/navigation/routes.dart';
import 'package:Medschoolcoach/utils/responsive_fonts.dart';
import 'package:Medschoolcoach/utils/sizes.dart';
import 'package:Medschoolcoach/utils/style_provider/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

enum NavigationPage {
  Home,
  Profile,
  Practice,
  Tutoring,
  None,
  Schedule,
  Progress
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
    final iconSize = whenDevice(context, large: 26.0, tablet: 46.0);
    return SafeArea(
      child: Container(
        height: whenDevice(
              context,
              large: 60,
              tablet: 100,
            ) +
            MediaQuery.of(context).viewPadding.bottom,
        decoration: BoxDecoration(
          border: Border(
              top: BorderSide(
                  width: 1.0, color: Colors.black.withOpacity(0.07))),
          color: Style.of(context).colors.background,
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                _customInkWell(context,
                    key: const Key("home"),
                    isSelected: page == NavigationPage.Home,
                    icon: Image(
                      image: AssetImage(page == NavigationPage.Home
                          ? Style.of(context).pngAsset.homeActive
                          : Style.of(context).pngAsset.home),
                      height: iconSize,
                      width: iconSize,
                    ),
                    onPressed: () => _openHomeScreen(context),
                    label: FlutterI18n.translate(
                      context,
                      "navigation_bar.home",
                    )),
                _customInkWell(context,
                    key: const Key("progress"),
                    isSelected: page == NavigationPage.Progress,
                    icon: Image(
                      image: AssetImage(page == NavigationPage.Progress
                          ? Style.of(context).pngAsset.progressActive
                          : Style.of(context).pngAsset.progress),
                      height: iconSize,
                      width: iconSize,
                    ),
                    onPressed: () => _openProgressScreen(context),
                    label: FlutterI18n.translate(
                      context,
                      "navigation_bar.progress",
                    )),
                _customInkWell(
                  context,
                  isSelected: page == NavigationPage.Schedule,
                  icon: Image(
                    image: AssetImage(page == NavigationPage.Schedule
                        ? Style.of(context).pngAsset.learnActive
                        : Style.of(context).pngAsset.learn),
                    height: iconSize,
                    width: iconSize,
                  ),
                  onPressed: () => _openScheduleScreen(context),
                  label: FlutterI18n.translate(context, "navigation_bar.learn"),
                ),
                _customInkWell(context,
                    key: const Key("practice"),
                    isSelected: page == NavigationPage.Practice,
                    icon: Image(
                        image: AssetImage(page == NavigationPage.Practice
                            ? Style.of(context).pngAsset.practiceActive
                            : Style.of(context).pngAsset.practice),
                        height: iconSize,
                        width: iconSize),
                    onPressed: () => _openPracticeScreen(context),
                    label: FlutterI18n.translate(
                      context,
                      "navigation_bar.practice",
                    )),
                _customInkWell(
                  context,
                  isSelected: page == NavigationPage.Profile,
                  key: const Key("profile"),
                  icon: Image(
                    image: AssetImage(page == NavigationPage.Profile
                        ? Style.of(context).pngAsset.profileActive
                        : Style.of(context).pngAsset.profile),
                    height: iconSize,
                    width: iconSize,
                  ),
                  onPressed: () => _openMoreScreenOrClose(context),
                  label:
                      FlutterI18n.translate(context, "navigation_bar.profile"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _openPracticeScreen(BuildContext context) {
    if (page == NavigationPage.Practice) return;
    runOnTap?.call();
    Navigator.of(context)
        .pushNamed(Routes.practiceScreen, arguments: "navigation_bar");
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
        .pushNamed(Routes.schedule, arguments: "navigation_bar");
  }

  void _openProgressScreen(BuildContext context) {
    if (page == NavigationPage.Progress) return;
    runOnTap?.call();
    Navigator.pushNamed(context, Routes.progressScreen,
        arguments: "navigation_bar");
  }

  void _openMoreScreenOrClose(BuildContext context) {
    runOnTap?.call();
    if (page != NavigationPage.Profile)
      Navigator.of(context)
          .pushNamed(Routes.profile_screen, arguments: "navigation_bar");
  }

  InkWell _customInkWell(
    BuildContext context, {
    @required Image icon,
    @required Function onPressed,
    @required String label,
    @required bool isSelected,
    Key key,
  }) {
    return InkWell(
      key: key,
      borderRadius: BorderRadius.all(Radius.circular(50)),
      splashColor: Style.of(context).colors.accent.withOpacity(0.2),
      onTap: onPressed,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          icon,
          Text(label,
              style: smallResponsiveFont(context,
                  fontWeight: FontWeight.w500,
                  fontColor:
                      isSelected ? FontColor.Accent : FontColor.Unselected))
        ],
      ),
    );
  }
}
