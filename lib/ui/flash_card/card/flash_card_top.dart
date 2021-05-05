import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:Medschoolcoach/utils/responsive_fonts.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

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
  bool _undoCard = false;
  String _returnText;

  @override
  Widget build(BuildContext context) {
    if (_currentColor == null) _currentColor = Color(0xBCBCBC);
    if (_currentText == null) _currentText = "";
    _returnText = FlutterI18n.translate(context, "flashcards_tips.return");
    bool noText = _currentText == "";
    double _opacity = _currentColor.opacity;

    return AnimatedOpacity(
        opacity: _currentText == _returnText && !_undoCard ? 0 : 1,
        duration: Duration(milliseconds: 500),
        child: Container(
            decoration: BoxDecoration(
                color: Colors.white.withOpacity(noText ? 0.0 : 1.0),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10.0),
                  topRight: Radius.circular(10.0),
                )),
            child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        _currentColor.withOpacity(_opacity * 0.11),
                        _currentColor.withOpacity(_opacity * 0.32)
                      ],
                    ),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10.0),
                      topRight: Radius.circular(10.0),
                    )),
                width: widget.width,
                height: widget.height / 8,
                child: Text(_currentText,
                    style: normalResponsiveFont(context).copyWith(
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF0E2D45).withOpacity(_opacity))))));
  }

  void undoTab() {
    setState(() {
      _undoCard = true;
      _currentColor = Color(0xFF2196F5);
      _currentText = _returnText;
    });

    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _undoCard = false;
      });
    });
  }

  void updateTab(Color color, String text) {
    setState(() {
      _currentColor = color;
      _currentText = text;
    });
  }
}
