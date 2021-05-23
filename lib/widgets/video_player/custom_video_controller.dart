import 'dart:async';

import 'package:Medschoolcoach/providers/analytics_constants.dart';
import 'package:Medschoolcoach/providers/analytics_provider.dart';
import 'package:Medschoolcoach/repository/repository_result.dart';
import 'package:Medschoolcoach/repository/topic_repository.dart';
import 'package:Medschoolcoach/repository/video_repository.dart';
import 'package:Medschoolcoach/ui/lesson/lesson_video_screen.dart';
import 'package:Medschoolcoach/utils/api/models/video.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injector/injector.dart';
import 'package:video_player/video_player.dart';
import 'package:Medschoolcoach/utils/super_state/super_state.dart';
import 'package:Medschoolcoach/utils/storage.dart';
enum VideoQuality { P360, P540, P720 }

enum VideoPlaybackSpeed { x1, x125, x15, x175, x2 }

class CustomVideoController {
  static const int seekTimeValue = 20;
  static const Duration connectionTimeout = Duration(milliseconds: 5000);
  static const String storageQualityKey = "video_quality";
  static const String storageP360 = "P360";
  static const String storageP540 = "P540";
  static const String storageP720 = "P720";

  final VoidCallback setState;
  final Video video;
  final int topicVideosCount;
  final LessonVideoScreenArguments lessonScreenArguments;
  bool timerFlag;
  bool timerFlag1;

  bool commercial = false;
  VideoPlayerController videoPlayerController;
  VideoQuality videoQuality = VideoQuality.P540;
  VideoPlaybackSpeed videoPlaybackSpeed = VideoPlaybackSpeed.x1;
  bool subtitles = false;
  double aspectRatio = 1.78;

  final VideoRepository _videoRepository =
      Injector.appInstance.getDependency<VideoRepository>();
  final TopicRepository _topicRepository =
      Injector.appInstance.getDependency<TopicRepository>();
  final AnalyticsProvider _analyticsProvider =
      Injector.appInstance.getDependency<AnalyticsProvider>();
  final _storage = localStorage();

  bool _connectingToVideoResource = false;
  bool _isBuffering = false;
  bool _isVideoSeeking = false;
  bool _videoFinished = false;
  bool updatedSuperstate = false;
  Duration _previousPosition;
  Duration _position;
  Timer _bufferingTimeoutTimer;
  Timer _savePositionTimer;
  Timer _checkBufferingTimer;
  Timer _connectionTimer;
  BuildContext context;

  CustomVideoController({
    @required this.setState,
    @required this.video,
    @required this.lessonScreenArguments,
    @required this.topicVideosCount,
    @required this.context,
  }) {
    _logAnalyticsEvent(AnalyticsConstants.tapPlayVideo);
    if (video.commercial != null) commercial = true;
    _position = Duration(seconds: commercial ? 0 : video.progress.seconds ?? 0);
    _previousPosition = _position;
    _savePositionTimer = Timer.periodic(
      const Duration(milliseconds: 5000),
      (Timer t) => _savePosition(),
    );
    _checkBufferingTimer =
        Timer.periodic(const Duration(milliseconds: 500), (Timer t) {
      _checkIfVideoFinished();
      _checkBuffering();
    });
    _connectToVideoResourceWithStorageVideoQuality();
  }

  void _connectToVideoResourceWithStorageVideoQuality() async {
    final storageQualityString = await _storage.read(key: storageQualityKey);
    if (storageQualityString != null) {
      switch (storageQualityString) {
        case storageP360:
          videoQuality = VideoQuality.P360;
          break;
        case storageP540:
          videoQuality = VideoQuality.P540;
          break;
        case storageP720:
          videoQuality = VideoQuality.P720;
          break;
      }
    }
    _connectToVideoResource();
  }

  void switchSubtitles() {
    subtitles = !subtitles;
    setState();
    _logAnalyticsEvent(AnalyticsConstants.tapVideoCaptions,
        additionalArgs: {AnalyticsConstants.keyIsOn: subtitles.toString()});
  }

  void switchVideoResource(VideoQuality newQuality) {
    if (videoQuality == newQuality) return;
    videoQuality = newQuality;
    videoPlaybackSpeed = VideoPlaybackSpeed.x1;
    setState();
    _connectToVideoResource();
    _logAnalyticsEvent(AnalyticsConstants.tapVideoChangeQuality,
        additionalArgs: {
          AnalyticsConstants.keyQuality:
              describeEnum(videoQuality).toLowerCase()
        });
  }

