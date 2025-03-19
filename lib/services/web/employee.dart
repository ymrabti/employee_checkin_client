import 'dart:io';

import 'package:dio/dio.dart';
import 'package:employee_checks/lib.dart';
import 'package:faker/faker.dart';
import 'package:path_provider/path_provider.dart';
import "dart:async";
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
        baseUrl: '$apiUrl/api/$controller',
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

  Future<AuthorizationUser?> scanNow({required String qr}) async {
    Dio dio = getDio('ScanNow');
    Map<String, String> dataSent = <String, String>{
      UserEnum.Qr.name: qr,
    };
    try {
      Response<Map<String, Object?>> res = await dio.post(
        '/scan',
        data: dataSent,
        options: Options(
          headers: <String, Object?>{
            UserEnum.Authorization.name: 'Bearer ${auth?.access.token}',
          },
        ),
      );
      Map<String, Object?>? data = res.data;

      if (data == null) return null;
      if (res.statusCode == 200) {
        return AuthorizationUser.fromJson(data);
      }
    } on Exception catch (e) {
      logg(e, 'scan_result');
    }
    return null;
  }

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

  Future<UploadPhotoResponse?> updateProfilePicture(MultipartFile file) async {
    Dio dio = getDio();
    EmployeeChecksUser? user = context.read<EmployeeChecksState>().user;
    Response<Map<String, Object?>> res = await dio.post(
      '/photo/${user?.personalInfos.username}',
      data: FormData.fromMap(<String, Object?>{
        UserEnum.photo.name: file,
      }),
      options: Options(
        headers: <String, Object?>{
          "Content-Type": "multipart/form-data",
          UserEnum.Authorization.name: 'Bearer ${auth?.access.token}',
        },
      ),
    );

    if (res.statusCode == 200) {
      try {
        Map<String, Object?>? data = res.data;
        if (data == null) return null;
        UploadPhotoResponse uploadPhotoResponse = UploadPhotoResponse.fromJson(data);
        logg(uploadPhotoResponse.file.filename, 'upload_photo_response');
        return uploadPhotoResponse;
      } on Exception catch (e) {
        logg(e);
        return null;
      }
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

Future<File> downloadImage(EmployeeChecksUser user, String url, [String? filename]) async {
  Directory appDirectory = await getApplicationDocumentsDirectory();
  String path = user.personalInfos.savePath(appDirectory.path);
  Dio dio = Dio();

  Response<ResponseBody> response = await dio.get<ResponseBody>(
    url,
    options: Options(responseType: ResponseType.stream, headers: user.headers),
  );
  // Extract filename from headers
  String? contentDisposition = response.headers.value('content-disposition');
  String fileName = "default.jpg";

  if (contentDisposition != null && contentDisposition.contains('filename=')) {
    final String? fn = _extractFilename(contentDisposition);
    // final int? size = _extractSize(contentDisposition);
    fileName = fn ?? '';
  } else {
    // Extract from URL if header is missing
    fileName = filename ?? '${faker.id}jpg';
  }
  String savePath = "$path\\$fileName";
  File file = File(savePath);
  if (file.existsSync()) return file;
  await dio.download(
    url,
    savePath,
    options: Options(headers: user.headers),
  );

  logg("Downloaded: $fileName");
  return File(savePath);
}

// Function to extract filename from Content-Disposition header
String? _extractFilename(String contentDisposition) {
  final RegExp regex = RegExp(r'filename="([^"]+)"');
  final RegExpMatch? match = regex.firstMatch(contentDisposition);
  return match?.group(1);
}

// Function to extract size from Content-Disposition header
int? extractSize(String contentDisposition) {
  final RegExp regex = RegExp(r'size=(\d+)');
  final RegExpMatch? match = regex.firstMatch(contentDisposition);
  return match != null ? int.tryParse(match.group(1)!) : null;
}
