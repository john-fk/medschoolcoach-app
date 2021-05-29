
import 'dart:convert';

import 'package:Medschoolcoach/config.dart';
import 'package:Medschoolcoach/repository/user_repository.dart';
import 'package:Medschoolcoach/utils/storage.dart';
import 'package:flutter_appauth/flutter_appauth.dart';

abstract class AuthServices {
  // ignore: avoid_positional_boolean_parameters
  Future<AuthResponse> loginAuth0(bool isLogin);
}

class AuthResponse {
  final String network;
  final bool didSucceed;

  // ignore: avoid_positional_boolean_parameters
  const AuthResponse(this.network, this.didSucceed);
}

class AuthServicesImpl implements AuthServices {
  final UserRepository _userRepository;
  final localStorage _secureStorage;
  final FlutterAppAuth _appAuth;

  AuthServicesImpl(this._userRepository, this._secureStorage, this._appAuth);

  @override
  Future<AuthResponse> loginAuth0(bool isLogin) async {
    try {
      var accessToken = "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6Ik16SXhPVVZDUVVNM1FUQkRNMFJGTURnM01UVkVSREpETVRoRk56YzFPVFUxTmtORVFqQkJSQSJ9.eyJodHRwczovL21lZHNjaG9vbGNvYWNoLmNvbS9yb2xlcyI6W10sImlzcyI6Imh0dHBzOi8vYXV0aC5tZWRzY2hvb2xjb2FjaC5jb20vIiwic3ViIjoiYXV0aDB8VHV0b3JpbmdQb3J0YWx8MzM5OTAiLCJhdWQiOlsiaHR0cHM6Ly9hdXRoLm1lZHNjaG9vbGNvYWNoLmNvbSIsImh0dHBzOi8vZGV2LWp5ZGxqdXBtLmF1dGgwLmNvbS91c2VyaW5mbyJdLCJpYXQiOjE2MjIyODc0NTQsImV4cCI6MTYyMjM3Mzg1NCwiYXpwIjoiTkpqVm1HbGFhM1dHYzFScjFDdWpGY3RQc1hBdVZGUU8iLCJzY29wZSI6Im9wZW5pZCBwcm9maWxlIGVtYWlsIG9mZmxpbmVfYWNjZXNzIiwicGVybWlzc2lvbnMiOltdfQ.Gpi0zdaSYA08gt0b4kWDWFmefcAplM2r0KZ_OjpvOqHxDMDbvNqDgRgbg8yBYie2LXkG-t4oVjHi1UI9JBVGt09xbLyJkVSLeJOtaHPcTQKNtiXZiBrDhkaKaHhPz5aX-UvwuGPi6jJm32eX5AKo1G18H7RM3nlcf57MLTkPnpf2ds6rMNyiUVw8OIuWyhK6mfInwQ1_PfzmNw9vp7aaM_RQv0D0GbXr4SUb52x8YacVMZQ4qlHAGmijRJRS_vrhwaOFEHPMjYP5FeO5upC6t-Pw-btwyURSjMefr37PTIXetrSfiWBZEhpdhNFaQ1UltSX8GLNdhthxwwLYt3cl7A";
      var refreshToken = "9794zM1ecQAq3_TI2K4846IHwQ_PH4yFWC2CtgVFjbc1B";
      var idToken = "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6Ik16SXhPVVZDUVVNM1FUQkRNMFJGTURnM01UVkVSREpETVRoRk56YzFPVFUxTmtORVFqQkJSQSJ9.eyJodHRwczovL21lZHNjaG9vbGNvYWNoLmNvbS9yb2xlcyI6W10sIm5pY2tuYW1lIjoidGVzdGVyQHRlc3Rlci5jb20iLCJuYW1lIjoidGVzdGVyQHRlc3Rlci5jb20iLCJwaWN0dXJlIjoiaHR0cHM6Ly9zLmdyYXZhdGFyLmNvbS9hdmF0YXIvY2UxYzk2ZWExNTg2NzVmMzllNTdjOTFiYzUwZDdjMTY_cz00ODAmcj1wZyZkPWh0dHBzJTNBJTJGJTJGY2RuLmF1dGgwLmNvbSUyRmF2YXRhcnMlMkZ0ZS5wbmciLCJ1cGRhdGVkX2F0IjoiMjAyMS0wNS0yOVQxMToyNDoxMC43MTdaIiwiZW1haWwiOiJ0ZXN0ZXJAdGVzdGVyLmNvbSIsImlzcyI6Imh0dHBzOi8vYXV0aC5tZWRzY2hvb2xjb2FjaC5jb20vIiwic3ViIjoiYXV0aDB8VHV0b3JpbmdQb3J0YWx8MzM5OTAiLCJhdWQiOiJOSmpWbUdsYWEzV0djMVJyMUN1akZjdFBzWEF1VkZRTyIsImlhdCI6MTYyMjI4NzQ1NCwiZXhwIjoxNjIyMzIzNDU0LCJhdXRoX3RpbWUiOjE2MjIyODc0NTB9.gkyZ8burcXtgxu8PacFIQmNf-lqv0UiAYElnyx0yYhGmayhnvZa9X3Nw7QSC0n_xVsBM4PMaKyfJXbj1x-SBCITheoA_9DPtTuMpZBTTQDCkjYSPDagGvF29DwnezGH9PvLcK-Sf2dFkX8jzp6kAXzDdGKIYCHCLnfafyFXbY-W7XujveJH2pvP8yHVDPsLhetR_NY-xuKiOpB6kXrs2gTg-l9jN9Wp56VYTi--qKdvxjG4Tx2SH8Q-OebtIrUUBVqkj6MZLZcv9_rfmYltC7CVnKDUfsqIARUM0Qa8znqR6oL4uoFE0TxHRBacNPD6EUG4HvxB1nZFGyOD-4ERQCg";

      final decodedData = parseIdToken(idToken);
      String network = decodedData != null ? decodedData["sub"] ?? "" : "";
      String trackingNetwork = fetchAuthRepresentation(network);
      _userRepository.updateUser(
          accessToken: accessToken,
          idToken: idToken,
          refreshToken: refreshToken,
          expiresIn: Config.AUTH_EXPIRY_DURATION,
          lastTokenAccessTimeStamp: DateTime.now().toIso8601String());
      await _secureStorage.write(
          key: 'refresh_token', value: "7XY7qKwhDuX1_pTnOEq306rLBQOVhXViCTzktIuWu27-V");
      return AuthResponse(trackingNetwork , true);
    } catch (e) {
      return AuthResponse(null, false);
    }
  }

  String fetchAuthRepresentation(String network) {
    if (network.isEmpty) {
      return network;
    }

    List<String> parsedNetworks = network.split("|");
    if (parsedNetworks.isEmpty || parsedNetworks.length == 1) {
      return network;
    }

    var trackingNetwork = parsedNetworks.first;
    if (trackingNetwork == "auth0") trackingNetwork = "email";
    return trackingNetwork;

  }
  Map<String, dynamic> parseIdToken(String idToken) {
    final parts = idToken.split(r'.');
    assert(parts.length == 3);

    return jsonDecode(
        utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))));
  }
}
