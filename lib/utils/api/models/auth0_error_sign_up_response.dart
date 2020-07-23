import 'dart:convert';

Auth0ErrorSignUpResponse auth0ErrorSignUpResponseFromJson(String str) =>
    Auth0ErrorSignUpResponse.fromJson(json.decode(str));

String auth0ErrorSignUpResponseToJson(Auth0ErrorSignUpResponse data) =>
    json.encode(data.toJson());

class Auth0ErrorSignUpResponse {
  String name;
  String code;
  String description;
  int statusCode;

  Auth0ErrorSignUpResponse({
    this.name,
    this.code,
    this.description,
    this.statusCode,
  });

  factory Auth0ErrorSignUpResponse.fromJson(Map<String, dynamic> json) =>
      Auth0ErrorSignUpResponse(
        name: json["name"] == null ? null : json["name"],
        code: json["code"] == null ? null : json["code"],
        description: json["description"] == null ? null : json["description"],
        statusCode: json["statusCode"] == null ? null : json["statusCode"],
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        "name": name == null ? null : name,
        "code": code == null ? null : code,
        "description": description == null ? null : description,
        "statusCode": statusCode == null ? null : statusCode,
      };
}