  void switchSpeed(VideoPlaybackSpeed newPlaybackSpeed) async {
    if (videoPlaybackSpeed == newPlaybackSpeed) return;
    videoPlaybackSpeed = newPlaybackSpeed;
    setState();
    videoPlayerController.setSpeed(_getVideoSpeed(videoPlaybackSpeed));
    _logAnalyticsEvent(AnalyticsConstants.tapVideoChangeSpeed, additionalArgs: {
      AnalyticsConstants.keySpeed:
          describeEnum(videoPlaybackSpeed).toLowerCase()
    });
  }

  void _connectionTimeout() {
    if (isVideoInitialized()) return;
    if (videoQuality == VideoQuality.P720)
      switchVideoResource(VideoQuality.P540);
    else if (videoQuality == VideoQuality.P540)
      switchVideoResource(VideoQuality.P360);
  }

  void _connectToVideoResource() {
    _connectionTimer = Timer(connectionTimeout, _connectionTimeout);
    final oldController = videoPlayerController;
    switch (videoQuality) {
      case VideoQuality.P360:
        videoPlayerController = VideoPlayerController.network(
          commercial
              ? video.commercial.resolutionLink360
              : video.resolutionLink360,
        );
        _storage.write(key: storageQualityKey, value: storageP360);
        break;
      case VideoQuality.P540:
        videoPlayerController = VideoPlayerController.network(
          commercial
              ? video.commercial.resolutionLink540
              : video.resolutionLink540,
        );
        _storage.write(
          key: storageQualityKey,
          value: storageP540,
        );
        break;
      case VideoQuality.P720:
      default:
        videoPlayerController = VideoPlayerController.network(
          commercial
              ? video.commercial.resolutionLink720
              : video.resolutionLink720,
        );
        _storage.write(key: storageQualityKey, value: storageP720);
        break;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      oldController?.dispose();
    });

