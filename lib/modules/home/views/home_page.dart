import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/process_controller.dart';
import '../controllers/settings_controller.dart';
import 'widgets/settings_modal_content.dart';
import '../../auth/controllers/auth_controller.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  // Iniciamos os controllers necessários
  // O put aqui garante que o ProcessController exista nesta tela
  final controller = Get.put(ProcessController());
  
  // O find busca o SettingsController que já injetamos no main.dart
  final settingsCtrl = Get.find<SettingsController>();

  @override
  Widget build(BuildContext context) {
    // IMPORTANTE: Sempre que a Home for construída (após login), 
    // garantimos que os dados do usuário logado sejam carregados.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      settingsCtrl.loadUserData();
    });

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text("HourFlow", 
          style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [              
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
              icon: const Icon(Icons.settings_outlined, color: Color(0xFF2575FC), size: 28),
              onPressed: () {
                // Antes de abrir o modal, garantimos que os dados estão atualizados
                settingsCtrl.loadUserData();
                _showSettingsModal(context);
              },
            ),
          ),
          IconButton(
                icon: const Icon(Icons.logout, color: Colors.redAccent),
                onPressed: () {
                  Get.defaultDialog(
                    title: "Sair",
                    middleText: "Deseja realmente sair da conta?",
                    backgroundColor: Colors.white,
                    titleStyle: const TextStyle(color: Color(0xFF2575FC), fontWeight: FontWeight.bold),
                    middleTextStyle: const TextStyle(color: Color(0xFF2575FC)),
                    textConfirm: "SIM",
                    textCancel: "NÃO",
                    confirmTextColor: Colors.white,
                    buttonColor: Colors.redAccent,
                    onConfirm: () {
                      Get.find<AuthController>().logout();
                    },
                  );
                },
              ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Column(
              children: [
                // Header de Boas-vindas dinâmico com Obx
                Obx(() => Column(
                  children: [
                    const CircleAvatar(
                      radius: 30,
                      backgroundColor: Color(0xFF2575FC),
                      child: Icon(Icons.bolt, color: Colors.white, size: 35),
                    ),
                    const SizedBox(height: 16),
                    // Se estiver carregando, mostra um shimmer ou texto genérico
                    if (settingsCtrl.isLoading.value)
                      const SizedBox(
                        height: 20, 
                        width: 20, 
                        child: CircularProgressIndicator(strokeWidth: 2)
                      )
                    else ...[
                      Text(
                        "Olá, ${settingsCtrl.userName.value}!",
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                      ),
                      Text(
                        settingsCtrl.userCompany.value,
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      ),
                    ],
                  ],
                )),
                
                const SizedBox(height: 40),
                const Text(
                  "Como deseja processar as horas?",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 20),

                // Opções de Seleção
                Obx(() => Column(
                  children: [
                    _buildOptionCard(
                      title: "Mês e Horas",
                      subtitle: "Envio rápido do total mensal",
                      icon: Icons.access_time_filled,
                      mode: ProcessMode.simple,
                      isSelected: controller.processMode.value == ProcessMode.simple,
                    ),
                    const SizedBox(height: 12),
                    _buildOptionCard(
                      title: "Verificar Lista de Dias",
                      subtitle: "Confira e processe dia por dia",
                      icon: Icons.calendar_view_day,
                      mode: ProcessMode.detailed,
                      isSelected: controller.processMode.value == ProcessMode.detailed,
                    ),
                  ],
                )),

                const SizedBox(height: 40),

                // Botão de Ação
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: () => controller.handleNavigation(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2575FC),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 0,
                    ),
                    child: const Text(
                      "CONTINUAR",
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOptionCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required ProcessMode mode,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () => controller.setMode(mode),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? const Color(0xFF2575FC) : Colors.grey.shade300,
            width: 2,
          ),
          boxShadow: isSelected 
              ? [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))] 
              : [],
        ),
        child: Row(
          children: [
            Icon(icon, color: isSelected ? const Color(0xFF2575FC) : Colors.grey),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, 
                    style: TextStyle(
                      fontWeight: FontWeight.bold, 
                      color: isSelected ? const Color(0xFF2575FC) : Colors.black87
                    )
                  ),
                  Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                ],
              ),
            ),
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_off, 
              color: isSelected ? const Color(0xFF2575FC) : Colors.grey
            ),
          ],
        ),
      ),
    );
  }

  void _showSettingsModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: const SettingsModalContent(), // Adicionei 'const' para performance
      ),
    );
  }
}