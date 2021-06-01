import 'package:universal_io/io.dart'  show Platform;

import 'package:Medschoolcoach/utils/style_provider/style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ButtonProgressBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return Theme(
          data: ThemeData(
              cupertinoOverrideTheme:
                  CupertinoThemeData(brightness: Brightness.dark)),
          child: CupertinoActivityIndicator(radius: 16));
    } else {
      return CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(
          Style.of(context).colors.content2,
        ),
      );
    }
  }
}
