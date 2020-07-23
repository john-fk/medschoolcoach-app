import 'package:Medschoolcoach/utils/api/models/auth0_error_sign_up_response.dart';

abstract class NetworkResponse<T> {}

class SuccessResponse<T> implements NetworkResponse<T> {
  final T body;

  SuccessResponse(this.body);

  @override
  String toString() {
    return 'SuccessResponse{body: $body}';
  }
}

class ErrorResponse<T> implements NetworkResponse<T> {
  final Exception error;

  ErrorResponse(this.error);

  @override
  String toString() {
    return 'ErrorResponse{error: $error}';
  }
}

class Auth0ErrorNetworkResponse<T> implements NetworkResponse<T> {
  final Auth0ErrorSignUpResponse errorResponse;

  Auth0ErrorNetworkResponse(this.errorResponse);
}
