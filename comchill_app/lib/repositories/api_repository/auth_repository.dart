import 'package:comchill_app/services/auth_service.dart';

class AuthRepository {

  Future<Map<String, dynamic>> login(String email, String password) async {
    return await AuthService.login(email, password);
  }

}
