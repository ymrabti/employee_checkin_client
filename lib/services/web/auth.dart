import "dart:async";
import "package:dio/dio.dart";
import "package:employee_checks/lib.dart" hide Key;
import "package:get/get.dart" hide Response;
// import "package:flutter_windowmanager/flutter_windowmanager.dart";

class EmployeeChecksAuthService extends IWebService {
  @override
  Dio getDio() {
    Dio dio = Dio(
      BaseOptions(
        sendTimeout: Duration(minutes: 1),
        receiveTimeout: Duration(minutes: 2),
        connectTimeout: Duration(minutes: 3),
        baseUrl: '$apiUrl/api/Authentications',
        validateStatus: (int? status) => (status ?? 200) < 499,
      ),
    );
    return dio;
  }

  Future<void> logOut(BuildContext context) async {
    await context.read<EmployeeChecksState>().disconnect();
    Get.offNamedUntil(
      EmployeeChecksLoginPage.route,
      (Route<void> route) => false,
    );
  }

  Future<EmployeeChecksUser?> getuserConnected(String encryptionKey) async {
    IGenericAppMap<EmployeeChecksUser>? iGenericAppMap = await IGenericAppModel.load<EmployeeChecksUser>(EmployeeChecksUserEnum.user.name, encryptionKey);
    EmployeeChecksUser? user = iGenericAppMap?.value;
    return user;
  }

  Future<EmployeeChecksUser?> login(String username, String password, String encryptionKey) async {
    Dio dio = getDio();
    Response<Map<String, Object?>> res = await dio.post(
      '/Login',
      data: <String, String>{
        "numberPhone": username.replaceAll(' ', ''),
        'password': password,
      },
    );
    logg('${res.requestOptions.data}');
    if (res.statusCode == 200) {
      try {
        Map<String, Object?>? data = res.data;
        if (data != null) {
          return EmployeeChecksUser.fromJson(data);
        }
      } on Exception catch (e) {
        logg('$e');
      }
    }
    // EmployeeChecksUser? user = (await IGenericAppModel.load<EmployeeChecksUser>(username))?.value;
    return null;
  }

  Future<bool> resetPassword({
    required String username,
    required String currentPassword,
    required String newPassword,
    required String encryptionKey,
  }) async {
    Dio dio = getDio();
    try {
      Response<void> res = await dio.post(
        '/ChangePassword',
        data: <String, String>{
          "username": username,
          "currentPassword": currentPassword,
          "newPassword": newPassword,
        },
      );

      return res.statusCode == 200;
    } on Exception catch (e) {
      logg(e);
      return false;
    }
  }

  Future<AuthorizationTokens?> refreshToken(String refreshToken) async {
    Dio dio = getDio();
    Response<Map<String, Object?>> res = await dio.post(
      '/refresh-tokens',
      data: <String, String?>{
        'refreshToken': refreshToken,
      },
    );
    if (res.statusCode != 200) {
      return null;
    }
    Map<String, Object?>? data = res.data;
    if (data == null) {
      return null;
    }
    AuthorizationTokens userAuth = AuthorizationTokens.fromJson(data);
    return userAuth;
  }

  Future<EmployeeChecksUser?> register({
    required String username,
    required String password,
    required String firstName,
    required String lastName,
    required String confirmPassword,
    required String encryptionKey,
  }) async {
    Dio dio = getDio();
    Response<Map<String, Object?>> res = await dio.post(
      '/RegisterCitizen',
      data: <String, Object>{
        "username": username.replaceAll(' ', ''),
        'password': password,
        "confirmPassword": confirmPassword,
        "adresseId": "6f1e6050-4e88-4852-9fc1-1a95eddc2fec",
        "userRoles": <String>["Citizen"]
      },
    );
    if (res.statusCode == 200) {
      try {
        Map<String, Object?>? data = res.data;
        if (data == null) return null;
        return EmployeeChecksUser.fromJson(data);
      } on Exception catch (e) {
        logg('$e');
      }
    }
    return null;
  }

  Future<void> redirectAfterAuth({
    required BuildContext context,
    required AuthorizationTokens tokens,
    required String username,
    required String route,
  }) async {
    await context.read<EmployeeChecksState>().showTutorial(false);
    context.read<EmployeeChecksState>().load = false;
    EmployeeChecksService citizenService = EmployeeChecksService(context: context, auth: tokens);
    AuthorizationUser? personalInfos = await citizenService.getCitizen(username: username);
    //

    if (personalInfos != null) {
      EmployeeChecksUser? user = EmployeeChecksUser(tokens: tokens, personalInfos: personalInfos);
      context.setUserConnected(user, signalR: true);
      context.read<EmployeeChecksRealtimeState>().updateSocket(user: user);
      await Get.offNamedUntil(route, (Route<void> route) => false);
    } else {
      context.hideCurrentAndShowSnackbar(
        SnackBar(
          content: Text(context.tr.invalidFormText),
        ),
      );
    }
  }
}
