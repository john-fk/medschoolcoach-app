import 'package:Medschoolcoach/widgets/app_bars/custom_app_bar.dart';
import 'package:Medschoolcoach/widgets/navigation_bar/navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:Medschoolcoach/widgets/progrss_bar/progress_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';

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
  final _scrollController = ScrollController();
  String _url;

  @override
  void initState() {
    super.initState();
    _url = widget._whiteboardNotesScreenData.url;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Column(
          children: <Widget>[
            CustomAppBar(
              title:
              FlutterI18n.translate(context, "lesson_screen.whiteboard_notes"),
            ),
            Expanded(
              child: _buildContent(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    double width;
    width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.all(20),
      child: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: <Widget>[
            const SizedBox(height: 15),
            CachedNetworkImage(
              filterQuality: FilterQuality.high,
              imageUrl: _url,
              placeholder: (context, url) => ProgressBar(),
              errorWidget: (context, url, dynamic error) =>
                  const Icon(Icons.error),
            )
          ],
        ),
      ),
    );
  }
}
