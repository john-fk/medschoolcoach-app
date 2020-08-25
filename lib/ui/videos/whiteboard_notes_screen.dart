import 'package:Medschoolcoach/repository/repository_result.dart';
import 'package:Medschoolcoach/widgets/app_bars/custom_app_bar.dart';
import 'package:Medschoolcoach/widgets/empty_state/empty_state.dart';
import 'package:Medschoolcoach/widgets/navigation_bar/navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

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

  }

  RepositoryErrorResult _error;

  @override
  Widget build(BuildContext context) {

    _url = widget._whiteboardNotesScreenData.url;
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

    width = MediaQuery
        .of(context)
        .size
        .width;
    return Padding(
      padding: const EdgeInsets.all(20),
      child: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: <Widget>[
            const SizedBox(height: 15),
            _error != null
                ? Padding(
              padding: const EdgeInsets.only(bottom: 15.0),
              child: EmptyState(repositoryResult: _error),
            )
          : Image.network(
              _url,
            ),],
        ),
      ),
    );
  }
}
