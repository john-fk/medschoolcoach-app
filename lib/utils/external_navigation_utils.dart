import 'package:url_launcher/url_launcher.dart';

class ExternalNavigationUtils {
  static void sendEmail(String recipient) async {
    var urlString = "mailto:$recipient";
    if (await canLaunch(urlString)) {
      launch(urlString);
    }
  }

  static void openWebsite(String url) async {
    if (await canLaunch(url)) {
      launch(url);
    }
  }
}
