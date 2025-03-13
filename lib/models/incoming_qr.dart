import "package:power_geojson/power_geojson.dart";

class IncomeingQr {
  final String qr;

  final DateTime generated;

  final int lifecyle_in_seconds;
  IncomeingQr({
    required this.qr,
    required this.generated,
    required this.lifecyle_in_seconds,
  });

  IncomeingQr copyWith({
    String? qr,
    DateTime? generated,
    int? lifecyle_in_seconds,
  }) {
    return IncomeingQr(
      qr: qr ?? this.qr,
      generated: generated ?? this.generated,
      lifecyle_in_seconds: lifecyle_in_seconds ?? this.lifecyle_in_seconds,
    );
  }

  Map<String, Object?> toJson() {
    return <String, Object?>{
      IncomeingQrEnum.qr.name: qr,
      IncomeingQrEnum.generated.name: generated,
      IncomeingQrEnum.lifecyle_in_seconds.name: lifecyle_in_seconds,
    };
  }

  factory IncomeingQr.fromJson(Map<String, Object?> json) {
    Object? json2 = json[IncomeingQrEnum.generated.name];
    return IncomeingQr(
      qr: json[IncomeingQrEnum.qr.name] as String,
      generated: DateTime.parse('$json2').toLocal(),
      lifecyle_in_seconds: int.parse('${json[IncomeingQrEnum.lifecyle_in_seconds.name]}'),
    );
  }

  factory IncomeingQr.fromMap(Map<String, Object?> json, {String? id}) {
    return IncomeingQr(
      qr: json[IncomeingQrEnum.qr.name] as String,
      generated: json[IncomeingQrEnum.generated.name] as DateTime,
      lifecyle_in_seconds: json[IncomeingQrEnum.lifecyle_in_seconds.name] as int,
    );
  }

  @override
  String toString() {
    return PowerJSON(toJson()).toText();
  }

  @override
  bool operator ==(Object other) {
    return other is IncomeingQr &&
        other.runtimeType == runtimeType &&
        other.qr == qr && //
        other.generated == generated && //
        other.lifecyle_in_seconds == lifecyle_in_seconds;
  }

  @override
  int get hashCode {
    return Object.hash(
      runtimeType,
      qr,
      generated,
      lifecyle_in_seconds,
    );
  }
}

enum IncomeingQrEnum {
  qr,
  generated,
  lifecyle_in_seconds,
  none,
}

extension IncomeingQrSort on List<IncomeingQr> {
  List<IncomeingQr> sorty(IncomeingQrEnum caseField, {bool desc = false}) {
    return this
      ..sort((IncomeingQr a, IncomeingQr b) {
        int fact = (desc ? 1 : -1);

        if (caseField == IncomeingQrEnum.qr) {
          // unsortable

          String akey = a.qr;
          String bkey = b.qr;

          return fact * (bkey.compareTo(akey));
        }
        if (caseField == IncomeingQrEnum.generated) {
          // unsortable

          DateTime akey = a.generated;
          DateTime bkey = b.generated;

          return fact * bkey.compareTo(akey);
        }
        if (caseField == IncomeingQrEnum.lifecyle_in_seconds) {
          // unsortable

          int akey = a.lifecyle_in_seconds;
          int bkey = b.lifecyle_in_seconds;

          return fact * (bkey - akey);
        }

        return 0;
      });
  }
}
