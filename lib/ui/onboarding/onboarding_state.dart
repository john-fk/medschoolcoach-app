enum OnboardingState {
  showForNewUser,
  showForExistingUser,
  Completed
}

extension ParseToString on OnboardingState {
  String key() {
    return this.toString().split('.').last;
  }
}