import "dart:io";

import "package:faker/faker.dart";
import "package:image_picker/image_picker.dart";
import "package:power_geojson/power_geojson.dart";
import "package:employee_checks/lib.dart";

enum EmployeeChecksUserRoles {
  user,
  fieldWorker,
  manager,
  admin,
}

class EmployeeChecksUser extends IGenericAppModel {
  AuthorizationUser personalInfos;
  AuthorizationTokens tokens;
  String get fullName => personalInfos.fullName;

  EmployeeChecksUser({
    required this.personalInfos,
    required this.tokens,
  });

  Future<void> saveUser(String encryptionKey) async {
    await save(EmployeeChecksUserEnum.user.name, encryptionKey);
  }

  Future<void> removeUser() async {
    await remove(EmployeeChecksUserEnum.user.name);
  }

  Map<String, String> get headers => <String, String>{
        UserEnum.Authorization.name: 'Bearer ${tokens.access.token}',
      };
  EmployeeChecksUser copyWith({
    AuthorizationUser? personalInfos,
    AuthorizationTokens? tokens,
  }) {
    return EmployeeChecksUser(
      personalInfos: personalInfos ?? this.personalInfos,
      tokens: tokens ?? this.tokens,
    );
  }

  @override
  Map<String, Object?> toJson() {
    return <String, Object?>{
      EmployeeChecksUserEnum.user.name: personalInfos.toJson(),
      EmployeeChecksUserEnum.tokens.name: tokens.toJson(),
    };
  }

  factory EmployeeChecksUser.fromJson(Map<String, Object?> json) {
    Map<String, Object?> jsonTokens = json[EmployeeChecksUserEnum.tokens.name] as Map<String, Object?>;
    return EmployeeChecksUser(
      personalInfos: AuthorizationUser.fromJson(json[EmployeeChecksUserEnum.user.name] as Map<String, Object?>),
      tokens: AuthorizationTokens.fromJson(jsonTokens),
    );
  }

  @override
  String toString() {
    return PowerJSON(toJson()).toText();
  }

  @override
  bool operator ==(Object other) {
    return other is EmployeeChecksUser &&
        other.runtimeType == runtimeType &&
        other.personalInfos == personalInfos && //
        other.tokens == tokens;
  }

  @override
  int get hashCode {
    return Object.hash(
      runtimeType,
      personalInfos,
      tokens,
    );
  }
}

class AuthorizationTokens {
  final TokenModel access;

  final TokenModel refresh;
  AuthorizationTokens({
    required this.access,
    required this.refresh,
  });

  AuthorizationTokens copyWith({
    TokenModel? access,
    TokenModel? refresh,
  }) {
    return AuthorizationTokens(
      access: access ?? this.access,
      refresh: refresh ?? this.refresh,
    );
  }

  bool get refreshTokenValid => refresh.expires.isAfter(DateTime.now().toUtc());

  bool get accessTokenValid => access.expires.isAfter(DateTime.now().toUtc());

  Map<String, Object?> toJson() {
    return <String, Object?>{
      TokensEnum.access.name: access.toJson(),
      TokensEnum.refresh.name: refresh.toJson(),
    };
  }

  factory AuthorizationTokens.fromJson(Map<String, Object?> json) {
    return AuthorizationTokens(
      access: TokenModel.fromJson(json[TokensEnum.access.name] as Map<String, Object?>),
      refresh: TokenModel.fromJson(json[TokensEnum.refresh.name] as Map<String, Object?>),
    );
  }

  factory AuthorizationTokens.random() {
    return AuthorizationTokens(
      access: TokenModel.random(),
      refresh: TokenModel.random(),
    );
  }

  @override
  String toString() {
    return PowerJSON(toJson()).toText();
  }

  @override
  bool operator ==(Object other) {
    return other is AuthorizationTokens &&
        other.runtimeType == runtimeType &&
        other.access == access && //
        other.refresh == refresh;
  }

  @override
  int get hashCode {
    return Object.hash(
      runtimeType,
      access,
      refresh,
    );
  }
}

class TokenModel {
  final String token;

  final DateTime expires;
  TokenModel({
    required this.token,
    required this.expires,
  });

  TokenModel copyWith({
    String? token,
    DateTime? expires,
  }) {
    return TokenModel(
      token: token ?? this.token,
      expires: expires ?? this.expires,
    );
  }

  Map<String, Object?> toJson() {
    return <String, Object?>{
      TokenModelEnum.token.name: token,
      TokenModelEnum.expires.name: expires.toIso8601String(),
    };
  }

  factory TokenModel.fromJson(Map<String, Object?> json) {
    return TokenModel(
      token: json[TokenModelEnum.token.name] as String,
      expires: DateTime.parse('${json[TokenModelEnum.expires.name]}'),
    );
  }

  factory TokenModel.random() {
    return TokenModel(
      token: faker.str5,
      expires: faker.dateTime,
    );
  }

