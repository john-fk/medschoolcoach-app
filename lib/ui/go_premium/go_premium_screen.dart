import 'package:Medschoolcoach/ui/go_premium/widgets/plan_box.dart';
import 'package:Medschoolcoach/utils/sizes.dart';
import 'package:Medschoolcoach/utils/style_provider/style.dart';
import 'package:Medschoolcoach/widgets/buttons/primary_button.dart';
import 'package:Medschoolcoach/widgets/buttons/text_button.dart';
import 'package:Medschoolcoach/widgets/cancel/cancel_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_svg/svg.dart';

enum Plan {
  Month1,
  Months6,
  Year,
}

class GoPremiumScreen extends StatefulWidget {
  @override
  _GoPremiumScreenState createState() => _GoPremiumScreenState();
}

class _GoPremiumScreenState extends State<GoPremiumScreen> {
  Plan _plan = Plan.Month1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            color: Style.of(context).colors.accent, //TODO: change for bcg asset
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      const SizedBox(width: CancelWidget.size),
                      Text(
                        FlutterI18n.translate(
                          context,
                          "go_premium_screen.title",
                        ),
                        style: Style.of(context).font.bold2.copyWith(
                              fontSize: whenDevice(
                                context,
                                small: 25,
                                medium: 28,
                                large: 30,
                                tablet: 50,
                              ),
                            ),
                      ),
                      CancelWidget(
                        onTap: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                  _buildTextLines(),
                  SvgPicture.asset(
                    Style.of(context)
                        .svgAsset
                        .refPeople, //TODO: change to aprop. asset
                    height: whenDevice(
                      context,
                      small: 130,
                      medium: 150,
                      large: 180,
                      tablet: 280,
                    ),
                  ),
                  _buildPlanBoxes(),
                  _buildButtons(),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  void _signUp() {}

  Widget _buildButtons() {
    return Column(
      children: <Widget>[
        PrimaryButton(
          text: FlutterI18n.translate(
            context,
            "go_premium_screen.confirm",
          ),
          onPressed: _signUp,
          color: Style.of(context).colors.premium,
        ),
        MSCTextButton(
          secondaryButton: true,
          text: FlutterI18n.translate(
            context,
            "go_premium_screen.not_now",
          ),
          onPressed: () => Navigator.of(context).pop(),
        )
      ],
    );
  }

  Widget _buildPlanBoxes() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        PlanBox(
          plan: FlutterI18n.translate(
            context,
            "go_premium_screen.plan1.name",
          ),
          prize: FlutterI18n.translate(
            context,
            "go_premium_screen.plan1.prize",
          ),
          active: _plan == Plan.Month1,
          onTap: () => _changePlan(Plan.Month1),
        ),
        PlanBox(
          plan: FlutterI18n.translate(
            context,
            "go_premium_screen.plan2.name",
          ),
          prize: FlutterI18n.translate(
            context,
            "go_premium_screen.plan2.prize",
          ),
          discount: FlutterI18n.translate(
            context,
            "go_premium_screen.plan2.discount",
          ),
          active: _plan == Plan.Months6,
          onTap: () => _changePlan(Plan.Months6),
        ),
        PlanBox(
          plan: FlutterI18n.translate(
            context,
            "go_premium_screen.plan3.name",
          ),
          prize: FlutterI18n.translate(
            context,
            "go_premium_screen.plan3.prize",
          ),
          discount: FlutterI18n.translate(
            context,
            "go_premium_screen.plan3.discount",
          ),
          active: _plan == Plan.Year,
          onTap: () => _changePlan(Plan.Year),
        )
      ],
    );
  }

  Widget _buildTextLines() {
    final textStyle = Style.of(context).font.normal2.copyWith(
          fontSize: whenDevice(
            context,
            small: 14,
            medium: 16,
            large: 18,
            tablet: 28,
          ),
        );

    return Column(
      children: <Widget>[
        Text(
          FlutterI18n.translate(
            context,
            "go_premium_screen.text1",
          ),
          style: textStyle,
        ),
        Text(
          FlutterI18n.translate(
            context,
            "go_premium_screen.text2",
          ),
          style: textStyle,
        ),
        Text(
          FlutterI18n.translate(
            context,
            "go_premium_screen.text3",
          ),
          style: textStyle,
        ),
        Text(
          FlutterI18n.translate(
            context,
            "go_premium_screen.text4",
          ),
          style: textStyle,
        ),
        Text(
          FlutterI18n.translate(
            context,
            "go_premium_screen.text5",
          ),
          style: textStyle,
        ),
        Text(
          FlutterI18n.translate(
            context,
            "go_premium_screen.text6",
          ),
          style: textStyle,
        ),
        Text(
          FlutterI18n.translate(
            context,
            "go_premium_screen.text7",
          ),
          style: textStyle,
        ),
      ],
    );
  }

  void _changePlan(Plan plan) {
    setState(() {
      _plan = plan;
    });
  }
}
