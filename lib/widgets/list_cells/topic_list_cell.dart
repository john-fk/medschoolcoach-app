import 'package:Medschoolcoach/utils/responsive_fonts.dart';
import 'package:Medschoolcoach/utils/sizes.dart';
import 'package:Medschoolcoach/utils/style_provider/style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TopicListCell extends StatelessWidget {
  final String title;
  final int progress;
  final VoidCallback onTap;

  const TopicListCell({
    this.title,
    this.progress,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: Key(title),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: Text(title, style: bigResponsiveFont(context)),
            ),
            if (progress != null) _progressBox(progress, context),
          ],
        ),
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Style.of(context).colors.shadow,
            ),
          ),
        ),
      ),
    );
  }

  Widget _progressBox(int progress, BuildContext context) {
    return Container(
      width: whenDevice(
        context,
        large: 50,
        tablet: 80,
      ),
      height: whenDevice(
        context,
        large: 25,
        tablet: 40,
      ),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        color: _progressBoxColor(progress, context),
      ),
      child: Text(
        "$progress%",
        style: normalResponsiveFont(context, fontColor: FontColor.Content2),
      ),
    );
  }

  Color _progressBoxColor(int progress, BuildContext context) {
    if (progress == 0) return Style.of(context).colors.separator;
    if (progress == 100) return Style.of(context).colors.accent2;
    return Style.of(context).colors.accent;
  }
}
