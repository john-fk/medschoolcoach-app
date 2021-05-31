import 'package:Medschoolcoach/providers/analytics_constants.dart';
import 'package:Medschoolcoach/providers/analytics_provider.dart';
import 'package:Medschoolcoach/utils/sizes.dart';
import 'package:Medschoolcoach/widgets/app_bars/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:Medschoolcoach/widgets/progress_bar/progress_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:injector/injector.dart';

class WhiteboardNotesScreenData {
  final String url;

  WhiteboardNotesScreenData({
    @required this.url,
  });
}

class WhiteboardNotesScreen extends StatefulWidget {
  final WhiteboardNotesScreenData _whiteboardNotesScreenData;

  const WhiteboardNotesScreen(this._whiteboardNotesScreenData);

  @override
  _WhiteboardNotesScreenState createState() => _WhiteboardNotesScreenState();
}

class _WhiteboardNotesScreenState extends State<WhiteboardNotesScreen> {
  final transformationController = TransformationController();
  final AnalyticsProvider _analyticsProvider =
      Injector.appInstance.getDependency<AnalyticsProvider>();

  String _url;

  @override
  void initState() {
    _analyticsProvider.logScreenView(AnalyticsConstants.screenWhiteBoardNotes,
        AnalyticsConstants.screenLessonVideo);
    super.initState();
    _url = widget._whiteboardNotesScreenData.url;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Stack(
            children:[
              Container(
                    padding:EdgeInsets.only(top:
                    MediaQuery.of(context).padding.top
                    + whenDevice(context, large: 66, tablet: 112)),
                    child:_buildContent(),
              ),
              Column(
              children:[
                CustomAppBar(
                  title:
                  FlutterI18n.translate(context, "lesson_screen.whiteboard_notes"),
                )]),
            ],
          )
        ),
      );
  }

  Widget _buildContent() {
    return Padding(
        padding: const EdgeInsets.all(20),
        child: Column(children: [
          Expanded(
              child: InteractiveViewer(
                  transformationController: transformationController,
                  // pass the transformation controller
                  boundaryMargin: EdgeInsets.all(10.0),
                  minScale: 0.5,
                  // min scale
                  maxScale: 2.5,
                  // max scale
                  scaleEnabled: true,
                  panEnabled: true,
                  child: CachedNetworkImage(
                    filterQuality: FilterQuality.high,
                    imageUrl: _url,
                    placeholder: (context, url) =>
                            Center(child:ProgressBar()
                    ),
                    errorWidget: (context, url, dynamic error) =>
                        const Icon(Icons.error),
                  ))),
        ]));
  }
}
