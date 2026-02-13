import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart'; 

import '../../../domain/entities/user_entity.dart';
import '../../../domain/repositories/auth_repository.dart';
import '../../../core/utils/storage_service.dart';
import '../../../services/auth_service.dart';

class AuthController extends GetxController {
  final AuthRepository _authRepository;
  
  final StorageService _secureStorage = StorageService();
  final _cache = GetStorage(); 
  final AuthService authService = Get.find<AuthService>();
  

  AuthController(this._authRepository);

  final isLoading = false.obs;
  final user = Rx<UserEntity?>(null);
  
  String? _tempToken;

  @override
  void onInit() {
    super.onInit();
    _restoreLocalSession();
  }

  void _restoreLocalSession() {
    final savedUserData = _cache.read('user_data');
    if (savedUserData != null) {
      user.value = UserEntity.fromJson(Map<String, dynamic>.from(savedUserData));
    }
  }

  // MÉTODO ÚNICO PARA SALVAR SESSÃO
  Future<void> _saveAuthSession(UserEntity loggedUser) async {
  // Verifique se o objeto não é nulo antes de prosseguir
  if (loggedUser.id == null) {
    print("ERRO: ID do usuário veio nulo do repositório");
    return;
  }

  if (loggedUser.token != null) {
    await _secureStorage.saveToken(loggedUser.token!);
  }

  // O erro 'Tried to invoke Null' costuma acontecer aqui se toJson() 
  // tentar acessar uma propriedade que não existe no modelo.
  await _cache.write('user_data', loggedUser.toJson());
  await _cache.write('is_logged', true);

  authService.saveUserId(loggedUser.id!);
  user.value = loggedUser;
}

  // LOGIN
  Future<void> login(String email, String password) async {
    try {
      isLoading.value = true;
      final loggedUser = await _authRepository.login(email, password);

      if (loggedUser.id != null) {
        await _saveAuthSession(loggedUser);
        Get.offAllNamed('/home');
      }
    } catch (e) {
      Get.snackbar('Erro', e.toString(), backgroundColor: Colors.orange);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> requestSignUp({
    required String name,
    required String email,
    required String password,
    required String companyName,
    required String managerEmail,
    required bool receiveCopy,
  }) async {
    try {
      isLoading.value = true;

      final userData = {
        'name': name,
        'email': email,
        'password': password,
        'companyName': companyName,
        'managerEmail': managerEmail,
        'receiveCopy': receiveCopy,
      };
      print("antes de chamar o requestSignUp com dados: $userData");
      _tempToken = await _authRepository.requestSignUp(userData);

      Get.toNamed('/verification');
      Get.snackbar("Sucesso", "Verifique seu e-mail para confirmar o código");
    } catch (e) {
      Get.snackbar("Erro no Cadastro", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> confirmCode(String code) async {
    if (_tempToken == null) {
      Get.snackbar("Erro", "Sessão expirada. Tente o cadastro novamente.");
      Get.offAllNamed('/signup');
      return;
    }

    try {
      isLoading.value = true;
      final userEntity = await _authRepository.confirmSignUp(_tempToken!, code);
      await _saveAuthSession(userEntity);
      Get.offAllNamed('/home');
    } catch (e) {
      Get.snackbar("Código Inválido", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void logout() async {
    try {
      await _secureStorage.deleteToken(); 
      await _cache.erase();               
      authService.saveUserId('');
      user.value = null;
      Get.offAllNamed('/login');
    } catch (e) {
      print("Erro ao deslogar: $e");
    }
  }
}