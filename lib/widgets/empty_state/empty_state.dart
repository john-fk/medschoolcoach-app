import 'package:Medschoolcoach/repository/repository_result.dart';
import 'package:Medschoolcoach/utils/api/errors.dart';
import 'package:Medschoolcoach/utils/responsive_fonts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

class EmptyState extends StatelessWidget {
  final RepositoryResult repositoryResult;

  EmptyState({
    this.repositoryResult,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        _getEmptyStateText(context, repositoryResult),
        style: normalResponsiveFont(context, fontColor: FontColor.Error),
        textAlign: TextAlign.center,
      ),
    );
  }

  String _getEmptyStateText(
    BuildContext context,
    RepositoryResult repositoryResult,
  ) {
    if (repositoryResult == null) {
      return FlutterI18n.translate(context, "errors.global_api_error");
    }
    if (repositoryResult is RepositorySuccessResult &&
        repositoryResult.data.isEmpty) {
      return FlutterI18n.translate(context, "errors.no_data");
    }
    if ((repositoryResult as RepositoryErrorResult).error ==
        ApiError.networkError) {
      return FlutterI18n.translate(context, "errors.no_internet");
    }
    return FlutterI18n.translate(context, "errors.global_api_error");
  }
}