  @override
  String toString() {
    return PowerJSON(toJson()).toText();
  }

  @override
  bool operator ==(Object other) {
    return other is TokenModel &&
        other.runtimeType == runtimeType &&
        other.token == token && //
        other.expires == expires;
  }

  @override
  int get hashCode {
    return Object.hash(
      runtimeType,
      token,
      expires,
    );
  }
}

class AuthorizationUser {
  final String role;

  final bool isEmailVerified;

  final String firstName;

  final String lastName;

  final String username;

  final String email;

  final String photo;

  String imageSavedIn;
  final String id;
  AuthorizationUser({
    required this.role,
    required this.isEmailVerified,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.username,
    required this.id,
    required this.photo,
    this.imageSavedIn = '',
  });

  String get fullName => '$firstName $lastName';
  AuthorizationUser copyWith({
    required String path,
    bool? isEmailVerified,
    String? firstName,
    String? lastName,
    String? username,
    String? email,
    String? photo,
    String? role,
    String? id,
  }) {
    return AuthorizationUser(
      role: role ?? this.role,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      username: username ?? this.username,
      photo: photo ?? this.photo,
      id: id ?? this.id,
      imageSavedIn: path,
    );
  }

  Widget get imageWidget {
    return Builder(
      builder: (BuildContext context) {
        return ImagedNetwork(
          url: photoo,
          headers: context.watch<EmployeeChecksState>().user?.headers,
        );
      },
    );
  }

  String savePath(String directoryPath) {
    String dir = '$directoryPath\\Employees\\$username';
    if (!Directory(dir).existsSync()) Directory(dir).createSync(recursive: true);
    // return '$dir/${basename(photo)}';
    return dir;
  }

  String get photoo => '${EmployeeChecksAuthService().apiUrl}/api/Employees/photo/$username';

  Map<String, Object?> toJson() {
    return <String, Object?>{
      UserEnum.role.name: role,
      UserEnum.isEmailVerified.name: isEmailVerified,
      UserEnum.firstName.name: firstName,
      UserEnum.lastName.name: lastName,
      UserEnum.email.name: email,
      UserEnum.id.name: id,
      UserEnum.photo.name: imageSavedIn,
      UserEnum.username.name: username,
    };
  }

  Map<String, Object?> toMap() {
    return <String, Object?>{
      UserEnum.role.name: role,
      UserEnum.isEmailVerified.name: isEmailVerified,
      UserEnum.firstName.name: firstName,
      UserEnum.lastName.name: lastName,
      UserEnum.email.name: email,
      UserEnum.id.name: id,
      UserEnum.photo.name: XFile(imageSavedIn),
      UserEnum.username.name: username,
    };
  }

  factory AuthorizationUser.fromJson(Map<String, Object?> json) {
    return AuthorizationUser(
      role: json[UserEnum.role.name] as String,
      isEmailVerified: json[UserEnum.isEmailVerified.name] as bool,
      firstName: json[UserEnum.firstName.name] as String,
      lastName: json[UserEnum.lastName.name] as String,
      email: json[UserEnum.email.name] as String,
      username: json[UserEnum.username.name] as String,
      id: json[UserEnum.id.name] as String,
      photo: (json[UserEnum.photo.name] as String?) ?? '',
    );
  }

  factory AuthorizationUser.random() {
    return AuthorizationUser(
      role: faker.str4,
      isEmailVerified: faker.binary,
      firstName: faker.person.firstName(),
      lastName: faker.person.lastName(),
      username: faker.internet.userName(),
      email: faker.email1,
      id: faker.str7,
      photo: faker.image.loremPicsum(width: 480),
    );
  }

  @override
  String toString() {
    return PowerJSON(toJson()).toText();
  }

  @override
  bool operator ==(Object other) {
    return other is AuthorizationUser &&
        other.runtimeType == runtimeType &&
        other.role == role && //
        other.isEmailVerified == isEmailVerified && //
        other.firstName == firstName && //
        other.lastName == lastName && //
        other.username == username && //
        other.email == email && //
        other.photo == photo && //
        other.id == id;
  }

  @override
  int get hashCode {
    return Object.hash(
      runtimeType,
      role,
      isEmailVerified,
      firstName,
      lastName,
      username,
      email,
      photo,
      id,
    );
  }
}

enum TokenModelEnum {
  token,
  expires,
  none,
}

enum TokensEnum {
  access,
  refresh,
  none,
}

enum EmployeeChecksUserEnum {
  user,
  tokens,
  none,
}

enum UserEnum {
  role,
  isEmailVerified,
  firstName,
  email,
  id,
  none,
  photo,
  lastName,
  username,
  phoneNumber,
  password,
  confirmPassword,
  currentPassword,
  newPassword,
  refreshToken,
  Authorization,
  gender,
  dateOfBirth,
  oldPassword,
  Qr,
}
