import 'dart:convert';

List<Buddy> buddyFromJson(String str) =>
    List<Buddy>.from(json.decode(str).map((dynamic x) => Buddy.fromJson(x)));

String buddyToJson(List<Buddy> data) =>
    json.encode(List<dynamic>.from(data.map<dynamic>((x) => x.toJson())));

class Buddy {
  String id;
  String userId;
  String invitedEmail;
  String invitedFirstName;
  String invitedLastName;
  String status;
  DateTime createdAt;
  DateTime updatedAt;

  Buddy({
    this.id,
    this.userId,
    this.invitedEmail,
    this.invitedFirstName,
    this.invitedLastName,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory Buddy.fromJson(Map<String, dynamic> json) => Buddy(
        id: json["id"] == null ? null : json["id"],
        userId: json["user_id"] == null ? null : json["user_id"],
        invitedEmail:
            json["invited_email"] == null ? null : json["invited_email"],
        invitedFirstName: json["invited_first_name"] == null
            ? null
            : json["invited_first_name"],
        invitedLastName: json["invited_last_name"] == null
            ? null
            : json["invited_last_name"],
        status: json["status"] == null ? null : json["status"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        "id": id == null ? null : id,
        "user_id": userId == null ? null : userId,
        "invited_email": invitedEmail == null ? null : invitedEmail,
        "invited_first_name":
            invitedFirstName == null ? null : invitedFirstName,
        "invited_last_name": invitedLastName == null ? null : invitedLastName,
        "status": status == null ? null : status,
        "created_at": createdAt == null ? null : createdAt.toIso8601String(),
        "updated_at": updatedAt == null ? null : updatedAt.toIso8601String(),
      };
}
