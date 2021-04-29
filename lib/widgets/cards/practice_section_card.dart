import 'package:Medschoolcoach/utils/responsive_fonts.dart';
import 'package:flutter/material.dart';

class PracticeCard extends StatelessWidget {
  final Color bgColor;
  final IconData iconData;
  final String text;
  final String route;

  PracticeCard({this.bgColor, this.iconData, this.text, this.route});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: bgColor,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            if (route != null)
              Navigator.of(context)
                  .pushNamed(route, arguments: "home_practice_section");
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Icon(
                  iconData,
                  color: Colors.white.withOpacity(0.75),
                  size: MediaQuery.of(context).size.width * 0.12,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  text,
                  style: mediumResponsiveFont(context,
                      fontColor: FontColor.Content2),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
