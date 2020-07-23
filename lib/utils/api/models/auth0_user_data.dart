import 'dart:convert';

Auth0UserData auth0UserDataFromJson(String str) =>
    Auth0UserData.fromJson(json.decode(str));

String auth0UserDataToJson(Auth0UserData data) => json.encode(data.toJson());

class Auth0UserData {
  String sub;
  String nickname;
  String name;
  String picture;
  DateTime updatedAt;
  String email;
  bool emailVerified;

  Auth0UserData({
    this.sub,
    this.nickname,
    this.name,
    this.picture,
    this.updatedAt,
    this.email,
    this.emailVerified,
  });

  factory Auth0UserData.fromJson(Map<String, dynamic> json) => Auth0UserData(
        sub: json["sub"] == null ? null : json["sub"],
        nickname: json["nickname"] == null ? null : json["nickname"],
        name: json["name"] == null ? null : json["name"],
        picture: json["picture"] == null ? null : json["picture"],
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        email: json["email"] == null ? null : json["email"],
        emailVerified:
            json["email_verified"] == null ? null : json["email_verified"],
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        "sub": sub == null ? null : sub,
        "nickname": nickname == null ? null : nickname,
        "name": name == null ? null : name,
        "picture": picture == null ? null : picture,
        "updated_at": updatedAt == null ? null : updatedAt.toIso8601String(),
        "email": email == null ? null : email,
        "email_verified": emailVerified == null ? null : emailVerified,
      };
}
