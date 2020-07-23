class Setting {
  String sectionId;
  String backgroundIcon;
  String backgroundColor;
  DateTime createdAt;
  DateTime updatedAt;

  Setting({
    this.sectionId,
    this.backgroundIcon,
    this.backgroundColor,
    this.createdAt,
    this.updatedAt,
  });

  factory Setting.fromJson(Map<String, dynamic> json) => Setting(
        sectionId: json["section_id"] == null ? null : json["section_id"],
        backgroundIcon:
            json["background_icon"] == null ? null : json["background_icon"],
        backgroundColor:
            json["background_color"] == null ? null : json["background_color"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        "section_id": sectionId == null ? null : sectionId,
        "background_icon": backgroundIcon == null ? null : backgroundIcon,
        "background_color": backgroundColor == null ? null : backgroundColor,
        "created_at": createdAt == null ? null : createdAt.toIso8601String(),
        "updated_at": updatedAt == null ? null : updatedAt.toIso8601String(),
      };
}
