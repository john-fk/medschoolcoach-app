import 'package:Medschoolcoach/repository/rate_limiter/rate_limiter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const _rateLimiterKey = "rateLimiterKey";

  group(
    'Rate limiter tests',
    () {
      test(
        'rate limiter false test',
        () {
          final RateLimiter _rateLimiter = RateLimiter(
            timeout: Duration(
              seconds: 3,
            ),
          );
          bool shouldFetch = _rateLimiter.shouldFetch(_rateLimiterKey);
          expect(shouldFetch, true);

          Future.delayed(
            const Duration(seconds: 1),
            () => {
              shouldFetch = _rateLimiter.shouldFetch(_rateLimiterKey),
              expect(shouldFetch, false)
            },
          );
        },
      );

      test(
        'rate limiter true test',
        () {
          final RateLimiter _rateLimiter = RateLimiter(
            timeout: Duration(
              seconds: 3,
            ),
          );
          bool shouldFetch = _rateLimiter.shouldFetch(_rateLimiterKey);

          Future.delayed(
            const Duration(seconds: 3),
            () => {
              shouldFetch = _rateLimiter.shouldFetch(_rateLimiterKey),
              expect(shouldFetch, true)
            },
          );
        },
      );

      test(
        'rate limiter reset test',
        () {
          final RateLimiter _rateLimiter = RateLimiter(
            timeout: Duration(
              minutes: 3,
            ),
          );
          bool shouldFetch = _rateLimiter.shouldFetch(_rateLimiterKey);

          Future.delayed(
            const Duration(seconds: 3),
            () => {
              shouldFetch = _rateLimiter.shouldFetch(_rateLimiterKey),
              expect(shouldFetch, false)
            },
          );

          _rateLimiter.reset(_rateLimiterKey);
          shouldFetch = _rateLimiter.shouldFetch(_rateLimiterKey);
          expect(shouldFetch, true);
        },
      );
    },
  );
}
