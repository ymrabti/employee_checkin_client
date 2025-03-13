import 'package:dio/dio.dart';
import 'package:power_geojson/power_geojson.dart';

abstract class IWebService {
  final String apiUrl = AppPlatform.isPhone ? 'https://proxy.youmrabti.com' : 'http://localhost:7384';
//   final String apiUrl = "https://proxy.youmrabti.com/api";

  Dio getDio();
}
