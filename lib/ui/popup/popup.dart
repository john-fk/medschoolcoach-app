import 'dart:ui';
import 'package:Medschoolcoach/utils/responsive_fonts.dart';
import 'package:Medschoolcoach/providers/analytics_constants.dart';
import 'package:Medschoolcoach/providers/analytics_provider.dart';
import 'package:flutter/material.dart';
import 'package:Medschoolcoach/utils/navigation/routes.dart';
import 'package:Medschoolcoach/utils/sizes.dart';
import 'package:Medschoolcoach/utils/style_provider/style.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:Medschoolcoach/widgets/buttons/primary_button.dart';

class Popup {
  Future<void> showDialog(BuildContext context,int popupNumber,
                          AnalyticsProvider _analyticsProvider){
    Color background = popupNumber==1 ? Color(0xFF145ED7) : Color(0xFF67A2FF);
    Color cross = popupNumber==1 ? Color(0x7fffffff) : Color(0xFF145ED7);
    bool clicked=false;

    void dismissScreenAnalytics(){
      _analyticsProvider.logEvent(AnalyticsConstants.tapPopupDismiss,
          params: {"popup_number": popupNumber.toString()});
    }

    _analyticsProvider.logEvent(AnalyticsConstants.tutorPopupScreen,
        params: {"popup_number": popupNumber.toString() });

    return showGeneralDialog<void>(
      barrierLabel: "",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 200),
      context: context,
      pageBuilder: (_, __, ___) {
        double screenHeight = MediaQuery.of(context).size.height;
        double screenWidth = MediaQuery.of(context).size.width;
        double height = screenHeight * (isPortrait(context)? 0.5 : 0.8 );
        double width = height * 0.9;
        width = width > screenWidth*0.9 ? screenWidth*0.9 : width;

        double leftMarginText = popupNumber==1?
                                (width-width*0.05-height*0.5*1.5)/2:0;

        return
            Container(
                decoration: BoxDecoration(
                color: background,
                borderRadius: BorderRadius.all(Radius.circular(20))
            ),
          margin: EdgeInsets.symmetric(
                      horizontal:(screenWidth-width)/2,
                      vertical:(screenHeight-height)/2
          ),
          height:height,
          width:width,
          padding: EdgeInsets.fromLTRB(
              width*0.05,0,0, height*0.08),
              child:Material(type: MaterialType.transparency,
              child:Column(
                children:[
                  Align(
                  alignment: Alignment.centerRight,
                  child:
                  InkWell(
                      onTap: ()=>Navigator.pop(context),
                      child:Container(
                          alignment: Alignment.centerRight,
                          child: Image.asset(
                              Style.of(context).pngAsset.iconClose,
                              height:(isPortrait(context)?height:width)*0.03,
                              color:cross
                          ),
                          padding: EdgeInsets.fromLTRB(width*0.1, height*0.03,
                              height*0.03,width*0.05)
                      ),
                )),
                Container(
                  margin:EdgeInsets.only(right:width*0.05,left:leftMarginText),
                  alignment: popupNumber == 1 ? Alignment.topLeft : Alignment.topCenter,
                  child:
                  AutoSizeText(
                      FlutterI18n.translate(
                      context, "tutor_popup.popup_${popupNumber}_title"),
                      maxLines:1,
                      style: greatResponsiveFont(context,
                          fontWeight: FontWeight.w700)
                          .copyWith(color: Colors.white),
                      )
                ),
                Container(
                    margin:EdgeInsets.only(right:width*0.05,left:leftMarginText),
                    alignment: popupNumber == 1 ? Alignment.topLeft : Alignment.topCenter,
                    child:
                      AutoSizeText(
                        FlutterI18n.translate(
                          context, "tutor_popup.popup_${popupNumber}_subtitle"),
                        maxLines:1,
                        style: biggerResponsiveFont(context,
                            fontWeight: FontWeight.w700)
                            .copyWith(color: Colors.white),
                      )
                ),
                Spacer(),
                Container(
                  margin:EdgeInsets.only(right:width*0.05,),
                  alignment: Alignment.center,
                  height:height*0.5,
                  child:
                  Image.asset(
                    Style.of(context).pngAsset.tutorPopup +
                        popupNumber.toString() + ".png",
                    fit: BoxFit.fitHeight,
                  ),
                ),
                Spacer(),
                Container(
                    alignment: Alignment.center,
                    margin:EdgeInsets.only(right:width*0.05),
                    height: height*0.1,
                    width: width * 0.55,
                    child:
                    PrimaryButton(
                      autoShrink: true,
                      color: Colors.white,
                      fontSize: bigResponsiveFont(context).fontSize,
                      fontColor : Color(0xFF145ED7),
                      text: FlutterI18n.translate(
                          context, "tutor_popup.popup_${popupNumber}_button"),
                      onPressed: () {
                        clicked=true;
                        Navigator.of(context).pop();
                        _analyticsProvider.logEvent(AnalyticsConstants.tapPopup,
                            params: {"popup_number": popupNumber.toString()});
                        Routes.navigateToTutoringScreen(
                            context, AnalyticsConstants.tapPopup,
                            isNavBar: false);
                      },
                    ),
                ),
         ]
        )
        ));
      },
      transitionBuilder: (context, a1, a2, child) {
        return Transform.scale(
            scale: a1.value,
            child: Opacity(
              opacity: a1.value,
              child: child
            ),
          );
        },
    ).then((value){
      if (!clicked) dismissScreenAnalytics();
    });
  }
}
