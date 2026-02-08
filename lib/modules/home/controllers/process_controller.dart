import 'package:get/get.dart';

enum ProcessMode { simple, detailed }

class ProcessController extends GetxController {
  // Gerencia qual modo o usuário escolheu
  var processMode = ProcessMode.simple.obs;

  void setMode(ProcessMode mode) => processMode.value = mode;

  // Aqui ficará a lógica de navegação ou envio
  void handleNavigation() {
    if (processMode.value == ProcessMode.simple) {
      // Vai para a tela de preencher mês/horas
      Get.toNamed('/input-simple');
    } else {
      // Vai para a tela de listagem de dias
      Get.toNamed('/input-detailed');
    }
  }
}