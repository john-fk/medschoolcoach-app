enum ApiError {
  networkError,

  /// No connection or server error
  sessionExpired,

  /// Session expired, user should be logged out
  unknown,

  /// Unknown error has occurred
  wrongCredentials,

  /// Video not found among videos
  videoNotFound,

  /// Users's schedule not selected
  scheduleNotSelected,

  /// Choosen email address is already taken
  unavailableEmail,
}

class SessionExpiredException implements Exception {}

class UnavailableEmailException implements Exception {}

class ApiException implements Exception {
  int code;
  String body;

  ApiException(this.code, this.body);

  @override
  String toString() {
    return 'ApiException{code: $code, body: $body}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ApiException &&
          runtimeType == other.runtimeType &&
          code == other.code &&
          body == other.body;

  @override
  int get hashCode => code.hashCode ^ body.hashCode;
}
