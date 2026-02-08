import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/detailed_controller.dart';

class DetailedInputPage extends StatelessWidget {
  DetailedInputPage({super.key});

  final controller = Get.put(DetailedController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text("Lançamento Detalhado", 
          style: TextStyle(color: Color(0xFF1E293B), fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Container(
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20)],
            ),
            child: Column(
              children: [
                // 1. Seletor de Mês (Obx para monitorar a variável selectedMonth)
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Obx(() => DropdownButtonFormField<String>(
                    value: controller.selectedMonth.value.isEmpty ? null : controller.selectedMonth.value,
                    decoration: InputDecoration(
                      labelText: "Mês de Referência",
                      prefixIcon: const Icon(Icons.calendar_month, color: Color(0xFF2575FC)),
                      filled: true,
                      fillColor: const Color(0xFFF1F5F9),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                    ),
                    items: controller.months.map((m) => DropdownMenuItem(value: m, child: Text(m))).toList(),
                    onChanged: (val) => controller.fetchDaysByMonth(val!),
                  )),
                ),

                // 2. Lista de Dias (Obx monitora isLoading e a lista days)
                Expanded(
                  child: Obx(() {
                    if (controller.isLoading.value) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    
                    if (controller.days.isEmpty) {
                      return const Center(child: Text("Selecione um mês para carregar os dias."));
                    }

                    return ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: controller.days.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final item = controller.days[index];
                        return _buildDayRow(item);
                      },
                    );
                  }),
                ),

                // 3. Rodapé com Totalizador (Obx monitora totalHours)
                _buildFooter(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDayRow(Map<String, dynamic> item) {
    bool isWorkDay = item['type'] == "Útil";

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          // Sem Obx aqui dentro! O Obx do ListView já cuida da reconstrução
          Checkbox(
            value: item['selected'],
            activeColor: const Color(0xFF2575FC),
            onChanged: (val) {
              item['selected'] = val;
              controller.days.refresh(); // Notifica a lista que algo mudou
              controller.calculateTotal();
            },
          ),
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Dia ${item['day']} - ${item['weekday']}", 
                  style: TextStyle(fontWeight: FontWeight.bold, color: isWorkDay ? Colors.black87 : Colors.orange[800])),
                Text(item['type'], style: const TextStyle(fontSize: 11, color: Colors.grey)),
              ],
            ),
          ),
          SizedBox(
            width: 80,
            height: 40,
            child: TextField(
              controller: item['controller'],
              enabled: item['selected'],
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                filled: true,
                fillColor: item['selected'] ? const Color(0xFFE0E7FF) : Colors.grey[100],
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Total de Horas:", style: TextStyle(fontWeight: FontWeight.w600)),
              Obx(() => Text(
                "${controller.totalHours.value.toStringAsFixed(1)}h",
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF2575FC)),
              )),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: Obx(() => ElevatedButton(
              onPressed: controller.isLoading.value ? null : () => controller.saveSelection(),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2575FC),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text("ENVIAR LANÇAMENTO", 
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            )),
          ),
        ],
      ),
    );
  }
}