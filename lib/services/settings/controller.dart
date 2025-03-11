import "package:flutter/services.dart";
import "package:employee_checks/lib.dart";
import "package:get/get.dart";

import "package:intl/date_symbol_data_local.dart" show initializeDateFormatting;
import "package:power_geojson/power_geojson.dart";

class SettingsController with ChangeNotifier {
  SettingsController();

  late final String fallback;

  bool get isDark => settings.brightness == Brightness.dark;

  late Settings _settings;

  Settings get settings => _settings;

  Future<void> loadSettings({
    required String encryptionKey,
    required Brightness systemBrightness,
  }) async {
    _settings = await Settings._getSettings(
      encryptionKey: encryptionKey,
      systemBrightness: systemBrightness,
    );
    await initializeDateFormatting();
    notifyListeners();
  }

  Future<void> saveSettings(String encryptionKey) async {
    await _settings.save(AppSaveNames.settings.name, encryptionKey);
    notifyListeners();
  }

  Future<void> updateLocale(String locale) async {
    await Get.updateLocale(Locale(locale));
    _settings.language = locale;
    // await saveSettings();
    notifyListeners();
  }

  Future<void> showTutorial(bool show) async {
    _settings.showTutorial = show;
    // await saveSettings();
    notifyListeners();
  }

  Future<void> updateThemeMode(Brightness? newThemeMode) async {
    if (newThemeMode == null) return;
    if (newThemeMode == settings.brightness) return;
    _settings.setBrightness = newThemeMode;
    // await saveSettings();
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarBrightness: newThemeMode,
        statusBarIconBrightness: newThemeMode,
      ),
    );
    // Get.changeThemeMode(newThemeMode.mode);
    // Get.changeTheme(EmployeeChecksTheme(dark: newThemeMode == Brightness.dark));
    notifyListeners();
  }
}

extension ThemeModeX on Brightness {
  ThemeMode get mode {
    switch (this) {
      case Brightness.dark:
        return ThemeMode.dark;

      case Brightness.light:
        return ThemeMode.light;

      //   default:
      //     return ThemeMode.system;
    }
  }
}

class Settings extends IGenericAppModel {
  static Future<Settings> _getSettings({
    required String encryptionKey,
    required Brightness systemBrightness,
  }) async {
    IGenericAppMap<Settings>? __settings = await IGenericAppModel.load<Settings>(AppSaveNames.settings.name, encryptionKey);
    return __settings?.value ?? Settings._defaultSettings(systemBrightness);
  }

  Brightness brightness;
  String language;
  bool showTutorial;
  set setBrightness(Brightness themeMode) => brightness = themeMode;
  Settings({
    required this.brightness,
    required this.language,
    required this.showTutorial,
  });

  static Settings _defaultSettings(Brightness systemBrightness) {
    return Settings(
      brightness: systemBrightness,
      language: AvailableLanguages.fr.name,
      showTutorial: true,
    );
  }

  Settings copyWith({
    Brightness? brightness,
    String? language,
  }) {
    return Settings(
      brightness: brightness ?? this.brightness,
      language: language ?? this.language,
      showTutorial: true,
    );
  }

  @override
  Map<String, Object?> toJson() {
    return <String, Object?>{
      SharedPreferencesKeys.brightness.name: brightness.name,
      SharedPreferencesKeys.language.name: language,
      SharedPreferencesKeys.showTutorial.name: showTutorial,
    };
  }

  factory Settings.fromJson(Map<String, Object?> json) {
    String? bright = json[SharedPreferencesKeys.brightness.name] as String?;
    String? lang = json[SharedPreferencesKeys.language.name] as String?;
    bool? showTutorial = json[SharedPreferencesKeys.showTutorial.name] as bool?;
    return Settings(
      brightness: bright == Brightness.light.name ? Brightness.light : Brightness.dark,
      language: lang ?? AvailableLanguages.fr.name,
      showTutorial: showTutorial ?? true,
    );
  }

  @override
  String toString() {
    return PowerJSON(toJson()).toText();
  }
}

DeviceScreenType getDeviceType(MediaQueryData mediaQuery) {
  Orientation orientation = mediaQuery.orientation;
  double deviceWidth = mediaQuery.size.shortestSide;

  if (deviceWidth > 950 || (orientation == Orientation.landscape && deviceWidth > 900)) {
    return DeviceScreenType.Desktop;
  }

  if (deviceWidth > 600) {
    return DeviceScreenType.Tablet;
  }

  return DeviceScreenType.Mobile;
}

// Detailed sizing information class
class SizingInformation {
  final DeviceScreenType deviceScreenType;
  final Size screenSize;
  final Size localWidgetSize;

  SizingInformation({
    required this.deviceScreenType,
    required this.screenSize,
    required this.localWidgetSize,
  });
}

enum DeviceScreenType { Mobile, Tablet, Desktop }

enum SharedPreferencesKeys {
  deviceId,
  inUpdate,
  brightness,
  authenticationTokens,
  language,
  settingController,
  settings,
  showTutorial,
}

enum AvailableLanguages {
  ar,
  az,
  af,
  en,
  fr,
}

enum AppSaveNames {
  all_competitions,
  settings,
  available_competitions_data,
  today_matches,
}