    videoPlayerController.addListener(setState);
    reconnect();
  }

  void reconnect({bool paused = false}) async {
    _connectingToVideoResource = true;
    setState();
    try {
      await videoPlayerController.initialize();
      if (videoPlayerController.value.initialized) {
        aspectRatio = videoPlayerController.value.aspectRatio;
        await videoPlayerController.seekTo(_position);
        await videoPlayerController.play();
      }
    } catch (e) {
      print(e.toString());
    }
    _connectingToVideoResource = false;
    setState();
  }

  bool isVideoInitialized() {
    return videoPlayerController != null &&
        videoPlayerController.value.initialized;
  }

  bool isVideoLoading() {
    return _isBuffering || _connectingToVideoResource || _isVideoSeeking;
  }

  bool isVideoPlaying() {
    return isVideoInitialized() &&
        !isVideoLoading() &&
        videoPlayerController.value.isPlaying;
  }

  bool isVideoFinished() {
    return _videoFinished;
  }

  void _checkIfVideoFinished() {
    if (!isVideoInitialized()) return;

    if (videoPlayerController.value.position >=
        videoPlayerController.value.duration) {
      if (!updatedSuperstate)
          SuperStateful.of(context).popupCountVideos(add:true);
      
      if (commercial) {
        _finishCommercial();
      } else if (!_videoFinished) {
        _savePosition(
          customPosition: Duration(
              seconds: videoPlayerController.value.duration.inSeconds + 1),
        );
        _videoFinished = true;
      }
      setState();
    } else {
      _videoFinished = false;
      setState();
    }
  }

  void play() {
    if (!isVideoPlaying()) {
      videoPlayerController.play();
      _logAnalyticsEvent(AnalyticsConstants.tapPlayVideo);
    }
  }

  void pause() {
    if (isVideoPlaying()) {
      videoPlayerController.pause();
      _logAnalyticsEvent(AnalyticsConstants.tapPauseVideo);
    }
  }

  Future<void> seekVideo({@required bool forward}) async {
    if (!isVideoInitialized()) return;
    _isVideoSeeking = true;
    await videoPlayerController.pause();
    setState();
    final currentPosition = await videoPlayerController.position;
    if (forward)
      await videoPlayerController
          .seekTo(currentPosition + Duration(seconds: seekTimeValue));
    else
      await videoPlayerController
          .seekTo(currentPosition - Duration(seconds: seekTimeValue));
    _isVideoSeeking = false;
    await videoPlayerController.play();
    setState();
    _logAnalyticsEvent(forward
        ? AnalyticsConstants.tapVideoSkip
        : AnalyticsConstants.tapVideoRewind);
  }

  Future<void> seekTo({@required Duration position}) async {
    if (!isVideoInitialized()) return;
    _isVideoSeeking = true;
    videoPlayerController.pause();
    setState();
    await videoPlayerController.seekTo(position);
    _isVideoSeeking = false;
    await videoPlayerController.play();
    setState();
  }

  void _finishCommercial() {
    _position = Duration(seconds: video.progress.seconds);
    _previousPosition = _position;
    commercial = false;
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _connectToVideoResource());
  }

  void _savePosition({Duration customPosition}) async {
    if (isVideoInitialized() &&
        !isVideoLoading() &&
        !_videoFinished &&
        !commercial) {
      _position = customPosition ?? videoPlayerController.value.position;
      final result = await _videoRepository.setVideoProgress(
        videoId: video.id,
        seconds: _position.inSeconds.toString(),
      );
      if (timerFlag == null) {
        timerFlag = false;
      }
      if (!timerFlag && (_position.inSeconds - video.seconds).abs() < 10) {
        _logAnalyticsEvent(AnalyticsConstants.eventVideoStop);
        timerFlag = true;
        Future.delayed(const Duration(milliseconds: 15000), () {
          timerFlag = false;
        });
      }
      if (timerFlag1 == null) {
        timerFlag1 = false;
      }
      if (!timerFlag1 && _position.inSeconds < 10) {
        _logAnalyticsEvent(AnalyticsConstants.eventVideoStart);
        timerFlag1 = true;
        Future.delayed(const Duration(milliseconds: 15000), () {
          timerFlag1 = false;
        });
      }

      if (result is RepositorySuccessResult<void>) {
        _topicRepository.saveProgressToCache(
          video.topicId,
          video.order,
          _position.inSeconds,
        );
      }
    }
  }

  void _logAnalyticsEvent(String event, {dynamic additionalArgs}) {
    var args = _analyticsProvider.getVideoParam(video.id, video.name);
    if (additionalArgs != null) {
      args.addAll(additionalArgs);
    }

    _analyticsProvider.logEvent(event, params: args);
  }

  void _bufferingTimeout() {
    if (!_isBuffering) return;
    if (videoQuality == VideoQuality.P720)
      switchVideoResource(VideoQuality.P540);
    else if (videoQuality == VideoQuality.P540)
      switchVideoResource(VideoQuality.P360);
  }

  void _checkBuffering() async {
    if (isVideoInitialized() &&
        !_connectingToVideoResource &&
        !_isVideoSeeking &&
        videoPlayerController.value.isPlaying) {
      final currentPosition = await videoPlayerController.position;
      if (_previousPosition.compareTo(currentPosition) == 0) {
        if (!_isBuffering) {
          _bufferingTimeoutTimer?.cancel();
          _bufferingTimeoutTimer = Timer(connectionTimeout, _bufferingTimeout);
        }
        _isBuffering = true;

        setState();
      } else {
        _isBuffering = false;
        setState();
      }
      _previousPosition = currentPosition;
    } else {
      _isBuffering = false;
      setState();
    }
  }

  double _getVideoSpeed(VideoPlaybackSpeed videoPlaybackSpeed) {
    switch (videoPlaybackSpeed) {
      case VideoPlaybackSpeed.x1:
        return 1.0;
      case VideoPlaybackSpeed.x125:
        return 1.25;
      case VideoPlaybackSpeed.x15:
        return 1.5;
      case VideoPlaybackSpeed.x175:
        return 1.75;
      case VideoPlaybackSpeed.x2:
        return 2;
      default:
        return 1.0;
    }
  }

  void dispose() {
    videoPlayerController?.dispose();
    _bufferingTimeoutTimer?.cancel();
    _savePositionTimer?.cancel();
    _checkBufferingTimer?.cancel();
    _connectionTimer?.cancel();
  }
}
