import 'package:get/get.dart';
import '../../../domain/entities/user_entity.dart';
import '../../../domain/repositories/auth_repository.dart';
import '../../../core/utils/storage_service.dart';
import 'package:flutter/material.dart';
import '../../../services/auth_service.dart';
import 'package:get_storage/get_storage.dart'; // Para o GetStorage

class AuthController extends GetxController {
  final AuthRepository _authRepository;
  final StorageService _storageService = StorageService();
  final AuthService authService = Get.find<AuthService>();

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

        // 4. Atualiza o usuário reativo local
        user.value = loggedUser;

        print("Login realizado com sucesso. ID salvo: ${loggedUser.id}");

        // 5. Vai para a Home limpando a pilha de telas e controllers
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
}