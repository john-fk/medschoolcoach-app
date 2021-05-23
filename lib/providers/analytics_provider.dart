import 'package:Medschoolcoach/providers/analytics_constants.dart';
import 'package:Medschoolcoach/config.dart';
import 'package:universal_io/io.dart'  show Platform;

class AnalyticsProvider {
  String _distinctId;
  String token;
  String key;

  AnalyticsProvider() {
    this.initialize();
    key = this.keyDevice();
  }


  Future initialize([String token=Config.prodMixPanelToken]) async {
    return null;
  }

  void identify(String distinctId) {
    return null;
  }

  void identifyPeople(String distinctId) {
    return null;
  }

  String keyDevice(){
    return null;
  }

  void setToken({bool remove=false}){
    return null;
  }


  Future<void> setPeopleProperties(Map<String, dynamic> props,{bool remove=false}) async{
    return null;
  }

  void logEvent(String eventName, {dynamic params}) {
    return null;
  }

  void logScreenView(String screenName, String sourceName, {dynamic params}) {
    return null;
  }

  Map<String, String> getVideoParam(String id, String name,
      {dynamic additionalParams}) {
    var args = {
      AnalyticsConstants.keyVideoId: id,
      AnalyticsConstants.keyVideoName: name
    };
    if (additionalParams != null) {
      args.addAll(additionalParams);
    }
    return args;
  }
  Future<void> reset() async{
    return null;
  }
  // ignore: avoid_positional_boolean_parameters
  void logVideoBookMarkEvent(bool isRemove, String videoId, String videoName) {
    logEvent(
        isRemove
            ? AnalyticsConstants.tapVideoBookmarkRemove
            : AnalyticsConstants.tapVideoBookmarkAdd,
        params: getVideoParam(videoId, videoName));
  }

  void logAccountManagementEvent(
      // ignore: avoid_positional_boolean_parameters
      String event,
      String email,
      bool isSuccess,
      String errorMessage) {
    logEvent(event, params: {
      AnalyticsConstants.keyEmail: email,
      AnalyticsConstants.keyIsSuccess: isSuccess,
      AnalyticsConstants.keyError: errorMessage
    });
  }
}
