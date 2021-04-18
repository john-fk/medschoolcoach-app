import 'package:Medschoolcoach/ui/onboarding/onboarding_state.dart';
import 'package:Medschoolcoach/utils/api/api_services.dart';
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
        var onboardingState = await userManager.getOnboardingState();
        if (onboardingState == OnboardingState.Unset) {
          var completedOnboarding = await hasOnboarded();
          onboardingState = completedOnboarding ?
          OnboardingState.Completed : OnboardingState.ShowForExistingUser;
          userManager.markOnboardingState(onboardingState);
        }

        if (onboardingState == OnboardingState.ShowForNewUser) {
          return Routes.newUserOnboardingScreen;
        } else if (onboardingState == OnboardingState.ShowForExistingUser) {
          return Routes.oldUserOnboarding;
        } else {
          return Routes.home;
        }
      }
      return Routes.home;
    } else
      return Routes.welcome;
  }

  static Future<bool> hasOnboarded() async {
    ApiServices apiServices = Injector.appInstance.getDependency<ApiServices>();
    var data = await apiServices.getAccountData();
    final hasOnboarded = data?.onboarded ?? false;
    return !hasOnboarded;
    return hasOnboarded;
  }
}
