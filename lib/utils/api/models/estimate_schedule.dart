class EstimateSchedule {
  Map<String, int> estimate;

  EstimateSchedule({this.estimate});

  EstimateSchedule.fromJSON(Map<String, dynamic> json) {
    Map<String, int> data = Map<String, int>();
    json.forEach((key, dynamic value) {
      data[key] = value;
    });
    estimate = data;
  }

  Map<String, int> toJSON() {
    return estimate;
  }
}
