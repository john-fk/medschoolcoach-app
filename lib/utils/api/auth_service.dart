
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

      String idToken = "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6Ik16SXhPVVZDUVVNM1FUQkRNMFJGTURnM01UVkVSREpETVRoRk56YzFPVFUxTmtORVFqQkJSQSJ9.eyJodHR";
      String refreshToken = "a76NkVIl9WoHcA31B9wdb-66DXqf2eFbYvp5BkUO03hrV";
      String accessToken = "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6Ik16SXhPVVZDUVVNM1FUQkRNMFJGTURnM01UVkVSREpETVRoRk56YzFPVFUxTmtORVFqQkJSQSJ9.eyJodHR";

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
