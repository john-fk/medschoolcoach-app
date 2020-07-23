import 'package:flutter/material.dart';

T whenDevice<T>(
  BuildContext context, {
  T small,
  @required T large,
  T medium,
  T tablet,
}) {
  double height;
  double width;
  if (isPortrait(context)) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
  } else {
    height = MediaQuery.of(context).size.width;
    width = MediaQuery.of(context).size.height;
  }

  if (tablet != null && width > 650) return tablet;
  if (height > 750)
    return large;
  else if (height > 600)
    return medium ?? large;
  else
    return small ?? medium ?? large;
}

bool isPortrait(BuildContext context) {
  return MediaQuery.of(context).orientation == Orientation.portrait;
}
