class ApiConstants {
  static const String baseUrl = 'https://envioplanilha.onrender.com/api/v1';
  static const String login = '/sessions';
  static const String enviarPlanilha = '/enviar-planilha';

  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
}