import 'package:get/get.dart';
import '../../core/constants/api_constants.dart';

class AuthProvider extends GetConnect {
  @override
  void onInit() {
    baseUrl = ApiConstants.baseUrl; 
    httpClient.timeout = const Duration(seconds: 20);
    super.onInit();
  }

  Future<Response> login(String email, String password) {
    return post('/auth/sessions', {
      'email': email,
      'password': password,
    });
  }

  Future<Response> signUp(Map<String, dynamic> userData) {
    return post('/auth/signup', {
      'name': userData['name'],
      'email': userData['email'],
      'password': userData['password'],
      'companyName': userData['companyName'],
      'managerEmail': userData['managerEmail'],
      'receiveCopy': userData['receiveCopy'],
    });
  }

  Future<Response> confirmSignUp(String token, String code) {
    return post('/auth/signup/confirm', {
      'token': token,
      'code': code,
    });
  }
}