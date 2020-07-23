import 'dart:convert';

import 'package:Medschoolcoach/utils/api/models/question.dart';

AnswersSummary answersSummariesFromJson(String str) =>
    AnswersSummary.fromJson(json.decode(str));

String answersSummariesToJson(AnswersSummary data) =>
    json.encode(data.toJson());

class AnswersSummary {
  int answered;
  int correct;
  int incorrect;
  int percentCorrect;
  List<Question> questions;

  AnswersSummary({
    this.answered,
    this.correct,
    this.incorrect,
    this.percentCorrect,
    this.questions,
  });

  factory AnswersSummary.fromJson(Map<String, dynamic> json) => AnswersSummary(
        answered: json["answered"] == null ? null : json["answered"],
        correct: json["correct"] == null ? null : json["correct"],
        incorrect: json["incorrect"] == null ? null : json["incorrect"],
        percentCorrect:
            json["percent_correct"] == null ? null : json["percent_correct"],
        questions: json["questions"] == null
            ? null
            : List<Question>.from(
                json["questions"].map((dynamic x) => Question.fromJson(x))),
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        "answered": answered == null ? null : answered,
        "correct": correct == null ? null : correct,
        "incorrect": incorrect == null ? null : incorrect,
        "percent_correct": percentCorrect == null ? null : percentCorrect,
        "questions": questions == null
            ? null
            : List<dynamic>.from(questions.map<dynamic>((x) => x.toJson())),
      };
}
