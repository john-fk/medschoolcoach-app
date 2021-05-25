import 'package:Medschoolcoach/providers/analytics_constants.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:Medschoolcoach/config.dart';
import 'dart:convert';
import 'dart:io' show Platform;

class AnalyticsProvider {
  Mixpanel _mixpanel;
  String _distinctId;
  String token;
  String key;
  bool isShow = false;

  AnalyticsProvider() {
    this.initialize();
    key = this.keyDevice();
  }


  Future initialize([String token=Config.prodMixPanelToken]) async {
    if (_mixpanel == null) {
      _mixpanel = await Mixpanel.init(token, optOutTrackingDefault: false);
    }
    return _mixpanel;
  }

  void identify(String distinctId) {
    if (distinctId == null || _distinctId == distinctId) return;
    _distinctId = distinctId;
    return _mixpanel.alias("auth",distinctId);
  }

  void identifyPeople(String distinctId) {
    return logEvent("identifyPeople", params: {"distinctId": distinctId});
  }

  String keyDevice(){
    if (Platform.isAndroid)
      return "\$android_devices";
    else if ( Platform.isIOS)
      return "\$ios_devices";
    return null;
  }

  void setToken({bool remove=false}){
    if (key!=null) {
      print("TOKEN : " + token);

      setPeopleProperties(<String, String>{
        key: token
      },remove:remove);
    }

  }


  Future<void> setPeopleProperties(Map<String, dynamic> props,{bool remove=false}) async{
    if (_distinctId == null) return;
    props.forEach((key, dynamic value) {
      _mixpanel.identify(_distinctId);
      if (remove)
        _mixpanel.getPeople().remove(key,value.toString());
      else
        _mixpanel.getPeople().set(key,value.toString());
    });

    await _mixpanel.flush();
  }

  void logEvent(String eventName, {dynamic params}) {
    if (isShow)
      Fluttertoast.showToast(
          msg: "key:" + eventName + "\n" + jsonEncode(params),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP_RIGHT,
          timeInSecForIosWeb: 2,
      );
    final emptyList = <String, String>{};
    if (_distinctId!=null)
      _mixpanel.identify(_distinctId);
   _mixpanel.track(eventName, properties: params == null ? emptyList : params);
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
  Future<void> reset() async{
    await setToken(remove: true);
    _distinctId = null;
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
