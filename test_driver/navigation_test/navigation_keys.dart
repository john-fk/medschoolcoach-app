import 'package:flutter_driver/flutter_driver.dart';

final home = find.byValueKey("home");
final tutoringNavigation = find.byValueKey("tutoring");
final requestInfo = find.byValueKey("request info");
final search = find.byValueKey("search");
final more = find.byValueKey("more");
final homeScroll = find.byValueKey("home_scroll");
final appBarBackButton = find.byValueKey("app_bar_back_button");

//search screen
final searchForm = find.byValueKey("search form");
final searchButton = find.byValueKey("search term");
final clearSearch = find.byValueKey("search clear");
final searchResult1 = find.byValueKey("Radioactive Decay");
final searchResult2 = find.byValueKey("Exponential Decay");
final premiumFeatures = find.byValueKey("Premium Features");
final tutoring = find.byValueKey("Get tutoring on this topic");
final podcast = find.byValueKey("Podcast");
final lessonScroll = find.byValueKey("lesson scroll");

//more screen
final videos = find.byValueKey("Videos");
final flashCards = find.byValueKey("Flashcards");
final tutoringMore = find.byValueKey("Tutoring");
final questionBank = find.byValueKey("Question Bank");

// flash cards
final bioSubject = find.byValueKey("Biochemistry");
final tapToContinue = find.byValueKey("tapToContinue");
final flipButton = find.byValueKey("Flip");
final gotItButton = find.byValueKey("Next");
final positiveEmoji = find.byValueKey("EmojiType.Positive");

//support
final feedback = find.byValueKey("Feedback");
final feedbackField = find.byValueKey("feedbackField");
final feedbackSubmit = find.byValueKey("feedbackSubmit");

//bookmarks
final bookmarks = find.byValueKey("Bookmarked Videos");
final organicChemistry = find.byValueKey("Organic Chemistry");
final bookmarkLesson = find.byValueKey("Absolute Configuration");
