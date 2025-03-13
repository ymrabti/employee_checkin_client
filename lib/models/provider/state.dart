import 'package:employee_checks/lib.dart';

class EmployeeChecksState extends ChangeNotifier {
  final SettingsController settingsController;
  bool loading = false;
  set load(bool load) {
    loading = load;
    notifyListeners();
  }

  Future<void> disconnect() async {
    await user?.removeUser();
    user = null;
    notifyListeners();
  }

  EmployeeChecksUser? user;
  int _months = 3;
  int get months => _months;
  void setmonths(int m) {
    _months = m;
    notifyListeners();
  }

  Future<void> setUserConnected(EmployeeChecksUser? newUser) async {
    user = newUser;
    await user?.saveUser(encryptKey);
    notifyListeners();
  }

  final String encryptKey;
  EmployeeChecksState(
    this.settingsController, {
    this.user,
    required this.encryptKey,
  });

  Future<void> saveSettings() async {
    await settingsController.saveSettings(encryptKey);
  }

  Future<void> updateLocale(String locale) async {
    await settingsController.updateLocale(locale);
    await saveSettings();
  }

  Future<void> showTutorial(bool show) async {
    await settingsController.showTutorial(show);
    await saveSettings();
  }

  Future<void> updateThemeMode(Brightness newThemeMode) async {
    await settingsController.updateThemeMode(newThemeMode);
    await saveSettings();
  }
}
