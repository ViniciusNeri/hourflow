import '../models/day_model.dart';
import '../providers/spreadsheet_provider.dart';
import '../../domain/repositories/spreadsheet_repository.dart';
import 'package:get/get.dart';

class SpreadSheetRepositoryImpl implements SpreadSheetRepository {
  final SpreadSheetProvider _provider;

  SpreadSheetRepositoryImpl(this._provider);

    @override
    Future<List<DayModel>> getPrepareDays(String mes, int ano) async {
      try {
        // Se o seu provider retorna List<DayModel> diretamente:
        final response = await _provider.getPrepareDays(mes, ano);

        // Remova o check de response.status.hasError se o retorno for List,
        // pois List não tem propriedade 'status'.
        return response; 
        
      } catch (e) {
        print("Erro ao buscar dias preparados: $e");
        return []; // Retorna lista vazia em caso de erro
      }
    }
    @override
    Future<bool> generateCustomReport(Map<String, dynamic> data) async {
        final response = await _provider.generateCustomReport(data);

        if (response.status.hasError) {
        print("Erro no servidor: ${response.body}");
        return false;
        }

        return true;
    }
    @override
    Future<bool> sendSimpleInput(double horas, String mesVigente) async {
    final response = await _provider.sendSimpleInput(horas, mesVigente);

    if (response.status.hasError) {
        print("Erro no Simple Input: ${response.body}");
        return false;
    }
    return true;
    }
}