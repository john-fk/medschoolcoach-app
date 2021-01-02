import 'dart:io';

import 'package:Medschoolcoach/config.dart';
import 'package:Medschoolcoach/providers/analytics_constants.dart';
import 'package:Medschoolcoach/providers/analytics_provider.dart';
import 'package:Medschoolcoach/repository/user_repository.dart';
import 'package:Medschoolcoach/utils/external_navigation_utils.dart';
import 'package:Medschoolcoach/utils/navigation/routes.dart';
import 'package:Medschoolcoach/utils/responsive_fonts.dart';
import 'package:Medschoolcoach/utils/sizes.dart';
import 'package:Medschoolcoach/utils/style_provider/style.dart';
import 'package:Medschoolcoach/utils/super_state/super_state.dart';
import 'package:Medschoolcoach/widgets/custom_expansion_tile/custom_expansion_tile.dart';
import 'package:Medschoolcoach/widgets/dialog/custom_dialog.dart';
import 'package:Medschoolcoach/widgets/list_cells/more_page_list_cell.dart';
import 'package:Medschoolcoach/widgets/modals/tutoring_modal/tutoring_modal.dart';
import 'package:Medschoolcoach/widgets/navigation_bar/navigation_bar.dart';
import 'package:Medschoolcoach/widgets/refer_friend_cell/refer_friend_cell.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_svg/svg.dart';
import 'package:injector/injector.dart';

class MoreScreen extends StatefulWidget {

  @override
  _MoreScreenState createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {
  final UserRepository _userRepository =
      Injector.appInstance.getDependency<UserRepository>();

  final AnalyticsProvider _analyticsProvider =
      Injector.appInstance.getDependency<AnalyticsProvider>();

  Future<bool> onWillPop() async {
    if (Platform.isAndroid) SystemNavigator.pop();
    return false;
  }

  @override
  void initState() {
    _analyticsProvider.logScreenView(AnalyticsConstants.screenMore,
        AnalyticsConstants.screenHome);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        bottomNavigationBar: NavigationBar(page: NavigationPage.More),
        body: SafeArea(
          child: SingleChildScrollView(
            key: const Key("more_scroll"),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: Column(
                children: <Widget>[
                  MorePageListCell(
                    iconAssetName: Style.of(context).svgAsset.videos,
                    cellText: FlutterI18n.translate(
                      context,
                      "more_screen.videos",
                    ),
                    onTap: () {
                      Navigator.of(context).pushNamed(
                        Routes.videos,
                        arguments: AnalyticsConstants.screenMore
                      );
                    },
                  ),
                  MorePageListCell(
                    iconAssetName: Style.of(context).svgAsset.flashcards,
                    cellText: FlutterI18n.translate(
                      context,
                      "common.flash_cards",
                    ),
                    onTap: () {
                      Navigator.of(context).pushNamed(
                        Routes.flashCardsMenu,
                        arguments: AnalyticsConstants.screenMore
                      );
                    },
                  ),
                  MorePageListCell(
                    iconAssetName: Style.of(context).svgAsset.tutoring,
                    cellText: FlutterI18n.translate(
                      context,
                      "common.tutoring",
                    ),
                    onTap: () => openTutoringModal(context, AnalyticsConstants.screenMore),
                  ),
                  MorePageListCell(
                    iconAssetName: Style.of(context).svgAsset.questions,
                    cellText: FlutterI18n.translate(
                      context,
                      "more_screen.questions",
                    ),
                    onTap: () {
                      Navigator.of(context).pushNamed(
                        Routes.questionBank,
                        arguments: AnalyticsConstants.screenMore
                      );
                    },
                  ),
                  InkWell(
                    key: Key(
                      FlutterI18n.translate(
                        context,
                        "bookmarks.title",
                      ),
                    ),
                    onTap: () {
                      Navigator.of(context).pushNamed(
                        Routes.bookmarks,
                      );
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 24.0,
                        vertical: whenDevice(context, large: 24, tablet: 38),
                      ),
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.bookmark_border,
                            size: whenDevice(context, large: 20, tablet: 32),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Text(
                            FlutterI18n.translate(
                              context,
                              "bookmarks.title",
                            ),
                            style: normalResponsiveFont(context),
                          )
                        ],
                      ),
                    ),
                  ),
                  MorePageListCell(
                    iconAssetName: Style.of(context).svgAsset.support,
                    cellText: FlutterI18n.translate(
                      context,
                      "more_screen.support",
                    ),
                    onTap: () => Navigator.of(context).pushNamed(
                      Routes.contactSupport,
                    ),
                  ),
                  InkWell(
                    key: Key(
                      FlutterI18n.translate(
                        context,
                        "more_screen.my_account",
                      ),
                    ),
                    onTap: () {
                      Navigator.of(context).pushNamed(Routes.profile,
                          arguments: AnalyticsConstants.screenMore);
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 24.0,
                        vertical: whenDevice(context, large: 24, tablet: 38),
                      ),
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.person_outline,
                            size: whenDevice(context, large: 20, tablet: 32),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Text(
                            FlutterI18n.translate(
                              context,
                              "more_screen.my_account",
                            ),
                            style: normalResponsiveFont(context),
                          )
                        ],
                      ),
                    ),
                  ),
                  MorePageListCell(
                    iconAssetName: Style.of(context).svgAsset.logout,
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
                              width: 12,
                            ),
                            SvgPicture.asset(
                              Style.of(context).svgAsset.youtube,
                              width: whenDevice(context, large: 17, tablet: 28),
                            ),
                            const SizedBox(
                              width: 20,
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
                    onTap: () =>
                        _openSocialMediaWebsite(Config.facebook),
                    svgAsset: false,
                  ),
                  MorePageListCell(
                    iconAssetName: Style.of(context).pngAsset.instagram,
                    cellText: FlutterI18n.translate(
                      context,
                      "more_screen.instagram",
                    ),
                    onTap: () =>
                    _openSocialMediaWebsite(Config.instagram),
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
      ),
    ];
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
              onTap: () => {
                _userRepository.logout(),
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
