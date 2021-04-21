import 'package:Medschoolcoach/providers/analytics_provider.dart';
import 'package:Medschoolcoach/utils/navigation/routes.dart';
import 'package:Medschoolcoach/utils/responsive_fonts.dart';
import 'package:Medschoolcoach/utils/style_provider/style.dart';
import 'package:Medschoolcoach/widgets/buttons/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:injector/injector.dart';

class OldUserOnboarding extends StatefulWidget {
  @override
  _OldUserOnboardingState createState() => _OldUserOnboardingState();
}

class _OldUserOnboardingState extends State<OldUserOnboarding> {
  Size size;
  final AnalyticsProvider _analyticsProvider =
  Injector.appInstance.getDependency<AnalyticsProvider>();

  @override
  void initState() {
    super.initState();
    _analyticsProvider.logScreenView(Routes.oldUserOnboarding, null);
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(child: _buildBody()),
    );
  }

  Widget _buildBody() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Spacer(),
            _buildHeading(),
            Spacer(),
            Image(image: AssetImage("assets/png/old_user_onboarding.png"),
              height: size.height * 0.3,
              fit: BoxFit.cover,
            ),
            Spacer(),
            _buildNextButton(),
            Spacer()
          ],
        ),
      ),
    );
  }

  Widget _buildNextButton(){
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.8,
      child: PrimaryButton(
        text: FlutterI18n.translate(context, "general.next").toUpperCase(),
        onPressed: () {
          Navigator.pushNamed(context, Routes.scheduleTestDate);
        },
        color: Style.of(context).colors.accent4,
      ),
    );
  }

  Widget _buildHeading() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        text: FlutterI18n.translate(
            context, "old_user_onboarding.share_your_schedule"),
        style: biggerResponsiveFont(context,
            fontColor: FontColor.Content, fontWeight: FontWeight.w700),
        children: <TextSpan>[
          TextSpan(
              text:
                  FlutterI18n.translate(context, "old_user_onboarding.tailor"),
              style: biggerResponsiveFont(context,
                  fontColor: FontColor.Accent4, fontWeight: FontWeight.w700)),
          TextSpan(
              text: FlutterI18n.translate(context, "old_user_onboarding.your")),
          TextSpan(
              text: FlutterI18n.translate(
                  context, "old_user_onboarding.learning"),
              style: biggerResponsiveFont(context,
                  fontColor: FontColor.Accent4, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}
