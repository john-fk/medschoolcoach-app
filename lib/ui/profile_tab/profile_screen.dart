import 'dart:io';

import 'package:Medschoolcoach/config.dart';
import 'package:Medschoolcoach/providers/analytics_constants.dart';
import 'package:Medschoolcoach/providers/analytics_provider.dart';
import 'package:Medschoolcoach/repository/user_repository.dart';
import 'package:Medschoolcoach/ui/onboarding/qotd_notifications.dart';
import 'package:Medschoolcoach/utils/external_navigation_utils.dart';
import 'package:Medschoolcoach/utils/format_date.dart';
import 'package:Medschoolcoach/utils/navigation/routes.dart';
import 'package:Medschoolcoach/utils/responsive_fonts.dart';
import 'package:Medschoolcoach/utils/sizes.dart';
import 'package:Medschoolcoach/utils/style_provider/style.dart';
import 'package:Medschoolcoach/utils/super_state/super_state.dart';
import 'package:Medschoolcoach/utils/user_manager.dart';
import 'package:Medschoolcoach/widgets/custom_expansion_tile/custom_expansion_tile.dart';
import 'package:Medschoolcoach/widgets/dialog/custom_dialog.dart';
import 'package:Medschoolcoach/widgets/list_cells/more_page_list_cell.dart';
import 'package:Medschoolcoach/widgets/navigation_bar/navigation_bar.dart';
import 'package:Medschoolcoach/widgets/refer_friend_cell/refer_friend_cell.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_svg/svg.dart';
import 'package:injector/injector.dart';

class ProfileTabScreen extends StatefulWidget {
  @override
  _ProfileTabScreenState createState() => _ProfileTabScreenState();
}

class _ProfileTabScreenState extends State<ProfileTabScreen> {
  final UserRepository _userRepository =
      Injector.appInstance.getDependency<UserRepository>();

  final AnalyticsProvider _analyticsProvider =
      Injector.appInstance.getDependency<AnalyticsProvider>();

  final UserManager _userManager =
      Injector.appInstance.getDependency<UserManager>();

  Future<bool> onWillPop() async {
    if (Platform.isAndroid) SystemNavigator.pop();
    return false;
  }

