class ScheduleStats {
  int courseProgress;
  int totalDays;
  int daysLeft;
  int noHours;
  String startDate;
  String actualCompletionDate;

  ScheduleStats(
      {this.courseProgress,
      this.totalDays,
      this.daysLeft,
      this.noHours,
      this.startDate,
      this.actualCompletionDate});

  ScheduleStats.fromJson(Map<String, dynamic> json) {
    courseProgress =
        json['course_progress'] != null ? json['course_progress'] : null;
    totalDays = json['total_days'] != null ? json['total_days'] : null;
    daysLeft = json['days_left'] != null ? json['days_left'] : null;
    noHours = json['no_hours'] != null ? json['no_hours'] : null;
    startDate = json['start_date'] != null ? json['start_date'] : null;
    actualCompletionDate = json['actual_completion_date'] != null
        ? json['actual_completion_date']
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['course_progress'] = this.courseProgress;
    data['total_days'] = this.totalDays;
    data['days_left'] = this.daysLeft;
    data['no_hours'] = this.noHours;
    data['start_date'] = this.startDate;
    data['actual_completion_date'] = this.actualCompletionDate;
    return data;
  }
}
