import 'dart:convert';

LoginResponse loginResponseFromJson(String str) =>
    LoginResponse.fromJson(json.decode(str));

String loginResponseToJson(LoginResponse data) => json.encode(data.toJson());

class LoginResponse {
  String accessToken;
  String refreshToken;
  String idToken;
  String scope;
  int expiresIn;
  String tokenType;

  LoginResponse({
    this.accessToken,
    this.refreshToken,
    this.idToken,
    this.scope,
    this.expiresIn,
    this.tokenType,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
        accessToken: json["access_token"] == null ? null : json["access_token"],
        refreshToken:
            json["refresh_token"] == null ? null : json["refresh_token"],
        idToken: json["id_token"] == null ? null : json["id_token"],
        scope: json["scope"] == null ? null : json["scope"],
        expiresIn: json["expires_in"] == null ? null : json["expires_in"],
        tokenType: json["token_type"] == null ? null : json["token_type"],
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        "access_token": accessToken == null ? null : accessToken,
        "refresh_token": refreshToken == null ? null : refreshToken,
        "id_token": idToken == null ? null : idToken,
        "scope": scope == null ? null : scope,
        "expires_in": expiresIn == null ? null : expiresIn,
        "token_type": tokenType == null ? null : tokenType,
      };
}
