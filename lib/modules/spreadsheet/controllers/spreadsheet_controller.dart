import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../data/models/day_model.dart';
import '../../../domain/repositories/spreadsheet_repository.dart';
import 'package:intl/intl.dart'; 
import 'package:intl/date_symbol_data_local.dart';

class SpreadSheetController extends GetxController {
  final SpreadSheetRepository repository;
  SpreadSheetController(this.repository);

  // Estados reativos
  var isLoading = false.obs;
  var days = <DayModel>[].obs;
  
  // Parâmetros de busca (podem ser alterados via UI)
  var selectedMonth = "".obs;
  var selectedYear = DateTime.now().year.obs;
  var daysList = <Map<String, dynamic>>[].obs; // Lista para a UI
  var totalHours = 0.0.obs;
  final hoursController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    _setCurrentDate();
  }

  Future<void> fetchPreparedDays() async {
    isLoading.value = true;
    if (selectedMonth.value.isEmpty) return;

    try {
      final result = await repository.getPrepareDays(
        selectedMonth.value, 
        selectedYear.value
      );     

      daysList.assignAll(result.map((day) => {
        'dia': day.data.day.toString().padLeft(2, '0'),
        'dataIso': DateFormat('yyyy-MM-dd').format(day.data),
        'semana': day.diaSemana,
        'tipo': day.tipo,
        'selected': day.tipo == "Útil",
        'controller': TextEditingController(text: day.sugestaoHoras.toString()),
      }).toList());
      
      calculateTotal();
      
      if (result.isNotEmpty) {
        days.assignAll(result);
      } else {
        Get.snackbar("Aviso", "Nenhum dado retornado para este período.");
      }
    } catch (e) {
      Get.snackbar("Erro", "Falha ao conectar com o servidor.");
    } finally {
      isLoading.value = false;
    }
  }

  void calculateTotal() {
    double total = 0;
    for (var item in daysList) {
      if (item['selected']) {
        final hours = double.tryParse(item['controller'].text) ?? 0;
        total += hours;
      }
    }
    totalHours.value = total;
  }

  void sendData() async {
    
    try {
      isLoading.value = true;

     final List<Map<String, dynamic>> lancamentos = daysList.map((item) {
      // item['dataOriginal'] deve ser guardado no fetchPreparedDays para facilitar
      return {
        "data": item['dataIso'],        // Formato "2026-02-01"
        "diaSemana": item['semana'],    // Formato "Domingo"
        "horas": double.tryParse(item['controller'].text) ?? 0,
      };
    }).toList();

    if (lancamentos.isEmpty) {
      Get.snackbar("Aviso", "Selecione pelo menos um dia para lançar.");
      return;
    }

    final Map<String, dynamic> body = {
      "mesVigente": selectedMonth.value,
      "lancamentos": lancamentos,
    };

    final success = await repository.generateCustomReport(body);

    if (!success) {
      Get.snackbar("Erro", "Falha ao enviar os dados. Tente novamente.");
      return;
    }

    if (success) {
      await Get.dialog(
        AlertDialog(
          title: const Text("Sucesso"),
          content: const Text("Planilha enviada com sucesso!"),
          actions: [
            TextButton(
              onPressed: () {
                Get.back(); // Fecha o Alerta
                Get.back(); // Volta para a tela anterior (Home)
              },
              child: const Text("OK"),
            ),
          ],
        ),
        barrierDismissible: false, // Força o usuário a clicar no OK
      );
      } else {
        Get.snackbar("Erro", "Falha ao gerar relatório no servidor.");
      }
    } catch (e) {
      Get.snackbar("Erro", "Ocorreu um erro inesperado.");
    } finally {
      isLoading.value = false;
    }
  }

  void submitSimpleInput() async {
    // Validação básica
    if (hoursController.text.isEmpty) {
      Get.snackbar("Erro", "Por favor, insira a quantidade de horas.");
      return;
    }

    try {
      isLoading.value = true;
      
      double horas = double.tryParse(hoursController.text) ?? 0.0;
      String mes = selectedMonth.value;

      final success = await repository.sendSimpleInput(horas, mes);

      if (success) {
        await Get.dialog(
          AlertDialog(
          title: const Text("Sucesso"),
          content: const Text("Planilha enviada com sucesso!"),
          actions: [
            TextButton(
              onPressed: () {
                Get.back(); // Fecha o Alerta
                Get.back(); // Volta para a tela anterior (Home)
              },
              child: const Text("OK"),
            ),
          ],
        ),
        barrierDismissible: false, // Força o usuário a clicar no OK
      );
      } else {
        Get.snackbar("Erro", "Falha ao enviar para o servidor.");
      }
    } catch (e) {
      Get.snackbar("Erro", "Ocorreu um erro: $e");
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    // Boa prática: descartar os controllers de texto para economizar memória
    for (var item in daysList) {
      item['controller'].dispose();
    }
    super.onClose();
  }

  void _setCurrentDate() {
    initializeDateFormatting('pt_BR', null); // Garante suporte ao português
    DateTime agora = DateTime.now();
    
    // Pega o nome do mês em português (ex: "fevereiro")
    String mesNome = DateFormat('MMMM', 'pt_BR').format(agora).toLowerCase();
    
    selectedMonth.value = mesNome;
    selectedYear.value = agora.year;
  }
}