import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/day_model.dart'; // Certifique-se de criar o DayModel

class DetailedController extends GetxController {
  // --- Estados Reativos ---
  var isLoading = false.obs;
  var days = <Map<String, dynamic>>[].obs;
  var totalHours = 0.0.obs;
  var selectedMonth = "".obs;

  // Lista de meses para o Dropdown
  final List<String> months = [
    "Janeiro", "Fevereiro", "Março", "Abril", "Maio", "Junho",
    "Julho", "Agosto", "Setembro", "Outubro", "Novembro", "Dezembro"
  ];

  /// Busca os dias na API com base no mês selecionado
  void fetchDaysByMonth(String month) async {
    selectedMonth.value = month;
    isLoading.value = true;
    
    try {
      // Simulação: Aqui você chamaria seu Repository
      // Example: var response = await _repository.getCalendar(month);
      await Future.delayed(const Duration(milliseconds: 600));

      // Simulando o JSON que você recebeu da API
      List<Map<String, dynamic>> mockJson = [
        {"data": "2026-05-01", "diaSemana": "sexta-feira", "tipo": "Feriado", "sugestaoHoras": 0},
        {"data": "2026-05-02", "diaSemana": "sábado", "tipo": "Final de Semana", "sugestaoHoras": 0},
        {"data": "2026-05-03", "diaSemana": "domingo", "tipo": "Final de Semana", "sugestaoHoras": 0},
        {"data": "2026-05-04", "diaSemana": "segunda-feira", "tipo": "Útil", "sugestaoHoras": 8},
        {"data": "2026-05-05", "diaSemana": "terça-feira", "tipo": "Útil", "sugestaoHoras": 8},
      ];

      // Mapeia o JSON para a estrutura interna da View
      var generatedDays = mockJson.map((json) {
        final model = DayModel.fromJson(json);
        
        // Criamos um controller de texto para cada dia
        final textController = TextEditingController(
          text: model.sugestaoHoras > 0 ? model.sugestaoHoras.toStringAsFixed(0) : "0"
        );

        // Ouvinte para recalcular o total sempre que o usuário digitar
        textController.addListener(calculateTotal);

        return {
          "date": model.data, // DateTime original
          "day": model.data.day,
          "weekday": model.diaSemana,
          "type": model.tipo,
          "selected": model.tipo == "Útil", // Auto-seleciona se for dia útil
          "controller": textController,
        };
      }).toList();

      days.assignAll(generatedDays);
      calculateTotal(); // Cálculo inicial
    } catch (e) {
      Get.snackbar("Erro", "Não foi possível carregar os dias: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// Percorre a lista e calcula a soma total das horas
  void calculateTotal() {
    double sum = 0.0;
    for (var item in days) {
      if (item['selected'] == true) {
        String val = item['controller'].text.replaceAll(',', '.');
        
        // Suporte para formato HH:mm ou Decimal (8.5 ou 08:30)
        if (val.contains(':')) {
          var parts = val.split(':');
          double h = double.tryParse(parts[0]) ?? 0;
          double m = parts.length > 1 ? (double.tryParse(parts[1]) ?? 0) / 60 : 0;
          sum += h + m;
        } else {
          sum += double.tryParse(val) ?? 0;
        }
      }
    }
    totalHours.value = sum;
  }

  /// Envia os dados finais para o seu Backend Node.js
  Future<void> saveSelection() async {
    if (days.isEmpty) return;

    isLoading.value = true;
    try {
      // Prepara o payload (o que o Node.js vai receber no req.body)
      final payload = {
        "mes": selectedMonth.value,
        "totalGeral": totalHours.value,
        "lancamentos": days.where((d) => d['selected']).map((d) => {
          "data": (d['date'] as DateTime).toIso8601String(),
          "horas": d['controller'].text,
          "tipo": d['type']
        }).toList(),
      };

      print("Payload para o Banco: $payload");
      
      // Simulação de POST
      await Future.delayed(const Duration(seconds: 1));
      
      Get.back(); // Volta para a Home
      Get.snackbar(
        "Sucesso!", 
        "Lançamento de ${selectedMonth.value} enviado com sucesso.",
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar("Erro ao salvar", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    // Limpeza de memória: deleta todos os controllers de texto
    for (var day in days) {
      day['controller'].dispose();
    }
    super.onClose();
  }
}