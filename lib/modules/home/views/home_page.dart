import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../auth/controllers/auth_controller.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Recuperamos o controller para mostrar os dados do usuário
    final authController = Get.find<AuthController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('HourFlow - Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              authController.logout();
              Get.offAllNamed('/login');
            },
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, size: 80, color: Colors.green),
            const SizedBox(height: 16),
            Text(
              'Bem-vindo,',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            Obx(() => Text(
              authController.user.value?.email ?? 'Usuário',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            )),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              onPressed: () {
                // Futura lógica de envio de planilha
              },
              icon: const Icon(Icons.upload_file),
              label: const Text('Enviar Nova Planilha'),
            ),
          ],
        ),
      ),
    );
  }
}