import 'package:Medschoolcoach/config.dart';
import 'package:Medschoolcoach/providers/analytics_constants.dart';
import 'package:Medschoolcoach/providers/analytics_provider.dart';
import 'package:Medschoolcoach/utils/external_navigation_utils.dart';
import 'package:Medschoolcoach/utils/sizes.dart';
import 'package:Medschoolcoach/utils/style_provider/style.dart';
import 'package:Medschoolcoach/widgets/inkwell_image/inkwell_image.dart';
import 'package:flutter/material.dart';
import 'package:injector/injector.dart';

void openPodcastModal(BuildContext context, String source) {
  final AnalyticsProvider _analyticsProvider =
      Injector.appInstance.getDependency<AnalyticsProvider>();

  _analyticsProvider.logEvent(AnalyticsConstants.screenPodcastModal,
      params: {AnalyticsConstants.keySource: source});

  showModalBottomSheet<void>(
    isScrollControlled: true,
    backgroundColor: Style.of(context).colors.background,
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(25.0),
      ),
    ),
    builder: (context) {
      return Padding(
        padding: EdgeInsets.only(
          top: 20,
          bottom: 20 + MediaQuery.of(context).viewPadding.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _buildElement(
              context,
              Style.of(context).pngAsset.podcastApple,
              () => _openPodcast(
                  Config.applePodcastUrl, context, "Apple", _analyticsProvider),
            ),
            _buildElement(
              context,
              Style.of(context).pngAsset.podcastGoogle,
              () => _openPodcast(Config.googlePodcastUrl, context, "Google",
                  _analyticsProvider),
            ),
            _buildElement(
              context,
              Style.of(context).pngAsset.podcastSpotify,
              () => _openPodcast(Config.spotifyPodcastUrl, context, "Spotify",
                  _analyticsProvider),
            ),
            _buildElement(
              context,
              Style.of(context).pngAsset.podcastSticher,
              () => _openPodcast(Config.sticherPodcastUrl, context, "Sticher",
                  _analyticsProvider),
            ),
          ],
        ),
      );
    },
  );
}

void _openPodcast(String url, BuildContext context, String podCast,
    AnalyticsProvider analyticsProvider) {
  analyticsProvider.logEvent(AnalyticsConstants.tapPodcast,
      params: {"podcast": podCast, "url": url});
  Navigator.of(context).pop();
  ExternalNavigationUtils.openWebsite(url);
}

Widget _buildElement(BuildContext context, String asset, VoidCallback onTap) {
  return InkWellObject(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Image.asset(
            asset,
            width: whenDevice(context, large: 200, tablet: 320),
          ),
        )
      ],
    ),
    onTap: onTap,
  );
}
