import 'package:flutter_driver/flutter_driver.dart';

final home = find.byValueKey("home");
final introductionCategory = find.byValueKey("Introduction");
final bioBiochemCategory = find.byValueKey("Bio/Biochem");
final chemPhysCategory = find.byValueKey("Chem/Phys");
final carsCategory = find.byValueKey("CARS");
final psychSocialCategory = find.byValueKey("Psych/Soc");
final homeScroll = find.byValueKey("home_scroll");
final sectionScroll = find.byValueKey("section_scroll");
final appBarBackButton = find.byValueKey("app_bar_back_button");
//psych sec section
final psychologySubject = find.byValueKey("Psychology");
final sociologySubject = find.byValueKey("Sociology");
final memoryTopic = find.byValueKey("Memory");
final discriminationTopic = find.byValueKey("Discrimination");
//cars section
final criticalThinkingTopic = find.byValueKey("Critical Thinking");
//chem phys section
final generalChemistrySubject = find.byValueKey("General Chemistry");
final organicChemistrySubject = find.byValueKey("Organic Chemistry");
final physicsSubject = find.byValueKey("Physics");
final atomicStructureTopic = find.byValueKey("Atomic Structure");
// bio chem section
final biochemistrySubject = find.byValueKey("Biochemistry");
final biologySubject = find.byValueKey("Biology");
final geneticCodeTopic = find.byValueKey("Genetic Code");
// intro section
final introductionTopic = find.byValueKey("The MCAT CARS Section");

//lessons from topic
final radioactiveDeacyLesson = find.byValueKey("Radioactive Decay");
final nuclearNotationLesson = find.byValueKey("Nuclear Notation");

//lesson screen
final nextLessonButton = find.byValueKey("next lesson");
final previousLessonButton = find.byValueKey("previous lesson");
final premiumFeatures = find.byValueKey("Premium Features");
final tutoring = find.byValueKey("Get tutoring on this topic");
final podcast = find.byValueKey("Podcast");
final lessonScroll = find.byValueKey("lesson scroll");
final openVideoPlayer = find.byValueKey("open video player");
//video names in topic
final video1 = find.byValueKey("Nuclear Notation");
final video2 = find.byValueKey("Nuclear Forces and Nuclear Binding Energy");
final video3 = find.byValueKey("Radioactive Decay");
final video4 = find.byValueKey("Exponential Decay");

final minimizeVideo = find.byValueKey("minimize video");
final continueWatching = find.byValueKey("continue watching");
final requestInfoButton = find.byValueKey("request info");
final seekVideoBackwards = find.byValueKey("seek backwards");
