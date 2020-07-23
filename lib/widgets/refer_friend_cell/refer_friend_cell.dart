import 'package:Medschoolcoach/utils/navigation/routes.dart';
import 'package:Medschoolcoach/utils/style_provider/style.dart';
import 'package:Medschoolcoach/widgets/buttons/secondary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_svg/svg.dart';

class ReferFriendCell extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width - 24;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Stack(
        children: <Widget>[
          SvgPicture.asset(
            Style.of(context).svgAsset.refBackground,
            width: width,
            fit: BoxFit.fitWidth,
          ),
          Positioned(
            right: width * 0.03,
            top: width * 0.09,
            child: SvgPicture.asset(
              Style.of(context).svgAsset.refPeople,
              width: width * 0.45,
            ),
          ),
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            right: width * 0.4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  FlutterI18n.translate(context, "refer_friend_cell.line1"),
                  style: Style.of(context).font.medium2.copyWith(
                        fontSize: width * 0.05,
                      ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  FlutterI18n.translate(context, "refer_friend_cell.line2"),
                  style: Style.of(context).font.medium2.copyWith(
                        fontSize: width * 0.04,
                      ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  FlutterI18n.translate(context, "refer_friend_cell.line3"),
                  style: Style.of(context).font.medium2.copyWith(
                        fontSize: width * 0.04,
                      ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  FlutterI18n.translate(context, "refer_friend_cell.line4"),
                  style: Style.of(context).font.medium2.copyWith(
                        fontSize: width * 0.07,
                      ),
                  textAlign: TextAlign.center,
                ),
                SecondaryButton(
                  margin: EdgeInsets.only(
                    left: width * 0.05,
                    right: width * 0.05,
                    top: width * 0.05,
                  ),
                  onPressed: () => Navigator.pushNamed(
                    context,
                    Routes.referFriend,
                  ),
                  text: FlutterI18n.translate(
                    context,
                    "refer_friend_cell.button",
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
