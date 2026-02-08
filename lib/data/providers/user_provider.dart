import 'package:get/get.dart';
import '../../core/constants/api_constants.dart'; 

class UserProvider extends GetConnect {
  @override
  void onInit() {
    // Usa a URL base do seu arquivo de constantes
    baseUrl = ApiConstants.baseUrl; 
    
    // Opcional: Configurações extras como timeout
    httpClient.timeout = const Duration(seconds: 20);
    super.onInit();
  }

  Future<Response> getUserProfile(String userId) => get('/users/$userId');

  Future<Response> updateUserProfile(String userId, Map<String, dynamic> data) {
    return put('/users/$userId', data);
  }
}