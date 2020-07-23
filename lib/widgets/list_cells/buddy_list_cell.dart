import 'package:Medschoolcoach/utils/responsive_fonts.dart';
import 'package:Medschoolcoach/utils/style_provider/style.dart';
import 'package:flutter/cupertino.dart';

class BuddyListCell extends StatelessWidget {
  final String status;
  final String userName;
  final String userEmail;

  const BuddyListCell({
    Key key,
    this.status,
    this.userName,
    this.userEmail,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Style.of(context).colors.separator,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(10.0),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    userName,
                    style: normalResponsiveFont(
                      context,
                    ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    userEmail,
                    style: smallResponsiveFont(
                      context,
                      fontColor: FontColor.Content3,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 8.0,
              ),
              child: _buildStatusBox(
                status,
                context,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBox(String status, BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(
            8,
          ),
        ),
        color: _getBoxColor(status, context),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 3.0,
          horizontal: 20.0,
        ),
        child: Text(
          status,
          style: normalResponsiveFont(
            context,
            fontColor: FontColor.Content2,
          ),
        ),
      ),
    );
  }

  Color _getBoxColor(
    String status,
    BuildContext context,
  ) {
    if (status == "Signed Up") {
      return Style.of(context).colors.accent2;
    } else {
      return Style.of(context).colors.accent;
    }
  }
}
