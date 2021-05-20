import 'dart:convert';

ProfileUser profileUserFromJson(String str) =>
    ProfileUser.fromJson(json.decode(str));

String profileUserToJson(ProfileUser data) => json.encode(data.toJson());

class ProfileUser {
  ProfileUser(
      {this.id,
      this.email,
      this.firstName,
      this.lastName,
      this.onboarded,
      this.qotd,
      this.mcatTestDate});

  String id;
  String email;
  String firstName;
  String lastName;
  String qotd;
  bool onboarded;
  DateTime mcatTestDate;

  factory ProfileUser.fromJson(Map<String, dynamic> json) => ProfileUser(
        id: json["id"] == null ? null : json["id"],
        email: json["email"] == null ? null : json["email"],
        firstName: json["first_name"] == null ? null : json["first_name"],
        lastName: json["last_name"] == null ? null : json["last_name"],
        onboarded: json["onboarded"] == null ? null : json["onboarded"].toString().toLowerCase() == 'true' ,
        qotd : json["qotd"] == null ? null : json["qotd"],
        mcatTestDate: json["mcat_test_date"] == null
            ? null : DateTime.parse(json["mcat_test_date"]),
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        "id": id == null ? null : id,
        "email": email == null ? null : email,
        "first_name": firstName == null ? null : firstName,
        "last_name": lastName == null ? null : lastName,
        "onboarded": onboarded,
        "qotd" : qotd,
        "mcat_test_date": mcatTestDate
      };
}
