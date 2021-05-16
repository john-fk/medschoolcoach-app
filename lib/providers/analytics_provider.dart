import 'package:Medschoolcoach/providers/analytics_constants.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';
import 'package:Medschoolcoach/config.dart';
import 'dart:convert';

class AnalyticsProvider {
  Mixpanel _mixpanel;

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
    return this._mixpanel.identify(distinctId);
  }

  void identifyPeople(String distinctId) {
    return this.logEvent("identifyPeople", params: {"distinctId": distinctId});
  }

  void setPeopleProperties(Map<String, dynamic> props) {
    return this.logEvent("setPeopleProperties", params: props);
  }

  void logEvent(String eventName, {dynamic params}) {
    final emptyList = <String, String>{};
    this
        ._mixpanel
        .track(eventName, properties: params == null ? emptyList : params);

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
