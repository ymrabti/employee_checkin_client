// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

import 'package:employee_checks/lib.dart';

void setWebTitle(BuildContext context, String title) {
  String t = title.isEmpty ? '' : ' - $title';
  html.document.title = '${context.tr.title}$t';
}

void unsetWebTitle() {
  html.document.title = '';
}

class EmployeeChecksPlatform {
  static bool isAndroid = false;
  static bool isIOS = false;
  static bool isFuchsia = false;
  static bool isWindows = false;
  static bool isLinux = false;
  static bool isMacOS = false;
  static bool isWeb = true;
  static bool isDesktop = false;
  static bool isPhone = false;
}
