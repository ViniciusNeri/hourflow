import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../spreadsheet/controllers/spreadsheet_controller.dart';

class SimpleInputPage extends StatelessWidget {
  const SimpleInputPage({super.key});

  @override
  Widget build(BuildContext context) {

    final controller = Get.put(SpreadSheetController(Get.find()));

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text("Envio Simples",
            style: TextStyle(color: Color(0xFF1E293B), fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20),
          onPressed: () => Get.back(),
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Container(
            margin: const EdgeInsets.all(24),
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                )
              ],
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: Icon(Icons.bolt, size: 40, color: Color(0xFF2575FC)),
                  ),
                  const SizedBox(height: 16),
                  const Center(
                    child: Text(
                      "Total Mensal",
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 32),

                  _buildLabel("Mês de Referência"),
                  
                  // 2. Vincula o Dropdown ao estado reativo do Controller
                  Obx(() => DropdownButtonFormField<String>(
                    value: controller.selectedMonth.value.capitalizeFirst, // Exibe com inicial maiúscula
                    decoration: _inputDecoration(Icons.calendar_month),
                    items: ["Janeiro", "Fevereiro", "Março", "Abril", "Maio", "Junho", "Julho", "Agosto", "Setembro", "Outubro", "Novembro", "Dezembro"]
                        .map((m) => DropdownMenuItem(value: m, child: Text(m)))
                        .toList(),
                    onChanged: (val) {
                      if (val != null) {
                        controller.selectedMonth.value = val.toLowerCase();
                      }
                    },
                    hint: const Text("Selecione o mês"),
                  )),

                  const SizedBox(height: 24),

                  _buildLabel("Total de Horas Trabalhadas"),
                  
                  // 3. Vincula o TextField ao TextEditingController do Controller
                  TextField(
                    controller: controller.hoursController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: _inputDecoration(Icons.timer_outlined).copyWith(
                      hintText: "Ex: 160",
                    ),
                  ),

                  const SizedBox(height: 40),

                  // 4. Botão com estado de carregamento (Obx)
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: Obx(() => ElevatedButton(
                      onPressed: controller.isLoading.value 
                          ? null 
                          : () => controller.submitSimpleInput(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2575FC),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        elevation: 0,
                      ),
                      child: controller.isLoading.value
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              "FINALIZAR E ENVIAR",
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                    )),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black54)),
    );
  }

  InputDecoration _inputDecoration(IconData icon) {
    return InputDecoration(
      prefixIcon: Icon(icon, size: 20, color: const Color(0xFF2575FC)),
      filled: true,
      fillColor: const Color(0xFFF1F5F9),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
    );
  }
}