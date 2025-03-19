import "dart:async";
import "dart:io";
import "package:dio/dio.dart";
import "package:employee_checks/lib.dart" hide Key;
import "package:get/get.dart" hide Response, FormData, MultipartFile;
// import "package:flutter_windowmanager/flutter_windowmanager.dart";

class EmployeeChecksAuthService extends IWebService {
  @override
  Dio getDio() {
    Dio dio = Dio(
      BaseOptions(
        sendTimeout: Duration(minutes: 1),
        receiveTimeout: Duration(minutes: 2),
        connectTimeout: Duration(minutes: 3),
        baseUrl: '$apiUrl/api/Auth',
        validateStatus: (int? status) => (status ?? 200) < 499,
      ),
    );
    return dio;
  }

  Future<EmployeeChecksUser?> getuserConnected(String encryptionKey) async {
    IGenericAppMap<EmployeeChecksUser>? iGenericAppMap = await IGenericAppModel.load<EmployeeChecksUser>(EmployeeChecksUserEnum.user.name, encryptionKey);
    EmployeeChecksUser? user = iGenericAppMap?.value;
    return user;
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
          UserEnum.username.name: username,
          UserEnum.currentPassword.name: currentPassword,
          UserEnum.newPassword.name: newPassword,
        },
      );

      return res.statusCode == 200;
    } on Exception catch (e) {
      logg(e);
      return false;
    }
  }

  Future<AuthorizationTokens?> refreshToken(AuthorizationTokens? tokens) async {
    if (tokens == null) return tokens;
    if (tokens.accessTokenValid) return tokens;
    if (!tokens.accessTokenValid && tokens.refreshTokenValid) {
      Dio dio = getDio();
      Response<Map<String, Object?>> res = await dio.post(
        '/refresh-tokens',
        data: <String, String?>{
          UserEnum.refreshToken.name: tokens.refresh.token,
        },
        options: Options(
          headers: <String, Object?>{
            UserEnum.Authorization.name: 'Bearer ${tokens.access.token}',
          },
        ),
      );
      if (res.statusCode != 200) {
        return null;
      }
      Map<String, Object?>? data = res.data;
      if (data == null) {
        return null;
      }
      return AuthorizationTokens.fromJson(data);
      /* EmployeeChecksUser newUser = EmployeeChecksUser(personalInfos: user.personalInfos, tokens: newTokens);
      await newUser.saveUser(encryptionKey);
      return newUser; */
    }
    return null;
  }

  // //////////////////////// /////////////////////////

  Future<EmployeeChecksUser?> register({
    required Map<String, Object?>? data,
  }) async {
    Dio dio = getDio();
    if (data == null) return null;
    FormData formData = FormData.fromMap(data);
    Response<Map<String, Object?>> res = await dio.post(
      '/Register',
      data: formData,
      options: Options(
        headers: <String, Object?>{"Content-Type": "multipart/form-data"},
      ),
    );

    if (res.statusCode == 201) {
      try {
        Map<String, Object?>? data = res.data;
        if (data == null) return null;
        return EmployeeChecksUser.fromJson(data);
      } on Exception catch (e) {
        logg(e);
        return null;
      }
    }
    return null;
  }

  Future<EmployeeChecksUser?> login(String username, String password, String encryptionKey) async {
    Dio dio = getDio();
    Response<Map<String, Object?>> res = await dio.post(
      '/Login',
      data: <String, String>{
        UserEnum.username.name: username,
        UserEnum.password.name: password,
      },
    );
    if (res.statusCode == 200) {
      try {
        Map<String, Object?>? data = res.data;
        if (data != null) {
          return EmployeeChecksUser.fromJson(data);
        }
      } on Exception catch (e) {
        logg(e);
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
    AuthorizationUser? personalInfos = await citizenService.getEmployee(username: username);
    //

    if (personalInfos != null) {
      EmployeeChecksUser user = EmployeeChecksUser(tokens: tokens, personalInfos: personalInfos);
      File file = await downloadImage(user, user.personalInfos.photoo);
      EmployeeChecksUser copyWith = user.copyWith(personalInfos: personalInfos.copyWith(imageSavedIn: file.path));
      context.setUserConnected(copyWith);
      context.read<EmployeeChecksRealtimeState>().updateSocket(tokens: copyWith.tokens);
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
