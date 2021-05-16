import 'dart:async';

import 'package:Medschoolcoach/config.dart';
import 'package:Medschoolcoach/utils/navigation/routes.dart';
import 'package:Medschoolcoach/utils/notification_helper.dart';
import 'package:Medschoolcoach/utils/style_provider/style.dart';
import 'package:Medschoolcoach/utils/super_state/super_state.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n_delegate.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'main.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

const _appColors = const AppColors(
    accent: Color(0xFF145FD8),
    accent2: Color(0xFF0E9732),
    accent3: Color(0xFF145ED7),
    accent4: Color(0xff009D7A),
    content: Color(0xFF102B44),
    content2: Colors.white,
    content3: Color(0xFF485E82),
    content4: Color(0xFF7E8A9D),
    background: Colors.white,
    background2: Color(0xffF7F8FC),
    background3: Color(0xffEFF2F6),
    inputBackground: Color(0xFFECF4FA),
    shadow: Color.fromRGBO(0, 0, 0, 0.1),
    shadow2: Color.fromRGBO(0, 0, 0, 0.05),
    brightShadow: Color.fromRGBO(255, 255, 255, 0.2),
    error: Color(0xFFD32F2F),
    premium: Color(0xFFFFB849),
    separator: Color(0xFFEBEEEF),
    divider: Color(0x0D000000),
    questions: Color(0xFFFF7B5D),
    qbIncorrect: Color(0xFFFF8131),
    qbCorrect: Color(0xFF009D7A),
    bottomSlider: Color(0xFF0C53C7),
    qualifyingText: Color.fromRGBO(252, 132, 81, 1),
    border: Colors.lightBlueAccent);

final Map<int, Color> _primarySwatch = {
  50: _appColors.accent,
  100: _appColors.accent,
  200: _appColors.accent,
  300: _appColors.accent,
  400: _appColors.accent,
  500: _appColors.accent,
  600: _appColors.accent,
  700: _appColors.accent,
  800: _appColors.accent,
  900: _appColors.accent,
};

final _materialColor = MaterialColor(_appColors.accent.value, _primarySwatch);

class MyApp extends StatefulWidget {
  final String initialRoute;

  const MyApp({
    this.initialRoute,
  });

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  StreamSubscription _sub;

  @override
  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();
    await initNotifications(notifsPlugin, navigatorKey);
  }

  @override
  void initState() {
    super.initState();
    markLaunchedFromNotificationIfApplicable(notifsPlugin, context);
  }

  @override
  void dispose() {
    if (_sub != null) _sub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SuperStateful(
      child: Style(
        child: MaterialApp(
          builder: DevicePreview.appBuilder,
          navigatorKey: navigatorKey,
          title: Config.appTitle,
          localizationsDelegates: <LocalizationsDelegate<dynamic>>[
            FlutterI18nDelegate(
                fallbackFile: 'en_US',
                useCountryCode: true,
                path: 'assets/i18n'),
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate
          ],
          theme: ThemeData(
            fontFamily: Config.fontFamily,
            primarySwatch: _materialColor,
            accentColor: _appColors.accent,
            appBarTheme: AppBarTheme(color: _appColors.accent),
            backgroundColor: _appColors.background,
            dialogBackgroundColor: _appColors.background,
            scaffoldBackgroundColor: _appColors.background,
          ),
          onGenerateRoute: Routes.generateRoute,
          initialRoute: widget.initialRoute,
        ),
        colors: _appColors,
      ),
    );
  }
}
