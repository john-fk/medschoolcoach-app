
import 'package:Medschoolcoach/config.dart';
import 'package:Medschoolcoach/repository/user_repository.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class AuthServices {
  // ignore: avoid_positional_boolean_parameters
  Future<bool> loginAuth0(bool isLogin);
}

class AuthServicesImpl implements AuthServices {
  final UserRepository _userRepository;
  final FlutterSecureStorage _secureStorage;
  final FlutterAppAuth _appAuth;

  AuthServicesImpl(this._userRepository, this._secureStorage, this._appAuth);

  @override
  Future<bool> loginAuth0(bool isLogin) async {
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
      _userRepository.updateUser(
          accessToken: result.accessToken,
          idToken: result.idToken,
          refreshToken: result.refreshToken,
          expiresIn: Config.AUTH_EXPIRY_DURATION,
          lastTokenAccessTimeStamp: DateTime.now().toIso8601String());
      await _secureStorage.write(
          key: 'refresh_token', value: result.refreshToken);
      return true;
    } catch (e) {
      return false;
    }
  }
}
