import 'package:flutter/material.dart';
import 'package:Medschoolcoach/utils/responsive_fonts.dart';
import 'package:Medschoolcoach/utils/sizes.dart';
import 'package:Medschoolcoach/utils/style_provider/style.dart';

class FlashCardTop extends StatefulWidget {
  final double width;
  final double height;

  FlashCardTop({Key key, @required this.width, @required this.height})
      : super(key: key);

  @override
  FlashCardTopState createState() => FlashCardTopState();
}

class FlashCardTopState extends State<FlashCardTop> {
  Color _currentColor;
  String _currentText;

  @override
  Widget build(BuildContext context) {
    if (_currentColor == null) _currentColor = Color(0x00FFFFFF);
    if (_currentText == null) _currentText = "";
    return Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [_currentColor.withOpacity(0.1), _currentColor],
            ),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10.0),
              topRight: Radius.circular(10.0),
            )),
        width: widget.width,
        height: widget.height / 10,
        child: Text(_currentText, style: normalResponsiveFont(context)));
  }

  void updateTab(Color color, String text) {
    setState(() {
      _currentColor = color;
      _currentText = text;
    });
  }
}
