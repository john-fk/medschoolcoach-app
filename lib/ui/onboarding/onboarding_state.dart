enum OnboardingState {
  Unset,
  ShowForNewUser,
  ShowForExistingUser,
  Completed
}

extension ParseToString on OnboardingState {
  String key() {
    return this.toString().split('.').last;
  }
}