  @override
  void initState() {
    _analyticsProvider.logScreenView(
        AnalyticsConstants.screenMore, AnalyticsConstants.screenHome);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var horizontalInset =
        whenDevice(context, large: 4.0, medium: 0.0, small: 0.0);
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        bottomNavigationBar: NavigationBar(page: NavigationPage.Profile),
        appBar: AppBar(
          title: Padding(
            padding: EdgeInsets.only(left: horizontalInset),
            child: Text(
              "Profile",
              style: greatResponsiveFont(context, fontWeight: FontWeight.w700),
            ),
          ),
          elevation: 0,
          brightness: Brightness.light,
          backgroundColor: Colors.transparent,
          centerTitle: false,
          titleSpacing: 12,
          automaticallyImplyLeading: false,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            key: const Key("more_scroll"),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: Column(
                children: <Widget>[
                  MorePageListCell(
                      iconAssetName:
                          Style.of(context).svgAsset.profileMyAccount,
                      cellText: FlutterI18n.translate(
                        context,
                        "more_screen.my_account",
                      ),
                      onTap: () async {
                        await Navigator.of(context).pushNamed(Routes.profile,
                            arguments: AnalyticsConstants.screenMore);
                        setState(() {});
                      }),
                  //Question of The day
                  FutureBuilder<int>(
                      future: _userManager.getQuestionOfTheDayTime(),
                      builder: (context, snapshot) {
                        String questionOfTheDayStatus =
                            (snapshot.hasError || !snapshot.hasData)
                                ? "OFF"
                                : "ON";
                        return MorePageListCell(
                          iconAssetName: Style.of(context)
                              .svgAsset
                              .profileQuestionOfTheDay,
                          cellText: FlutterI18n.translate(
                            context,
                            "more_screen.question_of_the_day",
                          ),
                          trailing: questionOfTheDayStatus,
                          onTap: () async {
                            await Navigator.pushNamed(
                                context, Routes.scheduleQuestionOfTheDay,
                                arguments: Routes.profile_screen);
                            setState(() {});
                          },
                          trailingOpacity:
                              snapshot.hasError || !snapshot.hasData
                                  ? 0.5
                                  : 1.0,
                        );
                      }),
                  //Test Date
                  FutureBuilder<DateTime>(
                      future: _userManager.getTestDate(),
                      builder: (context, snapshot) {
                        String date = (snapshot.hasError || !snapshot.hasData)
                            ? ""
                            : formatDate(snapshot.data, "MM/dd/yyyy");
                        return MorePageListCell(
                          iconAssetName:
                              Style.of(context).svgAsset.profileTestDate,
                          cellText: FlutterI18n.translate(
                            context,
                            "more_screen.test_date",
                          ),
                          onTap: () async {
                            await Navigator.pushNamed(
                                context, Routes.scheduleTestDate,
                                arguments: Routes.profile_screen);
                            setState(() {});
                          },
                          trailing: date,
                        );
                      }),
                  //Study time per day
                  FutureBuilder<int>(
                      future: _userManager.getStudyTimePerDay(),
                      builder: (context, snapshot) {
                        String hours = (snapshot.hasError || !snapshot.hasData)
                            ? ""
                            : snapshot.data == 8
                                ? "${snapshot.data}+ hours"
                                : "${snapshot.data} hours";
                        return MorePageListCell(
                          iconAssetName:
                              Style.of(context).svgAsset.profileStopWatch,
                          cellText: FlutterI18n.translate(
                            context,
                            "more_screen.study_time_per_day",
                          ),
                          onTap: () async {
                            await Navigator.pushNamed(
                                context, Routes.timePerDay,
                                arguments: Routes.profile_screen);
                            setState(() {});
                          },
                          trailing: hours,
                        );
                      }),
                  MorePageListCell(
                      iconAssetName:
                          Style.of(context).svgAsset.profileBookmarkVideos,
                      cellText: FlutterI18n.translate(
                        context,
                        "bookmarks.title",
                      ),
                      onTap: () async { 
                        await Navigator.pushNamed(context, Routes.bookmarks);
                        setState(() {});
                      }),
                  MorePageListCell(
                    svgAsset: false,
                    iconAssetName: Style.of(context).pngAsset.support,
                    cellText: FlutterI18n.translate(
                      context,
                      "more_screen.support",
                    ),
                    onTap: () => Navigator.of(context).pushNamed(
                      Routes.contactSupport,
                    ),
                  ),
                  MorePageListCell(
                    iconAssetName: Style.of(context).svgAsset.profileLogout,
                    cellText: FlutterI18n.translate(
                      context,
                      "more_screen.logout",
                    ),
                    onTap: () {
                      _showLogoutDialog(context);
                    },
                  ),
                  Theme(
                    data: Theme.of(context)
                        .copyWith(dividerColor: Colors.transparent),
                    child: CustomExpansionTile(
                      children: _buildYoutubeLinks(),
                      title: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: whenDevice(
                            context,
                            large: 0,
                            tablet: 30,
                          ),
                        ),
                        child: Row(
                          children: <Widget>[
                            const SizedBox(
                              width: 10,
                            ),
                            SvgPicture.asset(
                              Style.of(context).svgAsset.youtube,
                              width: whenDevice(context, large: 17, tablet: 23),
                              height:
                                  whenDevice(context, large: 18, tablet: 24),
                            ),
                            const SizedBox(
                              width: 17,
                            ),
                            Text(
                              FlutterI18n.translate(
                                context,
                                "more_screen.youtube",
                              ),
                              style: normalResponsiveFont(context),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  MorePageListCell(
                    iconAssetName: Style.of(context).pngAsset.facebook,
                    cellText: FlutterI18n.translate(
                      context,
                      "more_screen.facebook",
                    ),
                    onTap: () => _openSocialMediaWebsite(Config.facebook),
                    svgAsset: false,
                  ),
                  MorePageListCell(
                    iconAssetName: Style.of(context).pngAsset.instagram,
                    cellText: FlutterI18n.translate(
                      context,
                      "more_screen.instagram",
                    ),
                    onTap: () => _openSocialMediaWebsite(Config.instagram),
                    svgAsset: false,
                  ),
                  ReferFriendCell(AnalyticsConstants.screenMore),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _openSocialMediaWebsite(String url) {
    ExternalNavigationUtils.openWebsite(url);
    _analyticsProvider.logEvent(AnalyticsConstants.tapSocialMedia,
        params: {AnalyticsConstants.keyUrl: url});
  }

  List<Widget> _buildYoutubeLinks() {
    return <Widget>[
      MorePageListCell(
        intend: true,
        iconAssetName: Style.of(context).svgAsset.youtube,
        cellText: FlutterI18n.translate(
          context,
          "more_screen.link_mnemonics",
        ),
        onTap: () => _openSocialMediaWebsite(
          Config.mnemonicsUrl,
        ),
        iconSize: _getSubMenuIconSize(),
      ),
      MorePageListCell(
        intend: true,
        iconAssetName: Style.of(context).svgAsset.youtube,
        cellText: FlutterI18n.translate(
          context,
          "more_screen.link_flashcards",
        ),
        onTap: () => _openSocialMediaWebsite(
          Config.flashcardsUrl,
        ),
        iconSize: _getSubMenuIconSize(),
      ),
      MorePageListCell(
        intend: true,
        iconAssetName: Style.of(context).svgAsset.youtube,
        cellText: FlutterI18n.translate(
          context,
          "more_screen.link_secrets",
        ),
        onTap: () => _openSocialMediaWebsite(
          Config.secretsUrl,
        ),
        iconSize: _getSubMenuIconSize(),
      )
    ];
  }

  double _getSubMenuIconSize() {
    return whenDevice(
      context,
      large: 19.0,
      tablet: 28.0,
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog<dynamic>(
      context: context,
      builder: (context) {
        return CustomDialog(
          title: FlutterI18n.translate(
            context,
            "more_screen.logout",
          ),
          content: FlutterI18n.translate(
            context,
            "more_screen.logout_dialog_text",
          ),
          actions: <DialogActionData>[
            DialogActionData(
              text: FlutterI18n.translate(
                context,
                "general.cancel",
              ),
              onTap: () => {
                Navigator.pop(context),
              },
            ),
            DialogActionData(
              key: const Key("logout"),
              text: FlutterI18n.translate(
                context,
                "more_screen.logout",
              ),
              onTap: () async => {
                _userRepository.logout(),
                _userManager.logout(),
                await QuestionOfTheDayNotification.cancelNotifications(),
                SuperStateful.of(context).userData = null,
                SuperStateful.of(context).clearData(),
                Navigator.of(context).pushNamedAndRemoveUntil(
                  Routes.welcome,
                  (_) => false,
                )
              },
            ),
          ],
        );
      },
    );
  }
}
