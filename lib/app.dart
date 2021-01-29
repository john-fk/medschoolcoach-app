import 'dart:async';

import 'package:Medschoolcoach/config.dart';
import 'package:Medschoolcoach/utils/navigation/routes.dart';
import 'package:Medschoolcoach/utils/style_provider/style.dart';
import 'package:Medschoolcoach/utils/super_state/super_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_i18n/flutter_i18n_delegate.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:uni_links/uni_links.dart';

const _appColors = const AppColors(
  accent: Color(0xFF145FD8),
  accent2: Color(0xFF0E9732),
  accent3: Color(0xFF145ED7),
  content: Color(0xFF102B44),
  content2: Colors.white,
  content3: Color(0xFF485E82),
  background: Colors.white,
  inputBackground: Color(0xFFECF4FA),
  shadow: Color.fromRGBO(0, 0, 0, 0.1),
  shadow2: Color.fromRGBO(0, 0, 0, 0.05),
  brightShadow: Color.fromRGBO(255, 255, 255, 0.2),
  error: Color(0xFFD32F2F),
  premium: Color(0xFFFFB849),
  separator: Color(0xFFEBEEEF),
  divider: Color(0x0D000000),
  questions: Color(0xFFFF7B5D),
  qualifyingText: Color.fromRGBO(252, 132, 81, 1),
);

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
  String _latestLink = 'Unknown';
  Uri _latestUri;
  StreamSubscription _sub;

  @override
  void initState() {
    super.initState();
    //initPlatformStateForStringUniLinks();
    print(_latestLink);
    print(_latestUri);
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

  /// An implementation using a [String] link
  void initPlatformStateForStringUniLinks() async {
    // Attach a listener to the links stream
    _sub = getLinksStream().listen((String link) {
      if (!mounted) return;
      setState(() {
        _latestLink = link ?? 'Unknown';
        _latestUri = null;
        try {
          if (link != null) _latestUri = Uri.parse(link);
        } on FormatException {}
      });
    }, onError: (Error err) {
      if (!mounted) return;
      setState(() {
        _latestLink = 'Failed to get latest link: $err.';
        _latestUri = null;
      });
    });

    // Attach a second listener to the stream
    getLinksStream().listen((String link) {
      print('got link: $link');
    }, onError: (dynamic err) {
      print('got err: $err');
    });

    // Get the latest link
    String initialLink;
    Uri initialUri;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      initialLink = await getInitialLink();
      print('initial link: $initialLink');
      if (initialLink != null) initialUri = Uri.parse(initialLink);
    } on PlatformException {
      initialLink = 'Failed to get initial link.';
      initialUri = null;
    } on FormatException {
      initialLink = 'Failed to parse the initial link as Uri.';
      initialUri = null;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _latestLink = initialLink;
      _latestUri = initialUri;
    });
  }
}
