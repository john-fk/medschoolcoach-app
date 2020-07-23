import 'package:Medschoolcoach/utils/api/models/subject.dart';
import 'package:Medschoolcoach/utils/api/models/topic.dart';
import 'package:Medschoolcoach/utils/responsive_fonts.dart';
import 'package:Medschoolcoach/utils/sizes.dart';
import 'package:Medschoolcoach/widgets/custom_expansion_tile/custom_expansion_tile.dart';
import 'package:Medschoolcoach/widgets/list_cells/topic_list_cell.dart';
import 'package:flutter/material.dart';

typedef GoToTopic(BuildContext context, Topic topic);

class SubjectTitleWidget extends StatelessWidget {
  final Subject subject;
  final GoToTopic goToTopic;
  final bool initiallyExpanded;

  const SubjectTitleWidget({
    @required this.subject,
    @required this.goToTopic,
    this.initiallyExpanded = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: CustomExpansionTile(
        key: Key(subject.name),
        initiallyExpanded: initiallyExpanded,
        children: _getItems(context),
        title: Padding(
          padding: EdgeInsets.symmetric(
            vertical: whenDevice(context, large: 0, tablet: 20),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                subject.name,
                style: biggerResponsiveFont(
                  context,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _getItems(BuildContext context) {
    final items = List<Widget>();
    subject.topics.forEach(
      (topic) => items.add(
        TopicListCell(
          onTap: () => goToTopic(context, topic),
          progress: topic.percentage,
          title: topic.name,
        ),
      ),
    );
    return items;
  }
}
