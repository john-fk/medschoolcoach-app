import 'package:Medschoolcoach/utils/api/errors.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:firebase_performance/firebase_performance.dart';

abstract class NetworkClient {
  Future<String> get(
    String url, {
    Map<String, String> headers,
  });

  Future<String> post(
    String url, {
    Map headers,
    dynamic body,
    dynamic encoding,
  });

  Future<String> put(
    String url, {
    Map headers,
    dynamic body,
    dynamic encoding,
  });

  Future<String> delete(
    String url, {
    Map<String, String> headers,
    dynamic requestBody,
  });

  Future<String> patch(
    String url, {
    Map headers,
    dynamic body,
    dynamic encoding,
  });
}

class _MetricHttpClient extends BaseClient {
  _MetricHttpClient(this._inner);

  final Client _inner;

  @override
  Future<StreamedResponse> send(BaseRequest request) async {
    final HttpMetric metric = FirebasePerformance.instance
        .newHttpMetric(request.url.toString(), HttpMethod.Get);

    await metric.start();

    StreamedResponse response;
    try {
  //    response = await _inner.send(request);
 //     metric
  //      ..responsePayloadSize = response.contentLength
  //      ..responseContentType = response.headers['Content-Type']
  //      ..requestPayloadSize = request.contentLength
  //      ..httpResponseCode = response.statusCode;
    } finally {
      await metric.stop();
    }
    return response;
  }
}

class NetworkClientImpl implements NetworkClient {
  @override
  Future<String> get(String url, {Map<String, String> headers}) {

    var request = http.Request("GET", Uri.parse(url))
      ..headers.addAll(headers)
      ..body = url;

    Crashlytics.instance.log("Request: GET url: ${url} headers: ${headers}");
    final _MetricHttpClient metricHttpClient = _MetricHttpClient(Client());
    metricHttpClient.send(request);
    metricHttpClient.close();
    return http.get(url, headers: headers).then((response) {
      String body = response.body;
      int statusCode = response.statusCode;

      if (_isError(statusCode, body)) {
        Crashlytics.instance.log(
            "Error: GET url: ${url} statusCode: ${statusCode} body: ${body}");
        throw ApiException(statusCode, body);
      }
      return body;
    }).timeout(Duration(seconds: 30));
  }

  @override
  Future<String> post(String url,
      {Map headers, dynamic body, dynamic encoding}) {
    Crashlytics.instance
        .log("Request: POST url: ${url} headers: ${headers} body: ${body}");

    return http
        .post(url, headers: headers, body: body, encoding: encoding)
        .then((http.Response response) {
      String body = response.body;
      int statusCode = response.statusCode;

      if (_isError(statusCode, body)) {
        Crashlytics.instance.log(
            "Error: POST url: ${url} statusCode: ${statusCode} body: ${body}");
        throw ApiException(statusCode, body);
      }

      return body;
    }).timeout(Duration(seconds: 30));
  }

  @override
  Future<String> put(
    String url, {
    Map headers,
    dynamic body,
    dynamic encoding,
  }) {
    Crashlytics.instance
        .log("Request: PUT url: ${url} headers: ${headers} body: ${body}");
    return http
        .put(url, headers: headers, body: body, encoding: encoding)
        .then((response) {
      String body = response.body;
      int statusCode = response.statusCode;

      if (_isError(statusCode, body)) {
        Crashlytics.instance.log(
            "Error: PUT url: ${url} statusCode: ${statusCode} body: ${body}");
        throw ApiException(statusCode, body);
      }
print("put $url");
      return body;
    }).timeout(Duration(seconds: 30));
  }

  @override
  Future<String> delete(
    String url, {
    Map<String, String> headers,
    dynamic requestBody,
  }) async {
    Crashlytics.instance.log(
        "Request: DELT url: ${url} headrs: ${headers} reqBody: ${requestBody}");

    final client = http.Client();

    var request = http.Request("DELETE", Uri.parse(url))
      ..headers.addAll(headers)
      ..body = requestBody;

    return await client.send(request).then((responseStream) async {
      final response = await http.Response.fromStream(responseStream);
      String responseBody = response.body;
      int statusCode = response.statusCode;

      if (_isError(statusCode, responseBody)) {
        Crashlytics.instance.log(
            "Error: DELT url: ${url} stat: ${statusCode} bdy: ${responseBody}");
        throw ApiException(statusCode, responseBody);
      }

      return responseBody;
    }).timeout(
      Duration(seconds: 30),
    );
  }

  bool _isError(int statusCode, String body) {
    if (statusCode < 200 || statusCode >= 400 || body == null) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Future<String> patch(String url,
      {Map headers, dynamic body, dynamic encoding}) {
    Crashlytics.instance
        .log("Request: PATCH url: ${url} headrs: ${headers} body: ${body}");
    return http
        .patch(url, headers: headers, body: body, encoding: encoding)
        .then((response) {
      String body = response.body;
      int statusCode = response.statusCode;

      if (_isError(statusCode, body)) {
        Crashlytics.instance.log(
            "Error: PATCH url: ${url} statusCode: ${statusCode} body: ${body}");
        throw ApiException(statusCode, body);
      }

      return body;
    }).timeout(Duration(seconds: 30));
  }
}
