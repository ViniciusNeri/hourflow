import 'package:get/get.dart';
import '../../core/constants/api_constants.dart'; 
import '../models/day_model.dart';
import '../../core/utils/storage_service.dart'; // Para acessar o token de autenticação

class SpreadSheetProvider extends GetConnect {
  final StorageService _storageService = StorageService();

  @override
  void onInit() {
    // Usa a URL base do seu arquivo de constantes
    baseUrl = ApiConstants.baseUrl; 
    
    // Opcional: Configurações extras como timeout
    httpClient.addRequestModifier<dynamic>((request) async {
        final token = await _storageService.getToken();

        request.headers.remove('content-length');
        
        if (token != null && token.isNotEmpty) {
            request.headers['Authorization'] = 'Bearer $token';
        }
        
        return request;
        });

    httpClient.timeout = const Duration(seconds: 60);    
    super.onInit();
  }


    Future<List<DayModel>> getPrepareDays(String mes, int ano) async {
    // Agora a chamada já vai com o Header de autorização
    final response = await get('/spreadsheet/prepare', query: {
      'mes': mes,
      'ano': ano.toString(),
    });
    
    if (response.status.hasError) {
      print("Erro na API (${response.statusCode}): ${response.body}");
      return [];
    }

    return (response.body as List)
        .map((item) => DayModel.fromJson(item))
        .toList();
    }

    Future<Response> generateCustomReport(Map<String, dynamic> body) {
    return post('/spreadsheet/custom', body);
    }

    Future<Response> sendSimpleInput(double horas, String mesVigente) {
    return post('/spreadsheet/send', {
        "horas": horas,
        "mesVigente": mesVigente,
    });
    }

}