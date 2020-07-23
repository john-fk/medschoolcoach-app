import 'package:Medschoolcoach/utils/api/models/setting.dart';
import 'package:Medschoolcoach/utils/api/models/subject.dart';
import 'package:Medschoolcoach/utils/api/models/topic.dart';

class Section {
  String id;
  String name;
  String image;
  int order;
  DateTime createdAt;
  DateTime updatedAt;
  Setting setting;
  int percentage;
  int amountOfVideos;
  List<Subject> subjects;
  int amountOfQuestions;
  int amountOfNewQuestions;
  int amountOfFlashcards;

  Section({
    this.id,
    this.name,
    this.image,
    this.order,
    this.createdAt,
    this.updatedAt,
    this.setting,
    this.percentage,
    this.amountOfVideos,
    this.subjects,
    this.amountOfQuestions,
    this.amountOfNewQuestions,
    this.amountOfFlashcards,
  });

  factory Section.fromJson(Map<String, dynamic> json) {
    List<Subject> subjects;
    List<Topic> topics;

    if (json["topics"] != null)
      topics = List<Topic>.from(
        json["topics"].map((dynamic x) => Topic.fromJson(x)),
      );

    if (json["subjects"] != null)
      subjects = List<Subject>.from(
          json["subjects"].map((dynamic x) => Subject.fromJson(x)));

    if (topics != null && subjects != null) {
      topics.forEach((topic) {
        subjects.forEach((subject) {
          if (subject.id == topic.subjectId) subject.topics.add(topic);
        });
      });

      subjects.sort(
          (subject1, subject2) => subject1.order.compareTo(subject2.order));

      subjects.forEach((subject) => subject.topics
          .sort((topic1, topic2) => topic1.order.compareTo(topic2.order)));
    }

    return Section(
      id: json["id"] == null ? null : json["id"],
      name: json["name"] == null ? null : json["name"],
      image: json["image"] == null ? null : json["image"],
      order: json["order"] == null ? null : json["order"],
      createdAt: json["created_at"] == null
          ? null
          : DateTime.parse(json["created_at"]),
      updatedAt: json["updated_at"] == null
          ? null
          : DateTime.parse(json["updated_at"]),
      setting:
          json["setting"] == null ? null : Setting.fromJson(json["setting"]),
      percentage: json["percentage"] == null ? null : json["percentage"],
      amountOfVideos:
          json["amount_of_videos"] == null ? null : json["amount_of_videos"],
      subjects: subjects,
      amountOfQuestions: json["amount_of_questions"] == null
          ? null
          : json["amount_of_questions"],
      amountOfNewQuestions: json["amount_of_new_questions"] == null
          ? null
          : json["amount_of_new_questions"],
      amountOfFlashcards: json["amount_of_flashcards"] == null
          ? null
          : json["amount_of_flashcards"],
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        "id": id == null ? null : id,
        "name": name == null ? null : name,
        "image": image == null ? null : image,
        "order": order == null ? null : order,
        "created_at": createdAt == null ? null : createdAt.toIso8601String(),
        "updated_at": updatedAt == null ? null : updatedAt.toIso8601String(),
        "setting": setting == null ? null : setting.toJson(),
        "amount_of_videos": amountOfVideos == null ? null : amountOfVideos,
        "percentage": percentage == null ? null : percentage,
        "amount_of_questions":
            amountOfQuestions == null ? null : amountOfQuestions,
        "amount_of_new_questions":
            amountOfNewQuestions == null ? null : amountOfNewQuestions,
        "amount_of_flashcards":
            amountOfFlashcards == null ? null : amountOfFlashcards,
      };
}
