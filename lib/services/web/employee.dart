import "dart:async";
import "package:dio/dio.dart";
import "package:employee_checks/lib.dart" hide Key;

class EmployeeChecksService extends IWebService {
  final BuildContext context;
  final AuthorizationTokens? auth;

  EmployeeChecksService({
    required this.context,
    required this.auth,
  });
  // ///////////// PUBLIC //////////////////
  // /
  @override
  Dio getDio([String controller = "Employees"]) {
    return Dio(
      BaseOptions(
        baseUrl: '$apiUrl/$controller',
        sendTimeout: Duration(minutes: 1),
        receiveTimeout: Duration(minutes: 2),
        connectTimeout: Duration(minutes: 3),
        validateStatus: (int? status) => true,
      ),
    );
  }

  Future<bool> checkEmployee(String username) async {
    Dio dio = getDio();
    Map<String, String> dataSent = <String, String>{
      UserEnum.username.name: username,
    };
    try {
      Response<void> res = await dio.get(
        '/check',
        queryParameters: dataSent,
      );
      return (res.statusCode == 200);
    } on Exception catch (e) {
      logg(e, 'Exception GetUser');
    }
    return false;
  }

  // ///////////// AUTHORIZED //////////////////

  Future<AuthorizationUser?> getEmployee({required String username}) async {
    Dio dio = getDio();
    Map<String, String> dataSent = <String, String>{
      UserEnum.username.name: username,
    };
    try {
      Response<Map<String, Object?>> res = await dio.get(
        '/search',
        queryParameters: dataSent,
        options: Options(
          headers: <String, Object?>{
            UserEnum.Authorization.name: 'Bearer ${auth?.access.token}',
          },
        ),
      );
      Map<String, Object?>? data = res.data;
      if (res.statusCode == 200) {
        if (data == null) return null;
        return AuthorizationUser.fromJson(<String, Object?>{
          ...data,
          UserEnum.username.name: username,
        });
      }
    } on Exception catch (e) {
      logg(e, 'Exception GetUser');
    }
    return null;
  }

  Future<bool> updateProfile(AuthorizationUser user) async {
    Dio dio = getDio();
    Map<String, Object?> userDataMap = Map<String, Object?>.fromEntries(
      <MapEntry<String, Object?>>[
        ...user.toJson().entries.where(
              (MapEntry<String, Object?> e) => <String>[
                UserEnum.id.name,
                UserEnum.firstName.name,
                UserEnum.lastName.name,
                UserEnum.email.name,
                UserEnum.gender.name,
                UserEnum.dateOfBirth.name,
              ].contains(e.key),
            )
      ],
    );
    try {
      Response<Object?> res = await dio.put(
        '/',
        data: userDataMap,
        options: Options(
          headers: <String, Object?>{
            UserEnum.Authorization.name: 'Bearer ${auth?.access.token}',
          },
        ),
      );
      /* Object? data = res.data;
      logg(data, 'update data'); */
      return res.statusCode == 200;
    } on Exception catch (e) {
      logg(e, 'Exception');
    }

    // AuthorizationUser? user = (await IGenericAppModel.load<AuthorizationUser>(phone))?.value;
    return false;
  }

  Future<bool> changePassword({
    required String oldPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    Dio dio = getDio();
    AuthorizationUser? userConnected = context.read<EmployeeChecksState>().user?.personalInfos;
    String? email = userConnected?.email;
    try {
      Response<Object?> res = await dio.post(
        '/change-password',
        options: Options(
          headers: <String, Object?>{
            UserEnum.Authorization.name: 'Bearer ${auth?.access.token}',
          },
        ),
        data: <String, String?>{
          UserEnum.email.name: email,
          UserEnum.oldPassword.name: oldPassword,
          UserEnum.newPassword.name: newPassword,
          UserEnum.confirmPassword.name: confirmPassword,
        },
      );

      return res.statusCode == 200;
    } on Exception catch (e) {
      logg(e, 'Exception');
      return false;
    }
  }
}

// /api/Transaction/filtered                    // GET
// /api/SharedAccountConroller/{id}             // GET
// /api/reward-assignments/citizen/{citizenId}  // GET
// /api/reward-assignments                      // POST
