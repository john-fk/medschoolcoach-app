import 'package:Medschoolcoach/utils/navigation/routes.dart';
import 'package:Medschoolcoach/utils/responsive_fonts.dart';
import 'package:Medschoolcoach/utils/sizes.dart';
import 'package:Medschoolcoach/utils/style_provider/style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfileAppBar extends StatelessWidget {
  final String userName;
  final String avatarUrl;

  const ProfileAppBar({
    this.userName,
    this.avatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 12.0,
      ),
      child: Row(
        children: <Widget>[
          CircleAvatar(
            backgroundImage:
                avatarUrl.isNotEmpty ? NetworkImage(avatarUrl) : null,
            backgroundColor: Style.of(context).colors.separator,
            radius: whenDevice(
              context,
              large: 25,
              tablet: 35,
            ),
          ),
          const SizedBox(
            width: 8,
          ),
          Expanded(
            child: Text(
              userName,
              style: greatResponsiveFont(context, fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.fade,
              softWrap: false,
            ),
          ),
          const SizedBox(
            width: 8,
          ),
          InkWell(
            onTap: () {
              Navigator.pushNamed(
                context,
                Routes.userSettings,
              );
            },
            child: Icon(
              Icons.settings,
              size: whenDevice(
                context,
                large: 25,
                tablet: 35,
              ),
            ),
          )
        ],
      ),
    );
  }
}

/*Row( POST MVP
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.star,
                    color: Style.of(context).colors.premium,
                    size: 12,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    FlutterI18n.translate(
                        context, "home_screen.premium_account"),
                    style: Style.of(context).font.premium,
                  ),
                ],
              )*/
