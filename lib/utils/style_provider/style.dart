import 'package:flutter/material.dart';

part './style/assets.dart';

part './style/borders.dart';

part './style/fonts.dart';

part './style/gradients.dart';

part './style/shadows.dart';

/// Provides colors that are used to create app style by style provider
class AppColors {
  const AppColors(
      {@required this.accent2,
      @required this.accent3,
      @required this.accent4,
      @required this.content2,
      @required this.content4,
      @required this.inputBackground,
      @required this.shadow2,
      @required this.accent,
      @required this.content,
      @required this.content3,
      @required this.background,
      @required this.background2,
      @required this.background3,
      @required this.shadow,
      @required this.brightShadow,
      @required this.error,
      @required this.premium,
      @required this.separator,
      @required this.questions,
      @required this.divider,
      @required this.qualifyingText,
      @required this.border,
      @required this.qbCorrect,
      @required this.qbIncorrect,
      @required this.bottomSlider});

  final Color accent;
  final Color accent2;
  final Color accent3;
  final Color accent4;

  final Color content;
  final Color content2;
  final Color content3;
  final Color content4;

  final Color background;
  final Color background2;
  final Color background3;
  final Color inputBackground;

  final Color shadow;
  final Color shadow2;
  final Color brightShadow;

  final Color error;
  final Color premium;
  final Color separator;
  final Color questions;

  final Color divider;

  final Color qualifyingText;
  final Color border;

  final Color qbCorrect;
  final Color qbIncorrect;
  final Color bottomSlider;

  /// Creates a copy of this [AppColors] but with the given
  /// fields replaced with the new values.
  AppColors copyWith(
          Color accent,
          Color accent2,
          Color accent3,
          Color accent4,
          Color content,
          Color content2,
          Color content3,
          Color content4,
          Color background,
          Color background2,
          Color background3,
          Color inputBackground,
          Color shadow,
          Color shadow2,
          Color brightShadow,
          Color error,
          Color premium,
          Color separator,
          Color questions,
          Color divider,
          Color qbCorrect,
          Color qbIncorrect,
          Color bottomSlider,
          Color qualifyingText) =>
      AppColors(
          accent: accent ?? this.accent,
          accent2: accent2 ?? this.accent2,
          accent3: accent3 ?? this.accent3,
          accent4: accent4 ?? this.accent4,
          content: content ?? this.content,
          content2: content2 ?? this.content2,
          content3: content3 ?? this.content3,
          content4: content4 ?? this.content4,
          background: background ?? this.background,
          background2: background2 ?? this.background2,
          background3: background3 ?? this.background3,
          inputBackground: inputBackground ?? this.inputBackground,
          shadow: shadow ?? this.shadow,
          shadow2: shadow2 ?? this.shadow2,
          brightShadow: brightShadow ?? this.brightShadow,
          error: error ?? this.error,
          premium: premium ?? this.premium,
          separator: separator ?? this.separator,
          divider: divider ?? this.divider,
          questions: questions ?? this.questions,
          qualifyingText: qualifyingText ?? this.qualifyingText,
          qbIncorrect: qbIncorrect ?? this.qbIncorrect,
          qbCorrect: qbIncorrect ?? this.qbIncorrect,
          bottomSlider: bottomSlider ?? this.bottomSlider,
          border: border ?? this.border);
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
