import 'dart:convert';

import 'package:Medschoolcoach/utils/api/models/flashcard_model.dart';

class FlashcardsStackModel {
  List<FlashcardModel> items;
  int limit;
  int offset;
  int total;

  FlashcardsStackModel({
    this.items,
    this.limit,
    this.offset,
    this.total,
  });

  factory FlashcardsStackModel.fromRawJson(String str) =>
      FlashcardsStackModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory FlashcardsStackModel.fromJson(Map<String, dynamic> json) =>
      FlashcardsStackModel(
        items: json["items"] == null
            ? null
            : List<FlashcardModel>.from(
                json["items"].map((dynamic x) => FlashcardModel.fromJson(x))),
        limit: json["limit"] == null ? null : json["limit"],
        offset: json["offset"] == null ? null : json["offset"],
        total: json["total"] == null ? null : json["total"],
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        "items": items == null
            ? null
            : List<dynamic>.from(items.map<dynamic>((x) => x.toJson())),
        "limit": limit == null ? null : limit,
        "offset": offset == null ? null : offset,
        "total": total == null ? null : total,
      };
}
