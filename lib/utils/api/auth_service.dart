
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
      String idToken ="eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6Ik16SXhPVVZDUVVNM1FUQkRNMFJGTURnM01UVkVSREpETVRoRk56YzFPVFUxTmtORVFqQkJSQSJ9.eyJodHRwczovL21lZHNjaG9vbGNvYWNoLmNvbS9yb2xlcyI6W10sIm5pY2tuYW1lIjoiYXNkYXNkQGRzYWRzYS5jb20iLCJuYW1lIjoiYXNkYXNkQGRzYWRzYS5jb20iLCJwaWN0dXJlIjoiaHR0cHM6Ly9zLmdyYXZhdGFyLmNvbS9hdmF0YXIvOTM1Y2YxZDdlYjM3MGJkY2M3OGJmODgyNzJlYjZhMTI_cz00ODAmcj1wZyZkPWh0dHBzJTNBJTJGJTJGY2RuLmF1dGgwLmNvbSUyRmF2YXRhcnMlMkZhcy5wbmciLCJ1cGRhdGVkX2F0IjoiMjAyMS0wNS0yOFQwNDowMzoxMi41MDdaIiwiZW1haWwiOiJhc2Rhc2RAZHNhZHNhLmNvbSIsImlzcyI6Imh0dHBzOi8vYXV0aC5tZWRzY2hvb2xjb2FjaC5jb20vIiwic3ViIjoiYXV0aDB8VHV0b3JpbmdQb3J0YWx8MzM5MzQiLCJhdWQiOiJOSmpWbUdsYWEzV0djMVJyMUN1akZjdFBzWEF1VkZRTyIsImlhdCI6MTYyMjE3NDYxMSwiZXhwIjoxNjIyMjEwNjExLCJhdXRoX3RpbWUiOjE2MjIxNzQ1OTJ9.EwYOJ3jziCxHQiiWCfyRq7vm2hxQvwkbbgPCSGplNTdb-beEVIr90xs0S4j6W6cvqkkC7qe8E0SyYVpsndoxLdh4y6ohavHtB0BSx8rqFtKPulFfrmYRIKie91RL4vbtdjHHdL-QHpiUrqaVvQQU0e1lQFr4Fw7gEKEPc4CstEfG9-yMC50R3IdTOCWlSdVu14nIDUNyQGLIAQeUZvVKFnClJzg4-Q5_KnhkqAjfptyA-JvSihql32HFalFaNxrgI46hv_cvFt0JDrC-TbXOV5kTy37sz7OGd099N2OGJANM2OgwGfBMpD9gQul0A_bLpQLoX3BpUQWF-KM9MdMIuQ";
      final decodedData = parseIdToken(idToken);
      String network = decodedData != null ? decodedData["sub"] ?? "" : "";
      String trackingNetwork = fetchAuthRepresentation(network);
      _userRepository.updateUser(
          accessToken: "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6Ik16SXhPVVZDUVVNM1FUQkRNMFJGTURnM01UVkVSREpETVRoRk56YzFPVFUxTmtORVFqQkJSQSJ9.eyJodHRwczovL21lZHNjaG9vbGNvYWNoLmNvbS9yb2xlcyI6W10sImlzcyI6Imh0dHBzOi8vYXV0aC5tZWRzY2hvb2xjb2FjaC5jb20vIiwic3ViIjoiYXV0aDB8VHV0b3JpbmdQb3J0YWx8MzM5MzQiLCJhdWQiOlsiaHR0cHM6Ly9hdXRoLm1lZHNjaG9vbGNvYWNoLmNvbSIsImh0dHBzOi8vZGV2LWp5ZGxqdXBtLmF1dGgwLmNvbS91c2VyaW5mbyJdLCJpYXQiOjE2MjIxNzQ2MTEsImV4cCI6MTYyMjI2MTAxMSwiYXpwIjoiTkpqVm1HbGFhM1dHYzFScjFDdWpGY3RQc1hBdVZGUU8iLCJzY29wZSI6Im9wZW5pZCBwcm9maWxlIGVtYWlsIG9mZmxpbmVfYWNjZXNzIiwicGVybWlzc2lvbnMiOltdfQ.V-DHbdNmbYytb3bQhBm9By6gYnT5gwDa5hvqMZjYy-sdJR4tHdHBEjhp4cvIaI3w3qg6zAfVJ_jtcGwm1yEK697LxrD3TuV70SvgbfVQZZXwfqLMKmyODgB76Qea3WRmuiKTceZw7HNcEyFFnQEEjmYlSGQ3cJVE9H3s9jILtQ1GrKR5RznarE5nLXs0ayG3fYlr2gKozIXBMG_Fc_6q_EAAH1dRe4rPSybQZu4a9kQaMAW32Si1G7XgUcZa0xjUjAwUDRk61LrgRaw2cVrnNwuZ8ElUnfwMDuCF3zjGrH8rOJNH1uQnpQRfc077IeIXc3YZ03L_kokJaekkZl-qkA",
          idToken: idToken,
          refreshToken: "7XY7qKwhDuX1_pTnOEq306rLBQOVhXViCTzktIuWu27-V",
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
