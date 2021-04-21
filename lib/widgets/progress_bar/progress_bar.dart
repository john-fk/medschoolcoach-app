import 'dart:io' show Platform;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProgressBar extends StatelessWidget {
  final bool isDark;

  ProgressBar({this.isDark = false});

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return Theme(
          data: isDark?ThemeData.dark():ThemeData.light(),
          child: CupertinoActivityIndicator(radius: 16));
    } else {
      return CircularProgressIndicator();
    }
  }
}
