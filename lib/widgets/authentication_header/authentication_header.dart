import 'package:Medschoolcoach/utils/sizes.dart';
import 'package:Medschoolcoach/utils/style_provider/style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_svg/svg.dart';

class AuthenticationHeader extends StatelessWidget {
  final String headerText;
  final double headerTextMargin;

  const AuthenticationHeader(
      {@required this.headerText, this.headerTextMargin});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.only(
        left: whenDevice(context, large: 6, tablet: 12),
      ),
      child: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.centerRight,
            child: SvgPicture.asset(
              Style.of(context).svgAsset.loginHeader,
              width: width * 0.8,
              fit: BoxFit.fitWidth,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(
                height: 40,
              ),
              InkWell(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SvgPicture.asset(
                    Style.of(context).svgAsset.backArrowDark,
                    width: width * 0.07,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              SizedBox(
                height: headerTextMargin ?? width * 0.35,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  FlutterI18n.translate(context, headerText),
                  style: Style.of(context).font.bold.copyWith(
                        fontSize: whenDevice(
                          context,
                          large: 25,
                          tablet: 50,
                        ),
                      ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
