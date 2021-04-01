import 'dart:convert';

QuestionBankProgress questionBankProgressFromJson(String str) =>
    QuestionBankProgress.fromJson(json.decode(str));

String profileUserToJson(QuestionBankProgress data) =>
    json.encode(data.toJson());

class QuestionBankProgress {
  Map<String, ProgressData> progress;

  QuestionBankProgress({this.progress});

  QuestionBankProgress.fromJson(Map<String, dynamic> json) {
    Map<String, ProgressData> progressData = Map<String, ProgressData>();
    json.forEach((key, dynamic value) {
      var typedValue = ProgressData.fromJson(value);
      progressData[key] = typedValue;
    });
    progress = progressData;
  }

  Map<String, ProgressData> toJson() {
    return this.progress;
  }
}

class ProgressData {
  int correct;
  int wrong;
  int attempted;

  ProgressData({this.correct, this.wrong, this.attempted});

  factory ProgressData.fromJson(Map<String, dynamic> json) => ProgressData(
    correct: json["correct"] == null ? null : json["correct"],
    wrong: json["wrong"] == null ? null : json["wrong"],
    attempted: json["attempted"] == null ? null : json["attempted"],
  );
}

