import 'package:dio/dio.dart';

abstract class IWebService {
  final String apiUrl = "http://195.201.167.74:9195";

  Dio getDio();
}
