import 'package:universal_io/io.dart';

import 'package:Medschoolcoach/repository/repository_result.dart';
import 'package:Medschoolcoach/utils/api/errors.dart';
import 'package:Medschoolcoach/utils/api/network_response.dart';

abstract class RepositoryUtils {
  static RepositoryErrorResult<T> handleRepositoryError<T>(
    ErrorResponse response,
  ) {
    final error = response.error;
    if (error is SocketException) {
      return RepositoryErrorResult(
        ApiError.networkError,
      );
    }
    if (error is SessionExpiredException) {
      return RepositoryErrorResult(
        ApiError.sessionExpired,
      );
    }
    return RepositoryErrorResult(
      ApiError.unknown,
    );
  }
}
