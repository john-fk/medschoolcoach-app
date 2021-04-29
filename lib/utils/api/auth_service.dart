
import 'dart:convert';

import 'package:Medschoolcoach/config.dart';
import 'package:Medschoolcoach/repository/user_repository.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

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
  final FlutterSecureStorage _secureStorage;
  final FlutterAppAuth _appAuth;

  AuthServicesImpl(this._userRepository, this._secureStorage, this._appAuth);

  @override
  Future<AuthResponse> loginAuth0(bool isLogin) async {
    try {
      final AuthorizationTokenResponse result =
          await _appAuth.authorizeAndExchangeCode(
        AuthorizationTokenRequest(
          Config.AUTH0_CLIENT_ID,
          Config.AUTH0_REDIRECT_URI,
          additionalParameters: {
            'audience': Config.prodBaseAuth0Url,
            'action': isLogin ? 'login' : 'signup'
          },
          issuer: Config.AUTH0_ISSUER,
          scopes: ['openid', 'profile', 'email', 'offline_access', 'api'],
          promptValues: ['login'],
        ),
      );
      final decodedData = parseIdToken(result.idToken);
      String network = decodedData != null ? decodedData["sub"] ?? "" : "";
      String trackingNetwork = fetchAuthRepresentation(network);
      _userRepository.updateUser(
          accessToken: result.accessToken,
          idToken: result.idToken,
          refreshToken: result.refreshToken,
          expiresIn: Config.AUTH_EXPIRY_DURATION,
          lastTokenAccessTimeStamp: DateTime.now().toIso8601String());
      await _secureStorage.write(
          key: 'refresh_token', value: result.refreshToken);
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
