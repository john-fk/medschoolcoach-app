import 'dart:async';
import 'dart:convert';
import 'package:Medschoolcoach/ui/onboarding/onboarding_state.dart';
import 'package:Medschoolcoach/utils/storage.dart';
import 'package:flutter/material.dart';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  String accessToken;
  String idToken;
  String refreshToken;
  int expiresIn;
  String lastTokenAccessTimeStamp;
  DateTime testDate;
  int studyHoursPerDay;
  TimeOfDay questionOfTheDayTime;

  User(
      {this.accessToken,
      this.idToken,
      this.refreshToken,
      this.expiresIn,
      this.lastTokenAccessTimeStamp,
      this.testDate,
      this.studyHoursPerDay,
      this.questionOfTheDayTime});

  factory User.fromJson(Map<String, dynamic> json) => User(
        accessToken: json["access_token"] == null ? null : json["access_token"],
        idToken: json["id_token"] == null ? null : json["id_token"],
        refreshToken:
            json["refresh_token"] == null ? null : json["refresh_token"],
        expiresIn: json["expires_in"] == null ? null : json["expires_in"],
        lastTokenAccessTimeStamp:
            json["timestamp"] == null ? null : json["timestamp"],
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        "access_token": accessToken == null ? null : accessToken,
        "id_token": idToken == null ? null : idToken,
        "refresh_token": refreshToken == null ? null : refreshToken,
        "expires_in": expiresIn == null ? null : expiresIn,
        "timestamp":
            lastTokenAccessTimeStamp == null ? null : lastTokenAccessTimeStamp,
      };
}

abstract class UserManager {
  Future<void> update(User user);

  Future<User> get();

  void logout();

  Future<bool> isUserLoggedIn();

  Future<void> updateScheduleDays(int days);
  void markOnboardingComplete();
  void markOnboardingState(OnboardingState state);

  Future<String> getName();
  void updateTestDate(DateTime date);
  Future<DateTime> getTestDate();
  void updateStudyTimePerDay(int hours);
  Future<int> getStudyTimePerDay();
  void updateQuestionOfTheDayTime(int time);
  Future<int> getQuestionOfTheDayTime();
  void removeDailyNotification();
  void removeTestDate();
  Future<bool> shouldShowOnboarding();
  Future<OnboardingState> getOnboardingState();
}

class UserManagerImpl implements UserManager {
  final storage = localStorage();

  @override
  Future<void> update(User user) {
    return storage.write(
      key: _userStoreKey,
      value: userToJson(user),
    );
  }

  @override
  Future<User> get() async {
    try {
      String userJson = await storage.read(key: _userStoreKey);

      if (userJson == null || userJson.isEmpty) {
        return null;
      }

      // log(userJson);
      return userFromJson(userJson);
    } catch (error) {
      return null;
    }
  }

  @override
  void logout() async {
    storage.delete(key: _userStoreKey);
    storage.delete(key: "localTutorPopup");
    storage.delete(key: "OnboardingState");
    storage.delete(key: "test_date");
    storage.delete(key: "question_of_the_day_time");
    storage.delete(key: "study_time_per_day");
    storage.delete(key: "name");
    storage.delete(key: "Flashcard_tutorial");
    storage.deleteAll();
  }

  @override
  Future<bool> isUserLoggedIn() async {
    var userJson = await storage.read(key: _userStoreKey);

    if (userJson == null || userJson.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  @override
  Future<void> updateScheduleDays(int days) async {
    User user = await get();

    return update(user);
  }

  @override
  Future<String> getName() async {
    String name = await storage?.read(key: "name");
    if (name?.isNotEmpty ?? false) {
      return name;
    }
    return "";
  }

  @override
  void updateTestDate(DateTime date) {
    storage.write(key: "test_date", value: date.toString());
  }

  @override
  Future<DateTime> getTestDate() async {
    String date = await storage?.read(key: "test_date");
    if (date?.isNotEmpty ?? false) {
      return DateTime.parse(date);
    }
    return null;
  }

  void updateStudyTimePerDay(int hours) {
    storage.write(key: "study_time_per_day", value: hours.toString());
  }

  Future<int> getStudyTimePerDay() async {
    String time = await storage?.read(key: "study_time_per_day") ?? "2";
    return int.parse(time);
  }

  void updateQuestionOfTheDayTime(int time) {
    storage.write(key: "question_of_the_day_time", value: time.toString());
  }

  Future<int> getQuestionOfTheDayTime() async {
    var time = await storage.read(key: "question_of_the_day_time");
    if (time != null) {
      return int.parse(time);
    }
    return null;
  }

  void removeDailyNotification() {
    storage.delete(key: "question_of_the_day_time");
  }

  void removeTestDate() {
    storage.delete(key: "test_date");
  }

  void markOnboardingComplete() {
    markOnboardingState(OnboardingState.Completed);
  }

  Future<bool> shouldShowOnboarding() async {
    final status = await getOnboardingState();
    return status != OnboardingState.Completed;
  }

  Future<OnboardingState> getOnboardingState() async {
    var state = await storage.read(key: "OnboardingState");
    if (state == OnboardingState.Completed.key()) {
      return OnboardingState.Completed;
    } else if (state == OnboardingState.ShowForNewUser.key()) {
      return OnboardingState.ShowForNewUser;
    } else if (state == OnboardingState.ShowForExistingUser.key()) {
      return OnboardingState.ShowForExistingUser;
    } else {
      return OnboardingState.Unset;
    }
  }

  void markOnboardingState(OnboardingState state) {
    storage.write(key: "OnboardingState", value: state.key());
  }

  static final _userStoreKey = "userStoreKey";
}
