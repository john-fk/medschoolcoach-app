import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

import 'lesson_keys.dart';

void lessonsTest(FlutterDriver driver) {
  group("Lessons test group", () {
    test("Check continue watching", () async {
      await driver.waitFor(continueWatching);
    });

    test("Check psych/soc section", () async {
      await driver.waitFor(homeScroll);
      await driver.scroll(
          homeScroll, 0, -2000, const Duration(milliseconds: 500));
      await driver.tap(psychSocialCategory);
      await driver.waitFor(psychologySubject);
      await driver.waitFor(sociologySubject);
      await driver.tap(psychologySubject);
      await driver.waitFor(memoryTopic);
      await driver.tap(appBarBackButton);
    });

    test("Check cars section", () async {
      await driver.tap(carsCategory);
      await driver.waitFor(criticalThinkingTopic);
      await driver.tap(appBarBackButton);
    });

    test("Check chem pchys section", () async {
      await driver.tap(chemPhysCategory);
      await driver.waitFor(generalChemistrySubject);
      await driver.waitFor(organicChemistrySubject);
      await driver.waitFor(physicsSubject);
      await driver.tap(generalChemistrySubject);
      await driver.waitFor(atomicStructureTopic);
      await driver.tap(appBarBackButton);
    });

    test("Check bio biochem section", () async {
      await driver.tap(bioBiochemCategory);
      await driver.waitFor(biochemistrySubject);
      await driver.waitFor(biologySubject);
      await driver.tap(biologySubject);
      await driver.waitFor(geneticCodeTopic);
      await driver.tap(appBarBackButton);
    });

    test("Check intro section", () async {
      await driver.scrollUntilVisible(homeScroll, introductionCategory);
      await driver.tap(introductionCategory);
      await driver.waitFor(introductionTopic);
      await driver.tap(appBarBackButton);
    });

    test("Go to topic screen", () async {
      await driver.tap(chemPhysCategory);
      await driver.waitFor(generalChemistrySubject);
      await driver.waitFor(organicChemistrySubject);
      await driver.waitFor(physicsSubject);
      await driver.tap(generalChemistrySubject);
      await driver.waitFor(atomicStructureTopic);
      await driver.tap(atomicStructureTopic);
      await driver.waitFor(radioactiveDeacyLesson);
      await driver.waitFor(nuclearNotationLesson);
    });

    test("Check lesson screen", () async {
      await driver.tap(radioactiveDeacyLesson);
      await driver.waitFor(nextLessonButton);
      await driver.waitFor(previousLessonButton);
      await driver.scroll(
        lessonScroll,
        0,
        -500,
        const Duration(milliseconds: 200),
      );
      await driver.waitFor(find.text("Premium Features"));
      await driver.waitFor(find.text("Flashcards"));
      await driver.waitFor(tutoring);
      await driver.waitFor(podcast);
    });

    test("Go to last lesson and then to first one", () async {
      await driver.tap(nextLessonButton);
      await driver.waitFor(video4);
      await driver.tap(previousLessonButton);
      await driver.waitFor(video3);
      await driver.tap(previousLessonButton);
      await driver.waitFor(video2);
      await driver.tap(previousLessonButton);
      await driver.waitFor(video1);
    });

    test("back home", () async {
      await driver.waitFor(nextLessonButton);
      await driver.tap(appBarBackButton);
      await driver.waitFor(nuclearNotationLesson);
      await driver.tap(appBarBackButton);
      await driver.waitFor(atomicStructureTopic);
      await driver.tap(appBarBackButton);
    });

    test("Check continue watching", () async {
      await driver.scroll(
          homeScroll, 0, 2000, const Duration(milliseconds: 200));
      await driver.tap(continueWatching);
      await driver.waitFor(find.text("Premium Features"));
      // await driver.waitFor(premiumFeatures);
      await driver.tap(appBarBackButton);
      await driver.waitFor(continueWatching);
    });

    test("Check schedule", () async {
      final scroll = find.byValueKey("schedule_scroll");

      await driver.scroll(
          homeScroll, 0, -300, const Duration(milliseconds: 200));
      await driver.waitFor(find.text("Up Next"));
      await driver.waitFor(find.text("Lesson 1"));
      await driver.waitFor(find.text("Lesson 2"));
      await driver.waitFor(find.text("Lesson 3"));
      await driver.waitFor(find.text("See full schedule"));
      await driver.tap(find.text("See full schedule"));
      await driver.waitFor(find.text("Schedule"));
      await driver.tap(find.byValueKey("day2"));
      await driver.waitFor(scroll);
      await driver.waitFor(find.text("Lesson 1"));
      await driver.waitFor(find.text("Lesson 2"));
      await driver.waitFor(find.text("Lesson 3"));
      await driver.scroll(scroll, 0, -1000, const Duration(milliseconds: 200));
      await driver.waitFor(find.text("Pick your schedule length"));
      await driver.tap(find.text("Pick your schedule length"));
      await driver.waitFor(find.text("60 days"));
      await driver.tap(find.text("60 days"));
      await driver.waitFor(find.text("Continue"));
      await driver.tap(find.text("Continue"));
      await driver.waitFor(find.text("Lesson 1"));
      await driver.scroll(scroll, 0, -1000, const Duration(milliseconds: 200));
      await driver.waitFor(find.text("Pick your schedule length"));
      await driver.tap(find.text("Pick your schedule length"));
      await driver.waitFor(find.text("30 days"));
      await driver.tap(find.text("30 days"));
      await driver.waitFor(find.text("Continue"));
      await driver.tap(find.text("Continue"));
      await driver.waitFor(find.text("Lesson 1"));
    });

    test("Check global progress", () async {
      final scrollValue = -600.0;

      await driver.waitFor(home);
      await driver.tap(home);
      await driver.scroll(
          homeScroll, 0, scrollValue, const Duration(milliseconds: 200));
      await driver.waitFor(find.text("Your Progress"));

      //course progress
      await driver.waitFor(find.text("Course Progress"));
      await driver.tap(find.byValueKey("Course Progress"));
      await driver.waitFor(find.text("Schedule"));
      await driver.waitFor(home);
      await driver.tap(home);
      await driver.scroll(
          homeScroll, 0, scrollValue, const Duration(milliseconds: 200));

      //total lessons
      await driver.waitFor(find.byValueKey("Total Lessons Watched"));
      await driver.tap(find.byValueKey("Total Lessons Watched"));
      await driver.waitFor(find.text("Videos"));
      await driver.tap(appBarBackButton);

      //questions
      await driver.waitFor(find.byValueKey("Questions Correct Percentage"));
      await driver.tap(find.byValueKey("Questions Correct Percentage"));
      await driver.waitFor(find.text("Question Bank"));
      await driver.tap(appBarBackButton);

      //flashcards
      await driver.waitFor(find.byValueKey("Total Flashcards Reviewed"));
      await driver.tap(find.byValueKey("Total Flashcards Reviewed"));
      await driver.waitFor(find.text("Flashcards"));
      await driver.tap(appBarBackButton);
    });
  });
}
