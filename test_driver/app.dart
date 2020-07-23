import 'package:Medschoolcoach/app.dart';
import 'package:Medschoolcoach/config.dart';
import 'package:Medschoolcoach/dependency_injection.dart';
import 'package:Medschoolcoach/utils/navigation/routes.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_driver/driver_extension.dart';
import 'package:native_mixpanel/native_mixpanel.dart';

void main() {
  enableFlutterDriverExtension();

  WidgetsFlutterBinding.ensureInitialized();
  initializeDependencyInjection(
    apiUrl: Config.devApiUrl,
    auth0Url: Config.devBaseAuth0Url,
    mixPanel: Mixpanel(),
  );

  /// App supported orientations init
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then(
    (_) {
      return runApp(MyApp(initialRoute: Routes.welcome));
    },
  );
}
