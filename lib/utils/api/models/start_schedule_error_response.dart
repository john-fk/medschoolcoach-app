import 'dart:convert';

StartScheduleErrorResponse startScheduleErrorResponseFromJson(String str) =>
    StartScheduleErrorResponse.fromJson(json.decode(str));

String startScheduleErrorResponseToJson(StartScheduleErrorResponse data) =>
    json.encode(data.toJson());

class StartScheduleErrorResponse {
  String message;
  List<Trace> trace;

  StartScheduleErrorResponse({
    this.message,
    this.trace,
  });

  factory StartScheduleErrorResponse.fromJson(Map<String, dynamic> json) =>
      StartScheduleErrorResponse(
        message: json["message"] == null ? null : json["message"],
        trace: json["trace"] == null
            ? null
            : List<Trace>.from(
                json["trace"].map((dynamic x) => Trace.fromJson(x))),
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        "message": message == null ? null : message,
        "trace": trace == null
            ? null
            : List<dynamic>.from(trace.map<dynamic>((dynamic x) => x.toJson())),
      };
}

class Trace {
  String function;
  String traceClass;
  String file;
  int line;

  Trace({
    this.function,
    this.traceClass,
    this.file,
    this.line,
  });

  factory Trace.fromJson(Map<String, dynamic> json) => Trace(
        function: json["function"] == null ? null : json["function"],
        traceClass: json["class"] == null ? null : json["class"],
        file: json["file"] == null ? null : json["file"],
        line: json["line"] == null ? null : json["line"],
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        "function": function == null ? null : function,
        "class": traceClass == null ? null : traceClass,
        "file": file == null ? null : file,
        "line": line == null ? null : line,
      };
}
