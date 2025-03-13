import 'package:employee_checks/lib.dart';
const int SHOW_SCANNED_USER_IN_MELLIS = 5_000;
class EmployeeChecksState extends ChangeNotifier {
  final SettingsController settingsController;
  bool loading = false;
  set load(bool load) {
    loading = load;
    notifyListeners();
  }

  double? percent;

  set changePercent(double? val) {
    percent = val;
    notifyListeners();
  }

  IncomeingQr? _qr;
  IncomeingQr? get qr => _qr;

  set incomingQr(IncomeingQr iqr) {
    _qr = iqr;
    notifyListeners();
  }

  AuthorizationUser? _userScanned;
  AuthorizationUser? get userScanned => _userScanned;

  set incomingUserScan(AuthorizationUser iUser) {
    _userScanned = iUser;
    notifyListeners();
    Future<void>.delayed(
      Duration(milliseconds: SHOW_SCANNED_USER_IN_MELLIS),
      () {
        _userScanned = null;
        notifyListeners();
      },
    );
  }

  Future<void> disconnect() async {
    await user?.removeUser();
    user = null;
    notifyListeners();
  }

  EmployeeChecksUser? user;

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
