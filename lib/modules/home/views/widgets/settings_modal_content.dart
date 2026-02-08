import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/settings_controller.dart';

class SettingsModalContent extends StatelessWidget {
  const SettingsModalContent({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SettingsController>();

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      // O Obx garante que se o isLoading mudar, a tela reage
      child: Obx(() => controller.isLoading.value 
        ? const SizedBox(height: 300, child: Center(child: CircularProgressIndicator()))
        : SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Perfil e Ajustes", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    IconButton(onPressed: () => Get.back(), icon: const Icon(Icons.close)),
                  ],
                ),
                const Divider(),
                const SizedBox(height: 16),

                _buildField("Nome", controller.nameController, Icons.person_outline),
                const SizedBox(height: 16),
                
                _buildField("Empresa", controller.companyController, Icons.business_outlined),
                const SizedBox(height: 16),
                
                _buildField("E-mail do Gestor", controller.managerEmailController, Icons.supervisor_account_outlined),
                const SizedBox(height: 20),

                // Switch para Receber Cópia
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Receber cópia por e-mail", style: TextStyle(fontWeight: FontWeight.w500)),
                      Switch(
                        value: controller.receiveCopy.value,
                        activeColor: const Color(0xFF2575FC),
                        onChanged: (val) => controller.receiveCopy.value = val,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // Botão Salvar
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: () => controller.saveSettings(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2575FC),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    ),
                    child: const Text("SALVAR ALTERAÇÕES", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(height: 16), // Espaço para não colar no teclado
              ],
            ),
          ),
      ),
    );
  }

  Widget _buildField(String label, TextEditingController ctrl, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black54)),
        const SizedBox(height: 8),
        TextField(
          controller: ctrl,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, size: 20),
            filled: true,
            fillColor: Colors.grey[100],
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
          ),
        ),
      ],
    );
  }
}