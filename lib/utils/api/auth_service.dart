
import 'dart:convert';

import 'package:Medschoolcoach/config.dart';
import 'package:Medschoolcoach/repository/user_repository.dart';
import 'package:Medschoolcoach/utils/api/network_response.dart';
import 'package:Medschoolcoach/utils/storage.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:injector/injector.dart';

import 'api_services.dart';
import 'models/login_response.dart';

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
    ApiServices apiServices = Injector.appInstance.getDependency<ApiServices>();
    try {
      final  result = await apiServices.login(
          password: "tester123",
          userEmail: "tester@tester.com"
      );

      if(result is SuccessResponse<LoginResponse>) {
        final decodedData = parseIdToken(result.body.idToken);
        String network = decodedData != null ? decodedData["sub"] ?? "" : "";
        String trackingNetwork = fetchAuthRepresentation(network);

        _userRepository.updateUser(
            accessToken: result.body.accessToken,
            idToken: result.body.idToken,
            refreshToken: result.body.refreshToken,
            expiresIn: Config.AUTH_EXPIRY_DURATION,
            lastTokenAccessTimeStamp: DateTime.now().toIso8601String());

        await _secureStorage.write(
            key: 'refresh_token', value: result.body.refreshToken);
        return AuthResponse(trackingNetwork , true);
      }
      return AuthResponse(null, false);
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
