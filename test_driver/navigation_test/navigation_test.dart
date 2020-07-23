import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

import 'navigation_keys.dart';

void navigationTest(FlutterDriver driver, String email) {
  group("Navigation test group", () {
    test("Go to more screen and cancel form home", () async {
      await driver.waitFor(find.text("Your Progress"));
      await driver.tap(more);
      await driver.waitFor(videos);
      await driver.tap(more);
      await driver.waitFor(find.text("Your Progress"));
    });

    test("Search test", () async {
      await driver.tap(search);
      await driver.waitFor(searchForm);
      await driver.tap(searchForm);
      await driver.enterText("Gluco");
      await driver.tap(clearSearch);
      await driver.waitFor(find.text("Search for a lesson"));
      await driver.tap(searchButton);
      await driver.waitFor(find.text("The term must be at least 2 characters"));
      await driver.tap(searchForm);
      await driver.enterText("decay");
      await driver.tap(searchButton);
      await driver.waitFor(searchResult1);
      await driver.waitFor(searchResult2);
      await driver.tap(searchResult1);
      await driver.waitFor(find.text("Premium Features")); //TODO: remove
      // await driver.scrollUntilVisible(lessonScroll, podcast); TODO: uncomment
      // await driver.waitFor(premiumFeatures); TODO: when premiums off
      // await driver.waitFor(tutoring);
      // await driver.waitFor(podcast);
      await driver.tap(appBarBackButton);
    });

    test("Go to more screen", () async {
      await driver.waitFor(more);
      await driver.tap(more);
    });

    test("Check videos", () async {
      await driver.waitFor(videos);
      await driver.tap(videos);
      await driver.waitFor(find.text("Pick Category"));
      await driver.tap(appBarBackButton);
      await driver.waitFor(videos);
      await driver.tap(videos);
      await driver.waitFor(find.text("Pick Category"));
      await driver.tap(more);
      await driver.waitFor(videos);
    });

    test("Flashcards go into", () async {
      await driver.waitFor(flashCards);
      await driver.tap(flashCards);
      await driver.waitFor(find.text("Review by confidence interval"));
      await driver.waitFor(find.byValueKey("Psychology"));
      await driver.tap(find.byValueKey("Psychology"));
    });

    test("Flashcards how to 1", () async {
      //HOW TO
      await driver.waitFor(tapToContinue);
      await driver.tap(tapToContinue);
    });

    test("Flashcards flip", () async {
      await driver.waitFor(flipButton);
      await driver.tap(flipButton);
    });

    test("Flashcards how to 2", () async {
      //HOW TO
      await driver.waitFor(tapToContinue);
      await driver.tap(tapToContinue);
    });

    test("flashcards finish", () async {
      await driver.waitFor(gotItButton);
      await driver.tap(positiveEmoji);
      await driver.tap(gotItButton);
      await driver.tap(flipButton);
      await driver.tap(appBarBackButton);
      await driver.waitFor(bioSubject);
      await driver.tap(appBarBackButton);
    });

    test("Check feedback", () async {
      await driver.waitFor(feedback);
      await driver.tap(feedback);
      await driver.waitFor(feedbackField);
      await driver.tap(feedbackField);
      await driver.enterText("This is a test feedback message");
      await driver.tap(appBarBackButton);
    });

    test("Check bookmarks", () async {
      await driver.waitFor(bookmarks);
      await driver.tap(bookmarks);
      await driver.waitFor(organicChemistry);
      await driver.tap(organicChemistry);
      await driver.waitFor(bookmarkLesson);
      await driver.tap(bookmarkLesson);
      await driver.waitFor(find.text("Premium Features")); //TODO: remove
      //await driver.waitFor(premiumFeatures); TODO: uncomment
      await driver.tap(appBarBackButton);
      await driver.waitFor(organicChemistry);
      await driver.tap(appBarBackButton);
    });

    test("Questions check", () async {
      await driver.waitFor(questionBank);
      await driver.tap(questionBank);
      await driver.waitFor(find.text("Review by status"));
      await driver.waitFor(find.text("New questions"));
      await driver.waitFor(find.text("Flagged questions"));
      await driver.tap(find.text("Flagged questions"));
      await driver.waitFor(find.text("Questions"));
      await driver.tap(find.byValueKey("ans1"));
      await driver.waitFor(find.text("View Explanation"));
      await driver.waitFor(find.text("Summarize"));
      await driver.tap(find.text("Summarize"));
      await driver.waitFor(find.text("Question 1"));
      await driver.tap(appBarBackButton);
      await driver.waitFor(find.text("Review by status"));
      await driver.tap(appBarBackButton);
    });

    test("Check refer friend", () async {
      await driver.scroll(find.byValueKey("more_scroll"), 0, -1000,
          const Duration(milliseconds: 200));
      await driver.waitFor(find.text("Invite a Friend"));
      await driver.tap(find.text("Invite a Friend"));
      await driver.waitFor(find.byValueKey("name"));
      await driver.tap(find.byValueKey("name"));
      await driver.enterText("Test");
      await driver.scroll(find.byValueKey("refer_scroll"), 0, -300,
          const Duration(milliseconds: 200));
      await driver.tap(find.byValueKey("surname"));
      await driver.enterText("Test");
      await driver.tap(find.byValueKey("email"));
      await driver.enterText(email);
      await driver.tap(find.text("Invite a Friend"));
      await driver.waitFor(find.text("Continue"));
      await driver.tap(find.text("Continue"));
    });

    test("check profile screen", () async {
      await driver.waitFor(find.text("My Account"));
      await driver.tap(find.text("My Account"));
      await driver.waitFor(find.text("Invite a Friend"));
      await driver.waitFor(find.text("test@test.com"));
      await driver.tap(find.text("My Stats"));
      await driver.scroll(
        find.byValueKey("stats_scroll"),
        0,
        -1000,
        const Duration(milliseconds: 200),
      );
      await driver.waitFor(find.text("First question"));
      await driver.waitFor(find.text("First flashcard"));
    });
  });
}
