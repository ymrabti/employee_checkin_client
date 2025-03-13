import 'package:dio/dio.dart';

abstract class IWebService {
  final String apiUrl = "http://192.168.8.100:7384/api";
//   final String apiUrl = "https://proxy.youmrabti.com/api";

  Dio getDio();
}
