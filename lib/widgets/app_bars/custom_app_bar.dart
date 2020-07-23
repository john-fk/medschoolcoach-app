import 'package:Medschoolcoach/utils/responsive_fonts.dart';
import 'package:Medschoolcoach/utils/sizes.dart';
import 'package:Medschoolcoach/utils/style_provider/style.dart';
import 'package:Medschoolcoach/widgets/buttons/pop_back_button.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  final String title;
  final String subTitle;
  final EdgeInsets padding;

  final VoidCallback customPop;

  const CustomAppBar({
    @required this.title,
    Key key,
    this.subTitle,
    this.padding,
    this.customPop,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Style.of(context).colors.accent,
      child: Container(
        padding:
            EdgeInsets.fromLTRB(10, MediaQuery.of(context).padding.top, 10, 10),
        child: Padding(
          padding: padding != null
              ? padding
              : EdgeInsets.symmetric(
                  vertical: whenDevice(context, large: 30, tablet: 50),
                ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(
                  top: whenDevice(
                    context,
                    large: 3,
                    tablet: 6,
                  ),
                ),
                child: PopBackButton(
                  customPop: customPop,
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      title ?? "",
                      style: greatResponsiveFont(
                        context,
                        fontColor: FontColor.Content2,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (subTitle != null)
                      Container(
                        margin: const EdgeInsets.only(top: 10),
                        child: Text(
                          subTitle,
                          style: normalResponsiveFont(
                            context,
                            fontColor: FontColor.Content2,
                          ),
                        ),
                      )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
