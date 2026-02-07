import 'package:get/get.dart';
import '../../../domain/entities/user_entity.dart';
import '../../../domain/repositories/auth_repository.dart';
import '../../../core/utils/storage_service.dart';
import 'package:flutter/material.dart';

class AuthController extends GetxController {
  final AuthRepository _authRepository;
  final StorageService _storageService = StorageService();

  AuthController(this._authRepository);

  // Estados Reativos (.obs do Antigravity)
  final isLoading = false.obs;
  final user = Rx<UserEntity?>(null);
  final errorMessage = Rx<String?>(null);

  Future<void> login(String email, String password) async {
  try {
    isLoading.value = true;
    final loggedUser = await _authRepository.login(email, password);
    
    await _storageService.saveToken(loggedUser.token);
    user.value = loggedUser;

    Get.offAllNamed('/home');

  } catch (e) {
    print("ERRO NO LOGIN: $e"); // RASTREIO DE ERRO
    Get.snackbar('Erro', e.toString());
  } finally {
    isLoading.value = false;
  }
}

  void logout() {
    user.value = null;
    _authRepository.logout();
  }
}