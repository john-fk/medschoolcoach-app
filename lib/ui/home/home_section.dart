import 'package:Medschoolcoach/utils/responsive_fonts.dart';
import 'package:flutter/cupertino.dart';

class HomeSection extends StatelessWidget {
  final String sectionTitle;
  final Widget sectionWidget;
  final bool useMargin;

  const HomeSection({
    @required this.sectionTitle,
    @required this.sectionWidget,
    this.useMargin = true,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              sectionTitle,
              style: normalResponsiveFont(context, fontWeight: FontWeight.bold),
            ),
          ),
          useMargin
              ? const SizedBox(
                  height: 16,
                )
              : Container(),
          sectionWidget
        ],
      ),
    );
  }
}
