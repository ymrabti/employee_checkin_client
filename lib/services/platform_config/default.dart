import 'dart:io';
import 'package:employee_checks/lib.dart';

class EmployeeChecksPlatform {
  static bool isAndroid = Platform.isAndroid;
  static bool isIOS = Platform.isIOS;
  static bool isFuchsia = Platform.isFuchsia;
  static bool isWindows = Platform.isWindows;
  static bool isLinux = Platform.isLinux;
  static bool isMacOS = Platform.isMacOS;
  static bool isWeb = false;
  static bool isDesktop = isMacOS || isWindows || isLinux;
  static bool isPhone = isAndroid || isIOS || isFuchsia;
}

void setWebTitle(BuildContext context, String title) {
//   logg(title, 'setWebTitle');
}
void unsetWebTitle() {}
