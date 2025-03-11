import "package:employee_checks/lib.dart";
import "package:power_geojson/power_geojson.dart";

/*    
{
    "phone": "",
    "operation": "",
    "attempts": 0,
    "next_attempt": 0,
    "last_attemptDate": "2024-12-26T11:09:39.808Z"
}
*/

enum OTP_Oeration {
  regester_or_forgot_password,
  reset_password,
}

class OTP_Verification_Limits extends IGenericAppModel {
  final String phone;

  final OTP_Oeration operation;

  final int attempts;

  final int next_attempt;

  OTP_Verification_Limits({
    required this.phone,
    required this.operation,
    required this.attempts,
    required this.next_attempt,
  });

  Future<void> saveData(String encryptionKey) async {
    await save(savekey, encryptionKey);
  }

  String get savekey => '${phone.replaceAll(' ', '')}.$operation';

  OTP_Verification_Limits copyWith({
    String? phone,
    OTP_Oeration? operation,
    int? attempts,
    int? next_attempt,
    DateTime? last_attemptDate,
  }) {
    return OTP_Verification_Limits(
      phone: phone ?? this.phone,
      operation: operation ?? this.operation,
      attempts: attempts ?? this.attempts,
      next_attempt: next_attempt ?? this.next_attempt,
    );
  }

  @override
  Map<String, Object?> toJson() {
    return <String, Object?>{
      OTP_Verification_LimitsEnum.phone.name: phone,
      OTP_Verification_LimitsEnum.operation.name: operation.name,
      OTP_Verification_LimitsEnum.attempts.name: attempts,
      OTP_Verification_LimitsEnum.next_attempt.name: next_attempt,
    };
  }

  factory OTP_Verification_Limits.fromJson(Map<String, Object?> json) {
    return OTP_Verification_Limits(
      phone: json[OTP_Verification_LimitsEnum.phone.name] as String,
      operation: OTPOeration.find(json[OTP_Verification_LimitsEnum.operation.name] as String),
      attempts: int.parse('${json[OTP_Verification_LimitsEnum.attempts.name]}'),
      next_attempt: int.parse('${json[OTP_Verification_LimitsEnum.next_attempt.name]}'),
    );
  }

  @override
  String toString() {
    return PowerJSON(toJson()).toText();
  }

  @override
  bool operator ==(Object other) {
    return other is OTP_Verification_Limits &&
        other.runtimeType == runtimeType &&
        other.phone == phone && //
        other.operation == operation && //
        other.attempts == attempts && //
        other.next_attempt == next_attempt;
  }

  @override
  int get hashCode {
    return Object.hash(
      runtimeType,
      phone,
      operation,
      attempts,
      next_attempt,
    );
  }
}

enum OTP_Verification_LimitsEnum {
  phone,
  operation,
  attempts,
  next_attempt,
  last_attemptDate,
  none,
}

class OTPScreenArguments {
  final String phoneNumber;
  final String encryptionKey;
  final OTP_Oeration otp_oeration;
  final VoidCallback onSuccess;

  const OTPScreenArguments({
    Key? key,
    required this.onSuccess,
    required this.phoneNumber,
    required this.otp_oeration,
    required this.encryptionKey,
  });

  @override
  bool operator ==(covariant OTPScreenArguments other) {
    if (identical(this, other)) return true;

    return other.phoneNumber == phoneNumber && //
        other.onSuccess == onSuccess &&
        other.encryptionKey == encryptionKey &&
        other.otp_oeration == otp_oeration;
  }

  @override
  int get hashCode =>
      phoneNumber.hashCode ^ //
      onSuccess.hashCode ^
      encryptionKey.hashCode ^
      otp_oeration.hashCode;
}
