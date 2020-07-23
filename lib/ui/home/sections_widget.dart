import 'package:Medschoolcoach/repository/repository_result.dart';
import 'package:Medschoolcoach/utils/api/models/section.dart';
import 'package:Medschoolcoach/utils/sizes.dart';
import 'package:Medschoolcoach/utils/super_state/super_state.dart';
import 'package:Medschoolcoach/widgets/empty_state/empty_state.dart';
import 'package:Medschoolcoach/widgets/list_cells/categroy_cell.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'home_section.dart';

class SectionsWidget extends StatelessWidget {
  final RepositoryResult sectionsResult;
  final String sectionTitle;

  const SectionsWidget({
    Key key,
    this.sectionsResult,
    this.sectionTitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final sectionsList = SuperStateful.of(context).sectionsList;
    if (sectionsResult is RepositoryErrorResult || sectionsList.isEmpty)
      return EmptyState(
        repositoryResult: sectionsResult,
      );
    return _buildGridView(context, sectionsList);
  }

  Widget _buildGridView(BuildContext context, List<Section> sectionsList) {
    sectionsList.sort(
      (a, b) => a.order.compareTo(b.order),
    );
    final spacing = whenDevice(
      context,
      large: 10.0,
      tablet: 30.0,
    );

    return HomeSection(
      sectionTitle: sectionTitle,
      sectionWidget: Column(
        children: <Widget>[
          Column(
            children: <Widget>[
              Container(
                height: _calculateHeight(context),
                child: CategoryCell(
                  section: sectionsList.first,
                ),
              )
            ],
          ),
          SizedBox(
            height: spacing,
          ),
          GridView.count(
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: spacing,
            crossAxisSpacing: spacing,
            children: sectionsList
                .skip(1)
                .map(
                  (section) => CategoryCell(section: section),
                )
                .toList(),
          ),
        ],
      ),
    );
  }

  double _calculateHeight(BuildContext context) {
    return MediaQuery.of(context).size.width / 2 -
        34; // 34 is combined margin values;
  }
}
