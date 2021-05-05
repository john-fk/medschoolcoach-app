import 'dart:convert';

Auth0UserData auth0UserDataFromJson(String str) =>
    Auth0UserData.fromJson(json.decode(str));

String auth0UserDataToJson(Auth0UserData data) => json.encode(data.toJson());

class Auth0UserData {
  String id;
  String email;
  String name;
  String picture;

  Auth0UserData({
    this.id,
    this.email,
    this.name,
    this.picture,
  });

  factory Auth0UserData.fromJson(Map<String, dynamic> json) => Auth0UserData(
      id: json["id"] == null ? null : json["id"],
      name: json["first_name"] == null
          ? null
          : "${json['first_name']} ${json['last_name']}",
      picture: json["picture"] == null ? null : json["picture"],
      email: json["email"] == null ? null : json["email"]);

  Map<String, dynamic> toJson() => <String, dynamic>{
        "id": id == null ? null : id,
        "name": name == null ? null : name,
        "picture": picture == null ? null : picture,
        "email": email == null ? null : email
      };
}
