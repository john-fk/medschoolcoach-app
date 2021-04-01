class FlashcardsProgress {
  Map<String, ProgressData> progress;

  FlashcardsProgress({this.progress});

  FlashcardsProgress.fromJson(Map<String, dynamic> json) {
    Map<String, ProgressData> progressData = Map<String, ProgressData>();
    json.forEach((key, dynamic value) {
      var typedValue = ProgressData.fromJson(value);
      progressData[key] = typedValue;
    });
    progress = progressData;
  }

  Map<String, ProgressData> toJson() {
    return progress;
  }
}

class ProgressData {
  int positive;
  int negative;
  int neutral;
  int attempted;

  ProgressData({this.positive, this.negative, this.neutral, this.attempted});

  factory ProgressData.fromJson(Map<String, dynamic> json) => ProgressData(
        positive: json["positive"] == null ? null : json["positive"],
        negative: json["negative"] == null ? null : json["negative"],
        neutral: json["neutral"] == null ? null : json["neutral"],
        attempted: json["attempted"] == null ? null : json["attempted"],
      );
}
