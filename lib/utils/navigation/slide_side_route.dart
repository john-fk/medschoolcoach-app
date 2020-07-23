import 'package:flutter/material.dart';

enum SlideSide {
  Left,
  Right,
  Up,
}

class SlideSideRoute extends PageRouteBuilder<Widget> {
  final Widget page;
  final SlideSide slideSide;
  SlideSideRoute({
    @required this.page,
    @required this.slideSide,
  }) : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              page,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              SlideTransition(
            position: Tween<Offset>(
              begin: _initialOffset(slideSide),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        );
  static Offset _initialOffset(SlideSide slideSide) {
    if (slideSide == SlideSide.Right) return const Offset(-1, 0);
    if (slideSide == SlideSide.Left) return const Offset(1, 0);
    if (slideSide == SlideSide.Up) return const Offset(0, 1);
    return Offset(0, 1);
  }
}
