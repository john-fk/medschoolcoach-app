import 'dart:convert';

class Statistics {
  int courseProgress;
  int lessonsWatched;
  int questionsAnswered;
  int questionsAnsweredCorrect;
  int questionsAnsweredIncorrect;
  int totalFlashcardsMastered;
  int totalLessons;
  int totalQuestions;
  int totalFlashcards;

  Statistics({
    this.courseProgress,
    this.lessonsWatched,
    this.questionsAnswered,
    this.questionsAnsweredCorrect,
    this.questionsAnsweredIncorrect,
    this.totalFlashcardsMastered,
    this.totalLessons,
    this.totalQuestions,
    this.totalFlashcards,
  });

  factory Statistics.fromRawJson(String str) =>
      Statistics.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Statistics.fromJson(Map<String, dynamic> json) =>
      Statistics(
        courseProgress:
        json["course_progress"] == null ? null : json["course_progress"],
        lessonsWatched:
        json["lessons_watched"] == null ? null : json["lessons_watched"],
        questionsAnswered: json["questions_answered"] == null
            ? null
            : json["questions_answered"],
        questionsAnsweredCorrect: json["questions_answered_correct"] == null
            ? null
            : json["questions_answered_correct"],
        questionsAnsweredIncorrect: json["questions_answered_incorrect"] == null
            ? null
            : json["questions_answered_incorrect"],
        totalFlashcardsMastered: json["total_flashcards_mastered"] == null
            ? null
            : json["total_flashcards_mastered"],
        totalLessons: json["total_lessons"] == null
            ? null
            : json["total_lessons"],
        totalQuestions: json["total_questions"] == null
            ? null
            : json["total_questions"],
        totalFlashcards: json["total_flashcards"] == null
            ? null
            : json["total_flashcards"],
      );

  Map<String, dynamic> toJson() =>
      <String, dynamic>{
        "course_progress": courseProgress == null ? null : courseProgress,
        "lessons_watched": lessonsWatched == null ? null : lessonsWatched,
        "questions_answered":
        questionsAnswered == null ? null : questionsAnswered,
        "questions_answered_correct":
        questionsAnsweredCorrect == null ? null : questionsAnsweredCorrect,
        "questions_answered_incorrect": questionsAnsweredIncorrect == null
            ? null
            : questionsAnsweredIncorrect,
        "total_flashcards_mastered":
        totalFlashcardsMastered == null ? null : totalFlashcardsMastered,
        "total_lessons":
        totalLessons == null ? null : totalLessons,
        "total_questions":
        totalQuestions == null ? null : totalQuestions,
        "total_flashcards":
        totalFlashcards == null ? null : totalFlashcards,
      };
}
