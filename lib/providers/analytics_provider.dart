import 'package:Medschoolcoach/providers/analytics_constants.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';
import 'package:Medschoolcoach/config.dart';
import 'dart:convert';
import 'dart:io' show Platform;

class AnalyticsProvider {
  Mixpanel _mixpanel;
  String _distinctId;
  String fcmcode;

  AnalyticsProvider() {
    this.initialize(Config.prodMixPanelToken);
  }


  Future initialize(String token) async {
    if (_mixpanel == null) {
      _mixpanel = await Mixpanel.init(token, optOutTrackingDefault: false);
    }
    return _mixpanel;
  }

  void identify(String distinctId) {
    _distinctId = distinctId;
    return _mixpanel.alias("auth",distinctId);
  }

  void identifyPeople(String distinctId) {
    return logEvent("identifyPeople", params: {"distinctId": distinctId});
  }

  void setFCM(){
    String key;

    if (Platform.isAndroid || Platform.isIOS) {
      key ="\$android_devices";
    }
    if (key!=null)
      setPeopleProperties(<String, String>{
          key:fcmcode
      });
  }

  Future<void> setPeopleProperties(Map<String, dynamic> props) async{
    print(await _mixpanel.getDistinctId());
    props.forEach((key, dynamic value) {
      _mixpanel.identify(_distinctId);
      _mixpanel.getPeople().set(key,value.toString());
    });

    _mixpanel.flush();
  }

  void logEvent(String eventName, {dynamic params}) {
    final emptyList = <String, String>{};
    _mixpanel.identify(_distinctId);
    _mixpanel.track(eventName, properties: params == null ? emptyList : params);

    /*
    print(
        "Event:$eventName 
        Data : ${json.encode(params == null ? emptyList : params)}");
    */
  }

  void logScreenView(String screenName, String sourceName, {dynamic params}) {
    var args = {
      AnalyticsConstants.keySource: sourceName,
    };
    if (params != null) {
      args.addAll(params);
    }
    logEvent(screenName, params: args);
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
  void reset(){
    _mixpanel.reset();
    _mixpanel.flush();
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
