import 'package:comchill_app/constants/api_config.dart';
import 'package:dio/dio.dart';

class AuthService {
  static Dio api = ApiConfig.api();

  static Future<Map<String, dynamic>> login(
    String email,
    String password,
  ) async {
    return {};
  }
}
