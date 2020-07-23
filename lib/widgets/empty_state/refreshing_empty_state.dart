import 'package:Medschoolcoach/repository/repository_result.dart';
import 'package:Medschoolcoach/widgets/empty_state/empty_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RefreshingEmptyState extends StatelessWidget {
  final RepositoryResult repositoryResult;
  final VoidCallback refreshFunction;

  const RefreshingEmptyState({
    Key key,
    this.repositoryResult,
    @required this.refreshFunction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: refreshFunction,
      child: Stack(
        children: <Widget>[
          EmptyState(
            repositoryResult: repositoryResult,
          ),
          ListView()
        ],
      ),
    );
  }
}
