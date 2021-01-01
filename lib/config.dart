abstract class Config {
  static final prodApiUrl = "https://api.medschoolcoach.com";
  static final devApiUrl = "https://api.medschoolcoach.com";
  static const appTitle = "MedSchoolCoach";
  static const fontFamily = "Rubik";
  static const devBaseAuth0Url = 'https://auth.medschoolcoach.com';
  static const prodBaseAuth0Url = 'https://auth.medschoolcoach.com';
  static const prodAuth0ClientId = 'NJjVmGlaa3WGc1Rr1CujFctPsXAuVFQO';
  static const testAuth0ClientId = 'LvuKFKn50tb2ddO6C3LIUo6YuA2gpLaF';
  static String auth0ClientId = prodAuth0ClientId;
  static const termsOfUseUrl =
      'https://www.medschoolcoach.com/terms-of-service/';
  static const privacyPolicyUrl =
      'https://www.medschoolcoach.com/privacy-policy/';
  static const tutoringUrl = 'https://www.medschoolcoach.com/mcat-tutoring/';
  static const defaultDateFormat = 'dd MMM yyyy';
  static const defaultLocale = 'en';
  static const requiredPasswordLength = 8;
  static const supportEmail = "techhelp@medschoolcoach.com";
  static const tokenValidityTime = 36000;
  static const oneSignalAppId = "73aeb779-a915-4bd9-9e1c-1eedc6f73a5e";

  //Podcast urls
  static const applePodcastUrl =
      "https://podcasts.apple.com/us/podcast/prospectivedoctors-mcat-basics/id1448973714";
  static const googlePodcastUrl =
      "https://play.google.com/music/listen?u=0#/ps/Itwzpxwqbnvje6cokuogitsfwda";
  static const spotifyPodcastUrl =
      "https://open.spotify.com/show/01k1ICEBLfnu7EFZp5OqoR";
  static const sticherPodcastUrl =
      "https://www.stitcher.com/podcast/sam-smith/sams-mcat-basics";

  //Youtube urls
  static const mnemonicsUrl =
      "https://www.youtube.com/watch?v=UXdlKGFTIDs&list=PLlwXx7KyNSmohIdKvbkXsraX1ukx4uSWY&index=24";
  static const flashcardsUrl =
      "https://www.youtube.com/watch?list=PLlwXx7KyNSmrfGQtPkAg4A4DNpzfMpS1Z&v=H1Ktg1NGcHk&feature=emb_title";
  static const secretsUrl =
      "https://www.youtube.com/watch?list=PLlwXx7KyNSmr5itfOXm1DcQyheVXf_NhH&v=-BmWUhWCDow&feature=emb_title";

  //Social medias
  static const facebook = "https://www.facebook.com/MedSchoolCoach/";
  static const instagram = "https://www.instagram.com/medschoolcoach/?hl=en";
  static const swagStore = "https://merch.medschoolcoach.com/";

  //Mixpanel
  static const devMixPanelToken = "37549a27ddcbbd8e91dbfa65c8cc35c4";
  static const prodMixPanelToken = "858e8b0fcadb93fa00b51990d9fb2cd3";

  static bool showSwitch = false;
  static bool switchValue = false;
}
