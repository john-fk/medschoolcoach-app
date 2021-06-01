import 'package:universal_io/io.dart'  show Platform;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DialogActionData {
  final Key key;
  final String text;
  final VoidCallback onTap;

  DialogActionData({
    this.key,
    this.text,
    this.onTap,
  });
}

class CustomDialog extends StatelessWidget {
  final String title;
  final String content;
  final List<DialogActionData> actions;

  const CustomDialog({
    Key key,
    this.title,
    this.content,
    this.actions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return CupertinoAlertDialog(
        title: Text(
          title,
        ),
        content: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(
            content,
          ),
        ),
        actions: actions != null && actions.isNotEmpty ? actions
            .map((dialogActionData) => CupertinoDialogAction(
                  key: dialogActionData.key,
                  child: Text(dialogActionData.text),
                  onPressed: dialogActionData.onTap,
                ))
            .toList() : [],
      );
    } else {
      return AlertDialog(
        title: Text(
          title,
        ),
        content: Text(
          content,
        ),
        actions: actions
            .map<Widget>((dialogActionData) => FlatButton(
                  key: dialogActionData.key,
                  child: Text(dialogActionData.text),
                  onPressed: dialogActionData.onTap,
                ))
            .toList()
              ..add(
                SizedBox(
                  width: 8,
                ),
              ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      );
    }
  }
}
