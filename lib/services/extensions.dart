import 'dart:math';

import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:employee_checks/lib.dart';
import 'package:faker/faker.dart' hide Color;
import 'package:collection/collection.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

extension NumberFormatter on num {
  String toThousands() {
    final NumberFormat formatter = NumberFormat.decimalPattern('fr');
    return formatter.format(this);
  }

  int boundRGB() {
    return this > 255
        ? 255
        : this < 0
            ? 0
            : round();
  }
}

extension IntX on int {
  String get monthName {
    Locale? locale = Get.context?.locale;
    return DateFormat.MMM(locale?.languageCode).format(DateTime(2024, this)).toUpperCase();
  }
}

extension DurationX on Duration {
  String format() {
    String twoDigits(int n) => n.toString().padLeft(2, '0');

    String hours = twoDigits(inHours);
    String minutes = twoDigits(inMinutes.remainder(60));
    String seconds = twoDigits(inSeconds.remainder(60));

    return "$hours:$minutes:$seconds";
  }
}

extension DateTimeX on DateTime {
  String eeeDDDMMM() {
    return DateFormat('EEE, dd MMM, yyyy', Get.locale?.languageCode).format(this);
  }

  bool sameDayAs(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }

  Duration get dura => Duration(hours: hour, minutes: minute, seconds: second, milliseconds: millisecond);
}

extension TimeX on TimeOfDay {
  DateTime toDateTime() {
    return DateTime.now().copyWith(hour: hour, minute: minute);
  }
}

extension ListX<T> on List<T> {
  List<T> reverse(bool arabic) {
    return arabic ? reversed.toList() : this;
  }

  List<T> joinBy({required T item, T Function(T index)? transformer, bool outline = true}) {
    List<T> inline = mapIndexed(
      (int i, T e) => <T>[if (i != 0) item, (transformer ?? (T it) => it)(e)],
    ).toList().expand((List<T> ex) => ex).toList();
    return <T>[
      if (outline) item,
      ...inline,
      if (outline) item,
    ];
  }

  List<T> joinByBuilder(T Function(int index) builder, {bool outline = true}) {
    List<T> inline = mapIndexed(
      (int i, T e) => <T>[if (i != 0) builder(i), e],
    ).toList().expand((List<T> e) => e).toList();
    return <T>[
      if (outline) builder(0),
      ...inline,
      if (outline) builder(length),
    ];
  }
}

extension ColorX on Color {
  Color transform(bool reverse) {
    return reverse
        ? Color.from(
            red: (1 - r),
            green: (1 - g),
            blue: (1 - b),
            alpha: a,
          )
        : this;
  }

  Color _darker(int value) {
    return Color.fromARGB(
      (a * 255).round(),
      (r * 255 - value).boundRGB(),
      (g * 255 - value).boundRGB(),
      (b * 255 - value).boundRGB(),
    );
  }

  Color _lighter(int value) {
    return Color.fromARGB(
      (a * 255).round(),
      (r * 255 + value).boundRGB(),
      (g * 255 + value).boundRGB(),
      (b * 255 + value).boundRGB(),
    );
  }

  Color contrast(int value) {
    return Get.isDarkMode ? _lighter(value) : _darker(value);
  }
}

extension GlobalKeyFormStateX on GlobalKey<FormState> {
  bool validateSave() {
    bool valid = currentState?.validate() ?? false;
    if (valid) {
      currentState?.save();
    }
    return valid;
  }
}

