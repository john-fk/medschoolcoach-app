import 'package:flutter/material.dart';

part './style/assets.dart';

part './style/borders.dart';

part './style/fonts.dart';

part './style/gradients.dart';

part './style/shadows.dart';

/// Provides colors that are used to create app style by style provider
class AppColors {
  const AppColors({
    @required this.accent2,
    @required this.content2,
    @required this.inputBackground,
    @required this.shadow2,
    @required this.accent,
    @required this.content,
    @required this.content3,
    @required this.background,
    @required this.shadow,
    @required this.brightShadow,
    @required this.error,
    @required this.premium,
    @required this.separator,
    @required this.questions,
  });

  final Color accent;
  final Color accent2;

  final Color content;
  final Color content2;
  final Color content3;

  final Color background;
  final Color inputBackground;

  final Color shadow;
  final Color shadow2;
  final Color brightShadow;

  final Color error;
  final Color premium;
  final Color separator;
  final Color questions;

  /// Creates a copy of this [AppColors] but with the given
  /// fields replaced with the new values.
  AppColors copyWith(
          Color accent,
          Color accent2,
          Color content,
          Color content2,
          Color content3,
          Color background,
          Color background2,
          Color shadow,
          Color shadow2,
          Color brightShadow,
          Color error,
          Color premium,
          Color separator) =>
      AppColors(
        accent: accent ?? this.accent,
        accent2: accent2 ?? this.accent2,
        content: content ?? this.content,
        content2: content2 ?? this.content2,
        content3: content3 ?? this.content3,
        background: background ?? this.background,
        inputBackground: background2 ?? this.inputBackground,
        shadow: shadow ?? this.shadow,
        shadow2: shadow2 ?? this.shadow2,
        brightShadow: brightShadow ?? this.brightShadow,
        error: error ?? this.error,
        premium: premium ?? this.premium,
        separator: separator ?? this.separator,
        questions: questions ?? this.questions,
      );
}

/// Provides app style
class Style extends InheritedWidget {
  /// Keeps app colors
  final AppColors colors;

  /// Keeps assets names which can be used like:
  /// ```dart
  ///  Image.asset(
  ///     StyleProvider.of(context).asset.facebookLogo,
  ///  );
  /// ```
  final _AppPngAssets pngAsset;

  final _AppSvgAssets svgAsset;

  /// Keeps app gradients
  final _AppGradients gradient;

  /// Keeps app shadows
  final _AppShadows shadow;

  /// Keeps app borders
  final _AppBorders border;

  /// Keeps app fonts
  final _AppFonts font;

  Style({
    Widget child,
    @required this.colors,
  })  : gradient = _AppGradients(colors),
        border = _AppBorders(colors),
        font = _AppFonts(colors),
        shadow = _AppShadows(colors),
        pngAsset = _AppPngAssets(),
        svgAsset = _AppSvgAssets(),
        super(child: child);

  /// Always returns false because this InheritedWidget is not mutable
  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => false;

  static Style of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<Style>();
}
