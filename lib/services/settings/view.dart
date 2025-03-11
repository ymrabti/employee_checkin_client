import "package:flag/flag.dart";
import "package:flutter/cupertino.dart";
import 'package:employee_checks/lib.dart';
import "package:flutter/foundation.dart";
import "package:get/get.dart";
// import "package:swipeable_page_route/swipeable_page_route.dart";

class EmployeeChecksSettingsView extends StatefulWidget {
  static const String route = '/settings';
  EmployeeChecksSettingsView({super.key});

  @override
  State<EmployeeChecksSettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<EmployeeChecksSettingsView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPersistentFrameCallback(
      (Duration timeStamp) {
        if (!mounted) return;
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomThemeSwitchingArea(
      child: EmployeeChecksScaffold(
        appBar: AppBar(
          title: Text /** TV **/ (
            (context.tr.settings),
          ),
        ),
        body: Center(
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 48.0.r),
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(Icons.language),
                    ),
                    Expanded(
                      child: Text /** TV **/ (
                        (context.tr.changeLanguage),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
              RowLanguages(showCurrent: true),
              Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text /** TV **/ (
                      context.theme.isDarkMode ? (context.tr.darkTheme) : (context.tr.lightTheme),
                    ),
                    ThemeModeToggler(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class IconSettings extends StatelessWidget {
  IconSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: EmployeeChecksColors.transparent,
      child: InkWell(
        radius: 50,
        onTap: () async {
          await Get.toNamed(EmployeeChecksSettingsView.route);
        },
        child: Padding(
          padding: EdgeInsets.all(8.0.r),
          child: Icon(Icons.settings),
        ),
      ),
    );
  }
}

class RawLanguages extends StatelessWidget {
  const RawLanguages({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: AppLocalizations.supportedLocales
          .map(
            (Locale e) => Expanded(
              child: InkWell(
                onTap: () async {
                  await Get.updateLocale(Locale(e.languageCode));
                },
                child: Center(
                  child: Card(
                    child: Padding(
                      padding: EdgeInsets.all(18.0.r),
                      child: Text(
                        e.languageCode,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}

class LanguageFlag {
  String language;
  FlagsCode? code;
  String? letter;
  Widget? child;
  String label;
  LanguageFlag({
    required this.language,
    required this.label,
    this.code,
    this.child,
    this.letter,
  });
}

class RowLanguages extends StatelessWidget {
  RowLanguages({
    super.key,
    this.showCurrent = false,
    this.mainAxisAlignment = MainAxisAlignment.spaceEvenly,
  });

  final bool showCurrent;
  final MainAxisAlignment mainAxisAlignment;

  final double padding = 8.r;
  final double flagWidth = 35.5.r;
  @override
  Widget build(BuildContext context) {
    String? locale = AppLocalizations.of(context).localeName;

    List<LanguageFlag> rows = <LanguageFlag>[
      LanguageFlag(label: context.tr.ar, language: 'ar', code: FlagsCode.SA),
      LanguageFlag(label: context.tr.en, language: 'en', code: FlagsCode.US),
      LanguageFlag(label: context.tr.fr, language: 'fr', code: FlagsCode.FR),
    ];
    return Column(
      mainAxisAlignment: mainAxisAlignment,
      children: <Widget>[
        for (LanguageFlag lang in rows)
          if ((locale != lang.language) || showCurrent)
            InkWell(
              onTap: () async {
                await context.read<EmployeeChecksState>().updateLocale(lang.language);
              },
              child: Card(
                elevation: 2,
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(padding),
                      child: lang.code != null
                          ? Flag.fromCode(
                              lang.code!,
                              borderRadius: flagWidth,
                              height: flagWidth,
                              width: flagWidth,
                              fit: BoxFit.fitHeight,
                              flagSize: FlagSize.size_1x1,
                            )
                          : Container(
                              height: flagWidth,
                              width: flagWidth,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: context.theme.colorScheme.primary,
                              ),
                              /* child: Text(
                                lang.letter!,
                                style: TextStyle(color: Colors.white),
                              ), */
                              child: lang.child,
                            ),
                    ),
                    Gap(20.r),
                    Expanded(child: Text(lang.label)),
                    if (locale == lang.language)
                      Container(
                        width: flagWidth,
                        height: flagWidth,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: Icon(
                          CupertinoIcons.check_mark_circled_solid,
                          color: context.theme.primaryColor,
                        ),
                      ),
                  ],
                ),
              ),
            ),
      ],
    );
  }
}

class ThemeModeToggler extends StatefulWidget {
  ThemeModeToggler({super.key});

  @override
  State<ThemeModeToggler> createState() => _ThemeModeTogglerState();
}

class _ThemeModeTogglerState extends State<ThemeModeToggler> {
  //
  @override
  Widget build(BuildContext context) {
    Duration duration = Duration(milliseconds: 500);
    return ThemeSwitcher.switcher(
      builder: (BuildContext bcontext, ThemeSwitcherState state) {
        logg('context equals ${bcontext == context}');
        return AnimatedSwitcher(
          duration: duration,
          reverseDuration: duration,
          transitionBuilder: (Widget child, Animation<double> animation) {
            return RotationTransition(
              turns: animation,
              child: FadeTransition(
                opacity: animation,
                child: ScaleTransition(
                  scale: animation,
                  child: child,
                ),
              ),
            );
          },
          child: IconButton(
            tooltip: context.tr.tooggleThemeMode,
            onPressed: () async {
              ThemeSwitcherState themeSwitcherOf = ThemeSwitcher.of(bcontext);
              // Debug START
              RenderObject? boundary = context.findRenderObject();
              if (boundary == null) return;
              bool debugNeedsPaint = false;
              if (kDebugMode) debugNeedsPaint = boundary.debugNeedsPaint;
              if (debugNeedsPaint) return;
              // Debug END
              final bool prevDark = bcontext.theme.isDarkMode;
              await bcontext.read<EmployeeChecksState>().updateThemeMode(prevDark ? Brightness.light : Brightness.dark);
              themeSwitcherOf.changeTheme(theme: EmployeeChecksTheme(dark: !prevDark), isReversed: !prevDark);
            },
            icon: Icon(
              context.theme.isDarkMode ? Icons.dark_mode : Icons.wb_sunny_outlined,
            ),
          ),
        );
      },
      clipper: ThemeSwitcherCircleClipper(),
    );
  }
}
