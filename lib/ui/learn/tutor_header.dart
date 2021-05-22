import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:Medschoolcoach/providers/analytics_provider.dart';
import 'package:Medschoolcoach/utils/responsive_fonts.dart';
import 'package:Medschoolcoach/utils/sizes.dart';
import 'package:Medschoolcoach/utils/style_provider/style.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:injector/injector.dart';

class TutorHeader extends StatelessWidget {
  final VoidCallback getTutor;
  final VoidCallback changeSchedule;
  final AnalyticsProvider _analyticsProvider =
      Injector.appInstance.getDependency<AnalyticsProvider>();
  Size size;
  bool isClicking = false;

  TutorHeader({
      @required this.getTutor,
      @required this.changeSchedule
  });

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    final height = size.height / 8;
    return
        Container(
            height: whenDevice(context,
                small: height * 1.25, medium: height, large: height),
            child: Card(
              semanticContainer: true,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              elevation: 5,
              shadowColor: Colors.black.withOpacity(0.1),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  side: BorderSide(width: 1, color: Color(0xFFEFF1F6))),
              child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 15, vertical: 10
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 5,
                        child:
                          InkWell(
                            onTap: (){
                                if (disableClick()) return;
                                getTutor();
                            },
                          child:
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children:[
                                  Expanded(
                                  flex:7,
                                  child:Image(
                                    image: AssetImage(
                                        Style.of(context).pngAsset.learnTutor),
                                    fit:BoxFit.fitHeight
                                  )),
                                  Spacer(),
                                  Expanded(
                                      flex:2,
                                      child:
                                      AutoSizeText(FlutterI18n.translate(context,"learn_screen.tutor_title"),
                                        maxLines:1,
                                        textAlign: TextAlign.center,
                                        style: mediumResponsiveFont(context,
                                            fontWeight: FontWeight.w400)
                                            .copyWith(color: Color(0xFF0E2D45)
                                        ),
                                      )
                                  )
                                ]
                              )
                        ),
                      ),
                      Container(color:Color.fromRGBO(0,0,0,0.05),
                          width:1),
                      Expanded(
                        flex: 5,
                        child:
                        InkWell(
                            onTap: (){
                              if (disableClick()) return;
                              changeSchedule();
                            },
                            child:
                            Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children:[
                                  Expanded(flex:7,
                                  child:Image(
                                      image: AssetImage(
                                      Style.of(context).pngAsset.learnSchedule),
                                        fit:BoxFit.fitHeight
                                  )),
                                  Spacer(),
                                  Expanded(flex:2,
                                  child:
                                    AutoSizeText(FlutterI18n.translate(context,"learn_screen.schedule_title",),
                                                  maxLines: 1,
                                                  textAlign: TextAlign.center,
                                                  style: mediumResponsiveFont(context,
                                                      fontWeight: FontWeight.w400)
                                                      .copyWith(color: Color(0xFF0E2D45)
                                                  ),
                                    )
                                  )
                                ]
                            )
                        ),
                      ),
                    ],
                  )),
            )
        );
  }

  bool disableClick(){
    if (isClicking) return true;
    isClicking = true;
    Future.delayed(Duration(seconds:1), () {
      isClicking=false;
    });
    return false;
  }
}

