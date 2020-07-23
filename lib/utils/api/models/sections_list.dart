import 'dart:convert';

import 'package:Medschoolcoach/utils/api/models/section.dart';

SectionsList sectionListFromJson(
  String str,
) =>
    SectionsList.fromJson(json.decode(str));

SectionsList sectionListFromJsonList(
  String str,
) =>
    SectionsList.fromListJson(json.decode(str));

String sectionListToJson(SectionsList data) => json.encode(data.toJson());

class SectionsList {
  List<Section> sections;
  int limit;
  int offset;
  int total;

  SectionsList({
    this.sections,
    this.limit,
    this.offset,
    this.total,
  });

  factory SectionsList.fromJson(Map<String, dynamic> json) => SectionsList(
        sections: json["items"] == null
            ? null
            : List<Section>.from(
                json["items"].map((dynamic x) => Section.fromJson(x))),
        limit: json["limit"] == null ? null : json["limit"],
        offset: json["offset"] == null ? null : json["offset"],
        total: json["total"] == null ? null : json["total"],
      );

  factory SectionsList.fromListJson(List<dynamic> json) {
    if (json == null) return null;
    final sections = List<Section>();
    json.forEach((dynamic section) => sections.add(Section.fromJson(section)));
    return SectionsList(sections: sections);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        "items": sections == null
            ? null
            : List<dynamic>.from(
                sections.map<dynamic>((dynamic x) => x.toJson())),
        "limit": limit == null ? null : limit,
        "offset": offset == null ? null : offset,
        "total": total == null ? null : total,
      };
}
