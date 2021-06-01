import 'package:universal_io/io.dart'  show Platform;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProgressBar extends StatelessWidget {
  final bool isDark;
  ProgressBar({this.isDark = false});

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return Theme(
          data: ThemeData(
              cupertinoOverrideTheme: CupertinoThemeData(
                  brightness: isDark ? Brightness.dark : Brightness.light)),
          child: CupertinoActivityIndicator(radius: 16));
    } else {
      return CircularProgressIndicator();
    }
  }
}
