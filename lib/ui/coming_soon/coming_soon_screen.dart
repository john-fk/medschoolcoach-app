import 'package:Medschoolcoach/utils/style_provider/style.dart';
import 'package:Medschoolcoach/widgets/app_bars/custom_app_bar.dart';
import 'package:Medschoolcoach/widgets/navigation_bar/navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

class ComingSoonScreen extends StatelessWidget {
  final String screenName;

  const ComingSoonScreen({
    this.screenName,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      bottomNavigationBar: NavigationBar(),
      body: Container(
        color: Style.of(context).colors.accent,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            screenName != null && screenName.isNotEmpty
                ? CustomAppBar(
                    title: screenName,
                  )
                : SizedBox(
                    height: 100,
                  ),
            Stack(
              children: <Widget>[
                Image.asset(
                  Style.of(context).pngAsset.premiumModal,
                  fit: BoxFit.fill,
                ),
                Positioned(
                  left: width * 0.05,
                  top: width * 0.77,
                  child: Container(
                    padding: EdgeInsets.all(width * 0.03),
                    width: width * 0.5,
                    height: width * 0.25,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Style.of(context).colors.premium,
                    ),
                    child: Text(
                      FlutterI18n.translate(
                          context, "premium_modal.description"),
                      style: Style.of(context).font.medium2.copyWith(
                            fontSize: width * 0.04,
                          ),
                    ),
                  ),
                ),
                Positioned(
                  top: width * 0.015,
                  right: width * 0.05,
                  child: Stack(
                    children: <Widget>[
                      Image.asset(
                        Style.of(context).pngAsset.premiumModalStar,
                        width: width * 0.2,
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: width * 0.075,
                  right: width * 0.06,
                  child: Container(
                    width: width * 0.18,
                    child: Text(
                      FlutterI18n.translate(
                        context,
                        "premium_modal.coming_soon",
                      ),
                      textAlign: TextAlign.center,
                      style: Style.of(context).font.premium.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: width * 0.04,
                          ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
