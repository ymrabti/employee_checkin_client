import "package:faker/faker.dart";
import "package:power_geojson/power_geojson.dart";
import "package:employee_checks/lib.dart";

class EmployeeChecksUser extends IGenericAppModel {
  AuthorizationUser personalInfos;
  AuthorizationTokens tokens;

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

  bool get refreshTokenValid => tokens.refresh.expires.isAfter(DateTime.now().toUtc());

  bool get accessTokenValid => tokens.access.expires.isAfter(DateTime.now().toUtc());

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

  factory EmployeeChecksUser.random() {
    return EmployeeChecksUser(
      personalInfos: AuthorizationUser.random(),
      tokens: AuthorizationTokens.random(),
    );
  }

  factory EmployeeChecksUser.fromJson(Map<String, Object?> json) {
    return EmployeeChecksUser(
      personalInfos: AuthorizationUser.fromJson(json[EmployeeChecksUserEnum.user.name] as Map<String, Object?>),
      tokens: AuthorizationTokens.fromJson(json[EmployeeChecksUserEnum.tokens.name] as Map<String, Object?>),
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

  static Future<EmployeeChecksUser?> loadData(String encryptionKey) async {
    final EmployeeChecksUser? user = (await IGenericAppModel.load<EmployeeChecksUser>(EmployeeChecksUserEnum.user.name, encryptionKey))?.value;
    final AuthorizationTokens? tokens = user?.tokens;
    if (tokens == null || user == null) return null;
    if (user.accessTokenValid) {
      return user;
    } else if (!user.accessTokenValid && user.refreshTokenValid) {
      AuthorizationTokens? newTokens = await EmployeeChecksAuthService().refreshToken(user.tokens.refresh.token);
      if (newTokens == null) return null;
      logg('new TokenModel token expires = ${newTokens.access.expires}');
      EmployeeChecksUser newUser = EmployeeChecksUser(personalInfos: user.personalInfos, tokens: newTokens);
      await newUser.saveUser(encryptionKey);
      return newUser;
    }
    return null;
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

  final String name;

  final String email;

  final String id;
  AuthorizationUser({
    required this.role,
    required this.isEmailVerified,
    required this.name,
    required this.email,
    required this.id,
  });

  AuthorizationUser copyWith({
    String? role,
    bool? isEmailVerified,
    String? name,
    String? email,
    String? id,
  }) {
    return AuthorizationUser(
      role: role ?? this.role,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      name: name ?? this.name,
      email: email ?? this.email,
      id: id ?? this.id,
    );
  }

  Map<String, Object?> toJson() {
    return <String, Object?>{
      UserEnum.role.name: role,
      UserEnum.isEmailVerified.name: isEmailVerified,
      UserEnum.name.name: name,
      UserEnum.email.name: email,
      UserEnum.id.name: id,
    };
  }

  factory AuthorizationUser.fromJson(Map<String, Object?> json) {
    return AuthorizationUser(
      role: json[UserEnum.role.name] as String,
      isEmailVerified: json[UserEnum.isEmailVerified.name] as bool,
      name: json[UserEnum.name.name] as String,
      email: json[UserEnum.email.name] as String,
      id: json[UserEnum.id.name] as String,
    );
  }

  factory AuthorizationUser.random() {
    return AuthorizationUser(
      role: faker.str4,
      isEmailVerified: faker.binary,
      name: faker.fullName,
      email: faker.email1,
      id: faker.str7,
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
        other.name == name && //
        other.email == email && //
        other.id == id;
  }

  @override
  int get hashCode {
    return Object.hash(
      runtimeType,
      role,
      isEmailVerified,
      name,
      email,
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
  name,
  email,
  id,
  none,
}
