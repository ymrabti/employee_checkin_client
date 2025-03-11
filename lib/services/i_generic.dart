import 'dart:convert';
import 'package:employee_checks/lib.dart';
import 'package:power_geojson/power_geojson.dart';

enum IGenricEnry {
  datetime,
  value,
}

class IGenericAppMap<T extends IGenericAppModel> {
  final DateTime dateTime;
  final T? value;
  IGenericAppMap({
    required this.dateTime,
    this.value,
  });
  static IGenericAppMap<T> fromJson<T extends IGenericAppModel>(Map<String, Object?> map) {
    IGenericAppMap<T> iGenericAppMap = IGenericAppMap<T>(
      dateTime: DateTime.fromMillisecondsSinceEpoch(
        map[IGenricEnry.datetime.name] as int,
      ),
      value: IGenericAppModel.fromJson<T>(
        map[IGenricEnry.value.name] as Map<String, Object?>,
      ) as T?,
    );
    return iGenericAppMap;
  }
}

abstract class IGenericAppModel {
  Future<void> save(String name, String encryptionKey) async {
    String textSaved = PowerJSON(
      Map<String, Object?>.fromEntries(
        <MapEntry<String, Object?>>[
          MapEntry<String, Object?>(
            IGenricEnry.datetime.name,
            DateTime.now().millisecondsSinceEpoch,
          ),
          MapEntry<String, Object?>(
            IGenricEnry.value.name,
            toJson(),
          ),
        ],
      ),
    ).toText();

    await EmployeeChecksLocalServices.saveEncrypted(key: name, value: textSaved, encryptionKey: encryptionKey);
  }

  static Future<IGenericAppMap<T>?> load<T extends IGenericAppModel>(
    String name,
    String encryptionKey,
  ) async {
    String? string = await EmployeeChecksLocalServices.loadEncrypted(key: name, encryptionKey: encryptionKey);
    if (string == null) return null;
    Map<String, Object?> json = jsonDecode(string);
    return IGenericAppMap.fromJson<T>(json);
  }

  Map<String, Object?> toJson();

  static IGenericAppModel? fromJson<T extends IGenericAppModel>(Map<String, Object?> json) {
    if (T == Settings) return Settings.fromJson(json);
    if (T == OTP_Verification_Limits) return OTP_Verification_Limits.fromJson(json);
    if (T == EmployeeChecksUser) return EmployeeChecksUser.fromJson(json);
    return null;
  }

  Future<void> remove<T extends IGenericAppModel>(String name) async {
    await EmployeeChecksLocalServices.remove(key: name);
  }
}
