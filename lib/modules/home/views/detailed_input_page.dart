import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../spreadsheet/controllers/spreadsheet_controller.dart';
import '../../../data/models/day_model.dart';

class DetailedInputPage extends StatelessWidget {
  const DetailedInputPage({super.key});

  @override
  Widget build(BuildContext context) {
    final sheetCtrl = Get.find<SpreadSheetController>();

    // Busca inicial
    WidgetsBinding.instance.addPostFrameCallback((_) {
      sheetCtrl.fetchPreparedDays();
    });

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          "Lançamento Detalhado",
          style: TextStyle(color: Color(0xFF1E293B), fontWeight: FontWeight.bold),
        ),
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
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20)
              ],
            ),
            child: Column(
              children: [
                // 1. Filtro de Mês
                _buildFilterHeader(sheetCtrl),

                // 2. Lista de Dias
                Expanded(
                  child: Obx(() {
                    if (sheetCtrl.isLoading.value) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    return ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: sheetCtrl.daysList.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        // Usaremos uma lista de Map que o Controller vai gerenciar
                        return _buildDayRow(sheetCtrl, index);
                      },
                    );
                  }),
                ),

                // 3. Rodapé com Soma Total
                _buildFooter(sheetCtrl),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFilterHeader(SpreadSheetController ctrl) {
    final meses = [
      'janeiro', 'fevereiro', 'março', 'abril', 'maio', 'junho',
      'julho', 'agosto', 'setembro', 'outubro', 'novembro', 'dezembro'
    ];

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Obx(() => DropdownButtonFormField<String>(
            value: ctrl.selectedMonth.value,
            decoration: InputDecoration(
              labelText: "Mês de Referência",
              prefixIcon: const Icon(Icons.calendar_month, color: Color(0xFF2575FC)),
              filled: true,
              fillColor: const Color(0xFFF1F5F9),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none),
            ),
            items: meses
                .map((m) => DropdownMenuItem(value: m, child: Text(m.capitalizeFirst!)))
                .toList(),
            onChanged: (val) {
              if (val != null) {
                ctrl.selectedMonth.value = val;
                ctrl.fetchPreparedDays();
              }
            },
          )),
    );
  }

  Widget _buildDayRow(SpreadSheetController ctrl, int index) {
    // Pegamos o mapa de dados da lista reativa do controller
    var item = ctrl.daysList[index];
    bool isWorkDay = item['tipo'] == "Útil";

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          // Checkbox funcional
          Checkbox(
            value: item['selected'],
            activeColor: const Color(0xFF2575FC),
            onChanged: (val) {
              item['selected'] = val;
              ctrl.daysList.refresh(); // Atualiza a tela
              ctrl.calculateTotal();   // Recalcula a soma
            },
          ),
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Dia ${item['dia']} - ${item['semana']}",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isWorkDay ? Colors.black87 : Colors.orange[800]),
                ),
                Text(item['tipo'],
                    style: const TextStyle(fontSize: 11, color: Colors.grey)),
              ],
            ),
          ),
          // Campo de Horas Alterável
          SizedBox(
            width: 80,
            height: 40,
            child: TextField(
              controller: item['controller'], // Controller de texto reativo
              enabled: item['selected'],    // Só edita se o checkbox estiver marcado
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              style: const TextStyle(fontWeight: FontWeight.bold),
              onChanged: (value) => ctrl.calculateTotal(), // Soma ao digitar
              decoration: InputDecoration(
                filled: true,
                fillColor: item['selected'] ? const Color(0xFFE0E7FF) : Colors.grey[100],
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(SpreadSheetController ctrl) {
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
              const Text("Total de Horas:",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
              Obx(() => Text(
                    "${ctrl.totalHours.value.toStringAsFixed(1)}h",
                    style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2575FC)),
                  )),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: Obx(() => ElevatedButton(
                  onPressed: ctrl.isLoading.value ? null : () => ctrl.sendData(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2575FC),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text("ENVIAR LANÇAMENTO",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                )),
          ),
        ],
      ),
    );
  }
}