import 'package:Medschoolcoach/utils/style_provider/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

void openPremiumModal(BuildContext context) {
  showModalBottomSheet<void>(
    isScrollControlled: true,
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(25.0),
      ),
    ),
    builder: (context) {
      final width = MediaQuery.of(context).size.width;
      final bottomPadding = MediaQuery.of(context).padding.bottom;
      return Stack(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(25.0),
            ),
            child: Container(
              color: Color.fromRGBO(
                27,
                100,
                217,
                1,
              ),
              padding: EdgeInsets.only(
                bottom: bottomPadding,
              ),
              child: Image.asset(
                Style.of(context).pngAsset.premiumModal,
                width: width,
                fit: BoxFit.cover,
              ),
            ),
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
                  context,
                  "premium_modal.description",
                ),
                style: Style.of(context).font.medium2.copyWith(
                      fontSize: width * 0.04,
                    ),
              ),
            ),
          ),
          Positioned(
            top: width * 0.015,
            right: width * 0.05,
            child: Image.asset(
              Style.of(context).pngAsset.premiumModalStar,
              width: width * 0.2,
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
          )
        ],
      );
    },
  );
}
