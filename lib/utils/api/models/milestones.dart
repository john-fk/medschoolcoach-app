// To parse this JSON data, do
//
//     final milestones = milestonesFromJson(jsonString);

import 'dart:convert';

import 'package:Medschoolcoach/utils/api/models/statistics.dart';

Milestones milestonesFromJson(String str) =>
    Milestones.fromJson(json.decode(str));

String milestonesToJson(Milestones data) => json.encode(data.toJson());

class Milestones {
  Statistics global;
  Badges badges;

  Milestones({
    this.global,
    this.badges,
  });

  factory Milestones.fromJson(Map<String, dynamic> json) => Milestones(
        global:
            json["global"] == null ? null : Statistics.fromJson(json["global"]),
        badges: json["badges"] == null ? null : Badges.fromJson(json["badges"]),
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        "global": global == null ? null : global.toJson(),
        "badges": badges == null ? null : badges.toJson(),
      };
}

class Badges {
  List<String> videos;
  List<String> questions;
  List<String> flashcards;

  Badges({
    this.videos,
    this.questions,
    this.flashcards,
  });

  factory Badges.fromJson(Map<String, dynamic> json) => Badges(
        videos: json["videos"] == null
            ? null
            : List<String>.from(json["videos"].map((dynamic x) => x)),
        questions: json["questions"] == null
            ? null
            : List<String>.from(json["questions"].map((dynamic x) => x)),
        flashcards: json["flashcards"] == null
            ? null
            : List<String>.from(json["flashcards"].map((dynamic x) => x)),
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        "videos": videos == null
            ? null
            : List<dynamic>.from(videos.map<dynamic>((x) => x)),
        "questions": questions == null
            ? null
            : List<dynamic>.from(questions.map<dynamic>((x) => x)),
        "flashcards": flashcards == null
            ? null
            : List<dynamic>.from(flashcards.map<dynamic>((x) => x)),
      };
}
