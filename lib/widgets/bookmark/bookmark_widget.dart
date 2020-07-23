import 'package:Medschoolcoach/utils/sizes.dart';
import 'package:Medschoolcoach/utils/style_provider/style.dart';
import 'package:flutter/material.dart';

class BookmarkWidget extends StatelessWidget {
  final bool active;
  final VoidCallback onTap;

  const BookmarkWidget({
    Key key,
    @required this.active,
    @required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Icon(
          Icons.bookmark,
          color: active ? Style.of(context).colors.content : Color(0xFFD3D6D7),
          size: whenDevice(context, large: 25, tablet: 40),
        ),
      ),
      onTap: onTap,
    );
  }
}
