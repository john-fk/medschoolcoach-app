import 'dart:developer';

import 'package:Medschoolcoach/providers/analytics_constants.dart';
import 'package:Medschoolcoach/providers/analytics_provider.dart';
import 'package:Medschoolcoach/repository/flashcard_repository.dart';
import 'package:Medschoolcoach/utils/api/models/setting.dart';
import 'package:Medschoolcoach/utils/api/models/subject.dart';
import 'package:Medschoolcoach/utils/navigation/routes.dart';
import 'package:Medschoolcoach/utils/sizes.dart';
import 'package:Medschoolcoach/utils/super_state/super_state.dart';
import 'package:Medschoolcoach/widgets/list_cells/subject_cell.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

class SubjectAndSetting {
  final Subject subject;
  final Setting setting;

  SubjectAndSetting(this.subject,
      this.setting,);
}

class FlashCardsSubjects extends StatelessWidget {
  final AnalyticsProvider _analyticsProvider;

  const FlashCardsSubjects(this._analyticsProvider);

  @override
  Widget build(BuildContext context) {
    final subjectsWithSettings = List<SubjectAndSetting>();
    final sections = SuperStateful
        .of(context)
        .flashcardsSections;

    sections.where((section) => section.amountOfFlashcards != 0).forEach(
          (section) =>
          section.subjects
              .where((subject) => subject.amountOfFlashcards != 0)
              .forEach(
                (subject)
                {
                  subjectsWithSettings.add(
                    SubjectAndSetting(
                      subject,
                      section.setting,
                    )
                  );
                },
          ),
    );

    final spacing = whenDevice(
      context,
      large: 10.0,
      tablet: 30.0,
    );

    return GridView.count(
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: spacing,
      crossAxisSpacing: spacing,
      children: subjectsWithSettings
          .map(
            (subjectWithSetting) =>
            SubjectCell(
              subjectName: subjectWithSetting.subject.name,
              setting: subjectWithSetting.setting,
              itemsWithNumber: FlutterI18n.translate(
                context,
                "flashcards_bank.flashcards_count",
                {
                  "number":
                  subjectWithSetting.subject.amountOfFlashcards.toString(),
                },
              ),
              onTap: () {
                {
                  Navigator.pushNamed(
                    context,
                    Routes.flashCard,
                    arguments: FlashcardsStackArguments(
                        subjectId: subjectWithSetting.subject.id,
                        subjectName: subjectWithSetting.subject.name,
                        source: AnalyticsConstants.screenFlashcardsBank),
                  );
                  _analyticsProvider.logEvent(
                      AnalyticsConstants.tapFlashcardsSubject,
                      params: {
                        "subject_id": subjectWithSetting.subject.id,
                        "subject_name": subjectWithSetting.subject.name
                      });
                }
              },
            ),
      )
          .toList(),
    );
  }
}
