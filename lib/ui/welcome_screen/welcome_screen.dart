import 'package:Medschoolcoach/config.dart';
import 'package:Medschoolcoach/utils/navigation/routes.dart';
import 'package:Medschoolcoach/utils/style_provider/style.dart';
import 'package:Medschoolcoach/widgets/buttons/secondary_button.dart';
import 'package:Medschoolcoach/widgets/buttons/text_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_svg/svg.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Config.showSwitch
        ? Scaffold(
            drawer: Drawer(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("Production API : "),
                  Checkbox(
                    value: Config.switchValue,
                    onChanged: (value) {
                      Config.switchValue = !Config.switchValue;
                      setState(() {});
                    },
                  ),
                ],
              ),
            ),
            body: Stack(
              overflow: Overflow.visible,
              children: <Widget>[
                Container(
                  width: screenWidth,
                  height: screenHeight,
                  child: SvgPicture.asset(
                    Style.of(context).svgAsset.welcomeScreenBackground,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: -3.65 * screenWidth,
                  left: -1.5 * screenWidth,
                  child: Container(
                    width: 4 * screenWidth,
                    height: 4 * screenWidth,
                    decoration: BoxDecoration(
                      color: Style.of(context).colors.background,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Container(
                  width: screenWidth,
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.18),
                  margin: EdgeInsets.only(top: screenWidth * 0.1),
                  child: Image.asset(
                    Style.of(context).pngAsset.logo,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: screenWidth * 0.34),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.07),
                        child: Text(
                          FlutterI18n.translate(
                              context, "welcome_screen.header"),
                          textAlign: TextAlign.center,
                          style: Style.of(context)
                              .font
                              .normal2
                              .copyWith(fontSize: screenWidth * 0.07),
                        ),
                      ),
                      SvgPicture.asset(
                        Style.of(context).svgAsset.manOnBooks,
                        height: screenHeight * 0.3,
                      ),
                      Column(
                        children: <Widget>[
                          SecondaryButton(
                            key: const Key("go_register_button"),
                            margin: EdgeInsets.symmetric(
                                horizontal: screenWidth * 0.07),
                            text: FlutterI18n.translate(
                                context, "welcome_screen.register"),
                            onPressed: () =>
                                Navigator.pushNamed(context, Routes.register),
                          ),
                          const SizedBox(height: 5),
                          MSCTextButton(
                            key: const Key("go_login_button"),
                            text: FlutterI18n.translate(
                                context, "welcome_screen.login"),
                            onPressed: () =>
                                Navigator.pushNamed(context, Routes.login),
                            secondaryButton: true,
                          )
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          )
        : Scaffold(
            body: Stack(
              overflow: Overflow.visible,
              children: <Widget>[
                Container(
                  width: screenWidth,
                  height: screenHeight,
                  child: SvgPicture.asset(
                    Style.of(context).svgAsset.welcomeScreenBackground,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: -3.65 * screenWidth,
                  left: -1.5 * screenWidth,
                  child: Container(
                    width: 4 * screenWidth,
                    height: 4 * screenWidth,
                    decoration: BoxDecoration(
                      color: Style.of(context).colors.background,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Container(
                  width: screenWidth,
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.18),
                  margin: EdgeInsets.only(top: screenWidth * 0.1),
                  child: Image.asset(
                    Style.of(context).pngAsset.logo,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: screenWidth * 0.34),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.07),
                        child: Text(
                          FlutterI18n.translate(
                              context, "welcome_screen.header"),
                          textAlign: TextAlign.center,
                          style: Style.of(context)
                              .font
                              .normal2
                              .copyWith(fontSize: screenWidth * 0.07),
                        ),
                      ),
                      SvgPicture.asset(
                        Style.of(context).svgAsset.manOnBooks,
                        height: screenHeight * 0.3,
                      ),
                      Column(
                        children: <Widget>[
                          SecondaryButton(
                            key: const Key("go_register_button"),
                            margin: EdgeInsets.symmetric(
                                horizontal: screenWidth * 0.07),
                            text: FlutterI18n.translate(
                                context, "welcome_screen.register"),
                            onPressed: () =>
                                Navigator.pushNamed(context, Routes.register),
                          ),
                          const SizedBox(height: 5),
                          MSCTextButton(
                            key: const Key("go_login_button"),
                            text: FlutterI18n.translate(
                                context, "welcome_screen.login"),
                            onPressed: () =>
                                Navigator.pushNamed(context, Routes.login),
                            secondaryButton: true,
                          )
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
  }
}
