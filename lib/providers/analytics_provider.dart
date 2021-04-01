import 'package:Medschoolcoach/providers/analytics_constants.dart';
import 'package:native_mixpanel/native_mixpanel.dart';

class AnalyticsProvider {
  Mixpanel _mixpanel;

  AnalyticsProvider() {
    _mixpanel = Mixpanel(shouldLogEvents: true, isOptedOut: false);
  }

  Future initialize(String token) {
    return this._mixpanel.initialize(token);
  }

  Future identify(String distinctId) {
    return this._mixpanel.identify(distinctId);
  }

  Future identifyPeople(String distinctId) {
    return this._mixpanel.identifyPeople(distinctId);
  }

  Future setPeopleProperties(Map<String, dynamic> props) {
    return this._mixpanel.setPeopleProperties(props);
  }

  void logEvent(String eventName, {dynamic params}) {
    _mixpanel.track(eventName, params);
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
      String event, String email, bool isSuccess, String errorMessage) {
    logEvent(event, params: {
      AnalyticsConstants.keyEmail: email,
      AnalyticsConstants.keyIsSuccess: isSuccess,
      AnalyticsConstants.keyError: errorMessage
    });
  }
}
