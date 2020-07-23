import 'dart:async';
import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  String accessToken;
  String idToken;
  String refreshToken;
  int expiresIn;
  String lastTokenAccessTimeStamp;

  User({
    this.accessToken,
    this.idToken,
    this.refreshToken,
    this.expiresIn,
    this.lastTokenAccessTimeStamp,
  });

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
}

class UserManagerImpl implements UserManager {
  final storage = FlutterSecureStorage();

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

      return userFromJson(userJson);
    } catch (error) {
      return null;
    }
  }

  @override
  void logout() async {
    storage.delete(key: _userStoreKey);
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

  static final _userStoreKey = "userStoreKey";
}
