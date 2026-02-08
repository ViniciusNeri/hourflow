import '../models/day_model.dart'; // Ajuste o caminho conforme sua estrutura
import '../providers/spreadsheet_provider.dart';

class SpreadSheetRepository {
  final SpreadSheetProvider provider;

  SpreadSheetRepository(this.provider);

  /// Busca a lista de dias preparados para o mês e ano especificados
   Future<List<DayModel>> getPrepareDays(String mes, int ano) async {
    try {
      final response = await provider.getPrepareDays(mes, ano);
      
      // Aqui você pode adicionar lógicas de tratamento de erro mais específicas
      // ou até mesmo salvar esses dados em um cache local se necessário.
      
      return response;
    } catch (e) {
      // Log de erro para debug
      print("Erro no SpreadSheetRepository: $e");
      return [];
    }
   }

    Future<bool> generateCustomReport(Map<String, dynamic> data) async {
        final response = await provider.generateCustomReport(data);

        if (response.status.hasError) {
        print("Erro no servidor: ${response.body}");
        return false;
        }

        return true;
    }

    Future<bool> sendSimpleInput(double horas, String mesVigente) async {
    final response = await provider.sendSimpleInput(horas, mesVigente);

    if (response.status.hasError) {
        print("Erro no Simple Input: ${response.body}");
        return false;
    }
    return true;
    }
}