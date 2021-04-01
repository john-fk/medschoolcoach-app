import 'package:Medschoolcoach/ui/onboarding/onboarding_state.dart';
import 'package:Medschoolcoach/utils/navigation/routes.dart';
import 'package:Medschoolcoach/utils/user_manager.dart';
import 'package:injector/injector.dart';

class AppRouter {
  static Future<String> getInitialRoute() async {
    final userManager = Injector.appInstance.getDependency<UserManager>();
    final isLoggedIn = await userManager.isUserLoggedIn();
    final bool needsOnboarding = await userManager.shouldShowOnboarding();

    if (isLoggedIn) {
      if (needsOnboarding) {
        final onboardingState = await userManager.getOnboardingState();
        if (onboardingState == OnboardingState.showForNewUser) {
          return Routes.newUserOnboardingScreen;
        } else if (onboardingState == OnboardingState.showForExistingUser) {
          return Routes.oldUserOnboarding;
        } else {
          return Routes.home;
        }
      }
      return Routes.home;
    } else
      return Routes.welcome;
  }
}
