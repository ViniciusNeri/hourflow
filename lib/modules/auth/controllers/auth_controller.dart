import 'package:get/get.dart';
import '../../../domain/entities/user_entity.dart';
import '../../../domain/repositories/auth_repository.dart';
import '../../../core/utils/storage_service.dart';
import 'package:flutter/material.dart';
import '../../../services/auth_service.dart';
import 'package:get_storage/get_storage.dart'; 

class AuthController extends GetxController {
  final AuthRepository _authRepository;
  final StorageService _storageService = StorageService();
  final AuthService authService = Get.find<AuthService>();
  String? _tempToken;
  String? _userEmail;


  AuthController(this._authRepository);

  final isLoading = false.obs;
  final user = Rx<UserEntity?>(null);

  Future<void> login(String email, String password) async {
    try {

      isLoading.value = true;
      
      // 1. Chama o repositório
      final loggedUser = await _authRepository.login(email, password);

      if (loggedUser != null && loggedUser.id != null) {
        authService.saveUserId(loggedUser.id!);         
        if (loggedUser.token != null) {
          await _storageService.saveToken(loggedUser.token!);
        }

        user.value = loggedUser;
        
        Get.offAllNamed('/home');
      } else {
        Get.snackbar(
          "Erro de Autenticação", 
          "Usuário ou senha inválidos.",
          backgroundColor: Colors.redAccent,
          colorText: Colors.white
        );
      }
    } catch (e) {
      print("ERRO CRÍTICO NO LOGIN: $e"); 
      Get.snackbar(
        'Erro', 
        'Não foi possível conectar ao servidor.',
        backgroundColor: Colors.orange,
        colorText: Colors.white
      );
    } finally {
      isLoading.value = false;
    }
  }

  void logout() async {
    try {
      // 1. Limpa o ID na memória e no disco
      authService.saveUserId(''); 
      
      // 2. Limpa o token se você usar StorageService
      final storage = GetStorage();
      await storage.remove('token');
      await storage.remove('user_id');

      // 3. Redireciona para o login limpando toda a memória
      Get.offAllNamed('/login');
      
      print("Logout realizado e cache limpo.");
    } catch (e) {
      print("Erro ao deslogar: $e");
    }
  }


   Future<void> requestSignUp(Map<String, dynamic> userData) async {
    try {
      isLoading.value = true;
    //   final response = await http.post(
    //     Uri.parse('https://seu-back.onrender.com/auth/signup'),
    //     headers: {"Content-Type": "application/json"},
    //     body: jsonEncode(userData),
    //   );

    //   final data = jsonDecode(response.body);

    //   if (response.statusCode == 200) {
    //     _tempToken = data['data']['token'];
    //     _userEmail = userData['email'];
        Get.toNamed('/verification'); // Navega para a tela de código
    //   } else {
    //     Get.snackbar("Erro", data['message'] ?? "Falha ao cadastrar");
    //   }
    } catch (e) {
      Get.snackbar("Erro", "Conexão com o servidor falhou");
    } finally {
      isLoading.value = false;
    }
  }

  // ETAPA 2: Confirmar Código
  Future<void> confirmCode(String code) async {
    try {
      isLoading.value = true;
      // final response = await http.post(
      //   Uri.parse('https://seu-back.onrender.com/auth/signup-confirm'),
      //   headers: {"Content-Type": "application/json"},
      //   body: jsonEncode({"token": _tempToken, "code": code}),
      // );

      // if (response.statusCode == 201) {
        Get.offAllNamed('/login'); // Cadastro finalizado!
        Get.snackbar("Sucesso", "Conta criada! Agora você pode logar.");
      // } else {
      //   Get.snackbar("Erro", "Código inválido ou expirado.");
      // }
    } finally {
      isLoading.value = false;
    }
  }
}