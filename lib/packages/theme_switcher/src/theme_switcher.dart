import 'package:flutter/material.dart';

import 'clippers/theme_switcher_circle_clipper.dart';
import 'clippers/theme_switcher_clipper.dart';
import 'theme_provider.dart';

typedef ChangeTheme = void Function(ThemeData theme);
typedef BuilderWithSwitcher = Widget Function(BuildContext, ThemeSwitcherState switcher);
typedef BuilderWithTheme = Widget Function(BuildContext, ThemeSwitcherState switcher, ThemeData theme);

class ThemeSwitcher extends StatefulWidget {
  const ThemeSwitcher({
    super.key,
    this.clipper = const ThemeSwitcherCircleClipper(),
    required this.builder,
  });

  factory ThemeSwitcher.switcher({
    Key? key,
    ThemeSwitcherCircleClipper clipper = const ThemeSwitcherCircleClipper(),
    required BuilderWithSwitcher builder,
  }) =>
      ThemeSwitcher(
        key: key,
        clipper: clipper,
        builder: (BuildContext ctx) => builder(ctx, ThemeSwitcher.of(ctx)),
      );

  factory ThemeSwitcher.withTheme({
    Key? key,
    ThemeSwitcherCircleClipper clipper = const ThemeSwitcherCircleClipper(),
    required BuilderWithTheme builder,
  }) =>
      ThemeSwitcher.switcher(
        key: key,
        clipper: clipper,
        builder: (BuildContext ctx, ThemeSwitcherState s) => builder(ctx, s, ThemeModelInheritedNotifier.of(ctx).theme),
      );

  final Widget Function(BuildContext) builder;
  final ThemeSwitcherClipper? clipper;

  @override
  ThemeSwitcherState createState() => ThemeSwitcherState();

  static ThemeSwitcherState of(BuildContext context) {
    final _InheritedThemeSwitcher inherited = context.dependOnInheritedWidgetOfExactType<_InheritedThemeSwitcher>()!;
    return inherited.data;
  }
}

class ThemeSwitcherState extends State<ThemeSwitcher> {
  final GlobalKey _globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return _InheritedThemeSwitcher(
      data: this,
      child: Builder(
        key: _globalKey,
        builder: widget.builder,
      ),
    );
  }

  void changeTheme({
    required ThemeData theme,
    bool isReversed = false,
    Offset? offset,
    VoidCallback? onAnimationFinish,
  }) {
    ThemeModelInheritedNotifier.of(context).changeTheme(
      theme: theme,
      key: _globalKey,
      clipper: widget.clipper,
      context: context,
      isReversed: isReversed,
      offset: offset,
      onAnimationFinish: onAnimationFinish,
    );
  }
}

class _InheritedThemeSwitcher extends InheritedWidget {
  final ThemeSwitcherState data;

  _InheritedThemeSwitcher({
    required this.data,
    required super.child,
  });

  @override
  bool updateShouldNotify(_InheritedThemeSwitcher oldWidget) {
    return true;
  }
}
