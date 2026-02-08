import 'package:get/get.dart';
import '../../../data/repositories/user_repository.dart';
import '../../../data/models/user_model.dart';
import '../../../services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart'; // Para o GetStorage
import '../../../core/constants/api_constants.dart'; // Para o ApiConstants (ajuste o caminho se necessário)


class SettingsController extends GetxController {

  final UserRepository repository;
  SettingsController(this.repository);

  var isLoading = false.obs;
  
  var userName = "Carregando...".obs;
  var userCompany = "Carregando...".obs;

  // Controllers dos campos de texto (para o Modal)
  final nameController = TextEditingController();
  final companyController = TextEditingController();
  final managerEmailController = TextEditingController();
  final AuthService authService = Get.find<AuthService>();

  
  var receiveCopy = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadUserData();
  }

  void loadUserData() async {
    isLoading.value = true;

    final id = authService.userId;
  
    if (id.isEmpty) {
      print("ERRO: Tentativa de carregar dados sem um ID de usuário!");
      return;
    }
    try {
      final user = await repository.getUser(authService.userId);

            if (user != null) {
              userName.value = user.name;
              userCompany.value = user.companyName;
              nameController.text = user.name;
              companyController.text = user.companyName;
              managerEmailController.text = user.managerEmail;
              receiveCopy.value = user.receiveCopy;
            }else{
              print("DEBUG: O objeto user veio NULO do repository");
            }
          } finally {
            isLoading.value = false;
          }
      }
 

 void saveSettings() async {
  isLoading.value = true;

  try {
   
    final updatedUser = UserModel(
      id: authService.userId,
      name: nameController.text.trim(),      
      companyName: companyController.text.trim(),
      email: "",
      managerEmail: managerEmailController.text.trim(),
      receiveCopy: receiveCopy.value,
      token: "",
    );

    // 3. Chama o Repository para fazer o PUT no Render
    final success = await repository.update(authService.userId, updatedUser);

    if (success) {
      // 4. Se o banco respondeu OK (200), atualizamos a UI da Home
      userName.value = updatedUser.name;
      userCompany.value = updatedUser.companyName;

      Get.back(); // Fecha o modal de configurações
      
      Get.snackbar(
        "Sucesso", 
        "Perfil atualizado no banco de dados!",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        margin: const EdgeInsets.all(15),
        duration: const Duration(seconds: 3),
      );
    } else {
      Get.snackbar("Erro", "O servidor não conseguiu salvar as alterações.");
    }
  } catch (e) {
    // Caso ocorra erro de conexão ou timeout
    Get.snackbar(
      "Erro de Conexão", 
      "Não foi possível alcançar o servidor. Verifique sua internet.",
      backgroundColor: Colors.redAccent,
      colorText: Colors.white,
    );
    print("Erro ao salvar: $e");
  } finally {
    // 5. Finaliza o estado de carregamento
    isLoading.value = false;
  }
}
}