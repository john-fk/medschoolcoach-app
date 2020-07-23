import 'package:Medschoolcoach/repository/rate_limiter/rate_limiter.dart';
import 'package:Medschoolcoach/repository/repository.dart';
import 'package:Medschoolcoach/repository/repository_result.dart';
import 'package:Medschoolcoach/repository/repository_utils.dart';
import 'package:Medschoolcoach/utils/api/api_services.dart';
import 'package:Medschoolcoach/utils/api/errors.dart';
import 'package:Medschoolcoach/utils/api/models/section.dart';
import 'package:Medschoolcoach/utils/api/models/sections_list.dart';
import 'package:Medschoolcoach/utils/api/network_response.dart';

import 'cache/cache.dart';
import 'cache/map_chache.dart';

const _sectionsListRateLimiterKey = "sectionsListKey";
const _flashcardsSectionsRateLimiterKey = "flashcardsSectionsListKey";
const _questionsSectionsRateLimiterKey = "questionsSectionsListKey";

class SectionRepository implements Repository {
  final ApiServices _apiServices;

  SectionRepository(
    this._apiServices,
  );

  final Cache<String, Section> _sectionsListCache = MapCache();
  final Cache<String, Section> _flashcardsSectionsListCache = MapCache();
  final Cache<String, Section> _questionsSectionsListCache = MapCache();

  final RateLimiter _sectionsListRateLimiter = RateLimiter();
  final RateLimiter _flashcardsSectionsRateLimiter = RateLimiter();
  final RateLimiter _questionsSubjectsRateLimiter = RateLimiter();

  Future<RepositoryResult<List<Section>>> fetchSectionList({
    bool forceApiRequest = false,
  }) async {
    final shouldFetch = _sectionsListRateLimiter.shouldFetch(
      _sectionsListRateLimiterKey,
    );

    if (shouldFetch || forceApiRequest) {
      final response = await _apiServices.getSectionsList();
      if (response is SuccessResponse<SectionsList>) {
        for (final section in response.body.sections) {
          _sectionsListCache.set(
            section.id,
            section,
          );
        }
        return RepositorySuccessResult(response.body.sections);
      } else if (response is ErrorResponse<SectionsList>) {
        _sectionsListRateLimiter.reset(
          _sectionsListRateLimiterKey,
        );
        return RepositoryUtils.handleRepositoryError(
          response,
        );
      }
    } else {
      return RepositorySuccessResult(
        await _sectionsListCache.getAll(),
      );
    }
    return RepositoryErrorResult(
      ApiError.unknown,
    );
  }

  Future<RepositoryResult<List<Section>>> fetchFlashcardsSectionsList({
    bool forceApiRequest = false,
  }) async {
    final shouldFetch = _flashcardsSectionsRateLimiter.shouldFetch(
      _flashcardsSectionsRateLimiterKey,
    );

    if (shouldFetch || forceApiRequest) {
      final response = await _apiServices.getFlashcardsSections();
      if (response is SuccessResponse<SectionsList>) {
        for (final section in response.body.sections) {
          _flashcardsSectionsListCache.set(
            section.id,
            section,
          );
        }
        return RepositorySuccessResult(response.body.sections);
      } else if (response is ErrorResponse<SectionsList>) {
        _flashcardsSectionsRateLimiter.reset(
          _flashcardsSectionsRateLimiterKey,
        );
        return RepositoryUtils.handleRepositoryError(
          response,
        );
      }
    } else {
      return RepositorySuccessResult(
        await _flashcardsSectionsListCache.getAll(),
      );
    }
    return RepositoryErrorResult(
      ApiError.unknown,
    );
  }

  Future<RepositoryResult<List<Section>>> fetchQuestionsSectionsList({
    bool forceApiRequest = false,
  }) async {
    final shouldFetch = _questionsSubjectsRateLimiter.shouldFetch(
      _questionsSectionsRateLimiterKey,
    );

    if (shouldFetch || forceApiRequest) {
      final response = await _apiServices.getQuestionsSections();
      if (response is SuccessResponse<SectionsList>) {
        for (final section in response.body.sections) {
          _questionsSectionsListCache.set(
            section.id,
            section,
          );
        }
        return RepositorySuccessResult(response.body.sections);
      } else if (response is ErrorResponse<SectionsList>) {
        _questionsSubjectsRateLimiter.reset(
          _questionsSectionsRateLimiterKey,
        );
        return RepositoryUtils.handleRepositoryError(
          response,
        );
      }
    } else {
      return RepositorySuccessResult(
        await _questionsSectionsListCache.getAll(),
      );
    }
    return RepositoryErrorResult(
      ApiError.unknown,
    );
  }

  Future<RepositoryResult<Section>> fetchSection(String sectionId,
      {bool forceApiRequest = false}) async {
    final shouldFetch = _sectionsListRateLimiter.shouldFetch(sectionId);

    if (shouldFetch || forceApiRequest) {
      final response = await _apiServices.getSection(
        sectionId: sectionId,
      );
      if (response is SuccessResponse<Section>) {
        _sectionsListCache.set(
          response.body.id,
          response.body,
        );
        return RepositorySuccessResult(
          response.body,
        );
      } else if (response is ErrorResponse<Section>) {
        _sectionsListRateLimiter.reset(
          _sectionsListRateLimiterKey,
        );
        return RepositoryUtils.handleRepositoryError(
          response,
        );
      }
    } else {
      return RepositorySuccessResult(
        await _sectionsListCache.get(sectionId),
      );
    }
    return RepositoryErrorResult(
      ApiError.unknown,
    );
  }

  @override
  void clearCache() {
    _sectionsListRateLimiter.resetAll();
    _flashcardsSectionsRateLimiter.resetAll();
    _questionsSubjectsRateLimiter.resetAll();
    _sectionsListCache.invalidateAll();
    _flashcardsSectionsListCache.invalidateAll();
    _questionsSectionsListCache.invalidateAll();
  }
}
