import 'package:flutter/material.dart';

class TransparentAppBar extends StatelessWidget with PreferredSizeWidget {
  final List<Widget> actions;
  final Widget leading;
  final Widget title;
  TransparentAppBar({this.actions, this.leading, this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      brightness: Brightness.light,
      elevation: 0,
      title: title,
      backgroundColor: Colors.transparent,
      actions: actions,
      leading: leading
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
