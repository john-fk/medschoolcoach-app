import 'dart:convert';

import 'package:Medschoolcoach/utils/api/models/video.dart';

SearchResult searchResultFromJson(String str) =>
    SearchResult.fromJson(json.decode(str));

String searchResultToJson(SearchResult data) => json.encode(data.toJson());

class SearchResult {
  List<Video> videos;
  int limit;
  int offset;
  int total;

  SearchResult({
    this.videos,
    this.limit,
    this.offset,
    this.total,
  });

  factory SearchResult.fromJson(Map<String, dynamic> json) => SearchResult(
        videos: json["items"] == null
            ? null
            : List<Video>.from(
                json["items"].map(
                  (dynamic x) => Video.fromJson(x),
                ),
              ),
        limit: json["limit"] == null ? null : json["limit"],
        offset: json["offset"] == null ? null : json["offset"],
        total: json["total"] == null ? null : json["total"],
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        "items": videos == null
            ? null
            : List<dynamic>.from(
                videos.map<dynamic>(
                  (x) => x.toJson(),
                ),
              ),
        "limit": limit == null ? null : limit,
        "offset": offset == null ? null : offset,
        "total": total == null ? null : total,
      };
}
