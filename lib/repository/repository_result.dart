import 'package:Medschoolcoach/utils/api/errors.dart';
import 'package:Medschoolcoach/utils/api/models/auth0_error_sign_up_response.dart';

abstract class RepositoryResult<T> {}

class RepositorySuccessResult<T> implements RepositoryResult<T> {
  final T data;

  RepositorySuccessResult(
    this.data,
  );
}

class RepositoryErrorResult<T> implements RepositoryResult<T> {
  final ApiError error;

  RepositoryErrorResult(
    this.error,
  );
}

class RepositoryErrorResultAuth0<T> implements RepositoryResult<T> {
  final Auth0ErrorSignUpResponse errorData;

  RepositoryErrorResultAuth0(this.errorData);
}