extension FakerX on Faker {
  String get fullName => person.name();
//
  DateTime get dateTime => date.dateTime(minYear: 2024, maxYear: 2024);
  TimeOfDay get time => TimeOfDay.fromDateTime(date.dateTime());
//
  String get fullAddress {
    String buildingNumber = address.buildingNumber();
    String streetName = address.streetName();
    String streetSuffix = address.streetSuffix();
    String streetAddress = "$buildingNumber $streetName $streetSuffix";

    String cityPrefix = address.cityPrefix();
    String city = address.city();
    String citySuffix = address.citySuffix();
    String fullCityName = "$cityPrefix $city $citySuffix";

    String state = address.state();
    String zipCode = address.zipCode();
    String country = address.country();
    String countryCode = address.countryCode();
    String continent = address.continent();
    String neighborhood = address.neighborhood();

    // Constructing the full address
    String fullAddress = '''
$streetAddress
$neighborhood
$fullCityName, $state $zipCode
$country ($countryCode)
$continent
''';

    return fullAddress.toString();
  }

//
  bool get binary => Random().nextBool();
//
  String get id => guid.guid();
  String get multiline => lorem.sentence();
//
//   String get img => imgList.elementAt(Random().nextInt(imgList.length));
  String get username => internet.userName();
  String get password => internet.password();
//
  String get uri1 => internet.uri('https');
  String get uri2 => internet.httpUrl();
  String get uri3 => internet.httpsUrl();
//
  String get email1 => internet.email();
  String get email2 => internet.freeEmail();
  String get email3 => internet.safeEmail();
  String get email4 => internet.disposableEmail();
//
  String get str1 => animal.name();
  String get str2 => company.name();
  String get str3 => color.color();
  String get str4 => conference.name();
  String get str5 => food.cuisine();
  String get str6 => food.dish();
  String get str7 => animal.name();
  String get str8 => job.title();
}

extension ContextX on BuildContext {
  Locale get locale => Localizations.localeOf(this);
  AppLocalizations get tr => AppLocalizations.of(this);
  void hideCurrentAndShowSnackbar(SnackBar snackbar) {
    ScaffoldMessenger.of(this).hideCurrentSnackBar();
    ScaffoldMessenger.of(this).showSnackBar(snackbar);
  }

  Future<void> logOut() async {
    await read<EmployeeChecksState>().disconnect();
    read<EmployeeChecksRealtimeState>().updateSocket(tokens: null);
    Get.offNamedUntil(
      EmployeeChecksLoginPage.route,
      (Route<void> route) => false,
    );
  }

  EmployeeChecksUser? get readUser => read<EmployeeChecksState>().user;
  set load(bool load) {
    read<EmployeeChecksState>().load = load;
  }

  Future<void> setUserConnected(EmployeeChecksUser user) async {
    await read<EmployeeChecksState>().setUserConnected(user);
  }

  void inAppNotification(
    String title, {
    Widget? bodyWidget,
    required List<InlineSpan> children,
  }) {
    hideCurrentAndShowSnackbar(
      SnackBar(
        content: bodyWidget ??
            Text.rich(
              TextSpan(
                text: title,
                style: Get.context?.theme.primaryTextTheme.titleMedium?.copyWith(
                  fontSize: 13,
                  fontFamily: 'InterEmployeeChecks',
                ),
                children: <InlineSpan>[
                  TextSpan(text: '\n'),
                  ...children,
                ],
              ),
            ),
      ),
    );
  }
}

extension ThemeSata on ThemeData {
  bool get isDarkMode => brightness == Brightness.dark;
  Color get adaptativePrimaryColor => isDarkMode ? EmployeeChecksColors.schemeDark : EmployeeChecksColors.schemeLight;
  Color get backgroundColor => colorScheme.surface;
  Color get foregroundColor => colorScheme.surface.transform(true);

  Color get adaptativeTextColor => isDarkMode ? const Color(0xFFF3F3F3) : primaryColorDark;
}

extension GlobalKeyFormBuilderStateX on GlobalKey<FormBuilderState> {
  Color formplusColorValue(BuildContext context) {
    bool? isValid = valid;
    if (isValid) return context.theme.colorScheme.error;
    return context.theme.colorScheme.error;
  }

  void resetAndBack() {
    currentState?.reset();
    Get.back();
  }

  bool get touched {
    return currentState?.isTouched ?? true;
  }

  bool get dirty {
    return currentState?.isDirty ?? true;
  }

  bool get valid {
    return currentState?.isValid ?? false;
  }

  bool validateSave() {
    bool valid = currentState?.validate() ?? false;
    if (valid) {
      currentState?.save();
    }
    return valid;
  }

  Map<String, Object?> get instantValue => currentState?.instantValue as Map<String, Object?>;
  Map<String, Object?> get value => currentState?.value as Map<String, Object?>;
}
