import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WelcomeBottomSheet extends StatelessWidget {
  const WelcomeBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // "Handle" superior para indicar que pode arrastar para baixo
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(height: 25),
          
          // Ícone de Boas-vindas
          const Icon(Icons.rocket_launch_rounded, size: 60, color: Color(0xFF6A11CB)),
          const SizedBox(height: 20),
          
          const Text(
            "Bem-vindo ao HourFlow!",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF1A1C1E)),
          ),
          const SizedBox(height: 12),
          const Text(
            "Sua jornada para uma gestão de horas sem estresse começa agora. Veja o que preparamos para você:",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey, fontSize: 15),
          ),
          const SizedBox(height: 30),

          // Lista de Funcionalidades
          _featureItem(Icons.timer_outlined, "Lançamentos Rápidos", "Registre suas horas diárias em segundos."),
          _featureItem(Icons.auto_graph_outlined, "Cálculos Automáticos", "Esqueça as fórmulas. O sistema faz tudo sozinho."),
          _featureItem(Icons.description_outlined, "Relatórios Prontos", "Gere o fechamento do mês e envie para seu gestor."),

          const SizedBox(height: 30),

          // Botão de Ação
          SizedBox(
            width: double.infinity,
            height: 55,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                gradient: const LinearGradient(colors: [Color(0xFF6A11CB), Color(0xFF2575FC)]),
              ),
              child: ElevatedButton(
                onPressed: () => Get.back(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
                child: const Text(
                  "ESTOU PRONTO!",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _featureItem(IconData icon, String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF2575FC).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: const Color(0xFF2575FC), size: 24),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Text(description, style: const TextStyle(color: Colors.grey, fontSize: 13)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}