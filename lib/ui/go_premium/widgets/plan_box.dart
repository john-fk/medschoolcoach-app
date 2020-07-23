import 'package:Medschoolcoach/utils/sizes.dart';
import 'package:Medschoolcoach/utils/style_provider/style.dart';
import 'package:Medschoolcoach/widgets/inkwell_image/inkwell_image.dart';
import 'package:flutter/material.dart';

class PlanBox extends StatelessWidget {
  final bool active;
  final Function onTap;
  final String plan;
  final String prize;
  final String discount;

  final defaultOutlineColor = Color(0xFF1155c3);
  final activeOutlineColor = Color(0xFFe09f38);

  PlanBox({
    Key key,
    @required this.active,
    @required this.onTap,
    @required this.plan,
    @required this.prize,
    this.discount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          discount == null ? "" : discount,
          style: Style.of(context).font.normal2.copyWith(
                fontSize: whenDevice(
                  context,
                  small: 10,
                  large: 12,
                  tablet: 18,
                ),
              ),
        ),
        const SizedBox(height: 5),
        InkWellObject(
          borderRadius: BorderRadius.circular(15),
          onTap: active ? null : onTap,
          child: Container(
            height: whenDevice(
              context,
              small: 80,
              large: 120,
              tablet: 180,
            ),
            width: whenDevice(
              context,
              small: 75,
              large: 100,
              tablet: 175,
            ),
            decoration: BoxDecoration(
              color: active
                  ? Style.of(context).colors.premium
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: active ? activeOutlineColor : defaultOutlineColor,
                width: 2,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  plan,
                  style: active
                      ? Style.of(context).font.bold2.copyWith(
                            fontSize: whenDevice(
                              context,
                              small: 12,
                              medium: 14,
                              large: 15,
                              tablet: 25,
                            ),
                          )
                      : Style.of(context).font.normal2.copyWith(
                            fontSize: whenDevice(
                              context,
                              small: 12,
                              medium: 14,
                              large: 15,
                              tablet: 25,
                            ),
                          ),
                ),
                const SizedBox(height: 10),
                Text(
                  prize,
                  style: Style.of(context).font.bold2.copyWith(
                        fontSize: whenDevice(
                          context,
                          small: 18,
                          large: 22,
                          tablet: 40,
                        ),
                      ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
