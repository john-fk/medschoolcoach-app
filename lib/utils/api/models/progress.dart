class Progress {
  int percentage;
  int seconds;

  Progress({
    this.percentage,
    this.seconds,
  });

  factory Progress.fromJson(Map<String, dynamic> json) => Progress(
        percentage: json["percentage"] == null ? null : json["percentage"],
        seconds: json["seconds"] == null ? null : json["seconds"],
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        "percentage": percentage == null ? null : percentage,
        "seconds": seconds == null ? null : seconds,
      };
}
