import 'package:get/get.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../models/auth_model.dart';
import '../providers/auth_provider.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthProvider _provider;

  AuthRepositoryImpl(this._provider);

  @override
  Future<UserEntity> login(String email, String password) async {
    final response = await _provider.login(email, password);

    if (response.status.hasError) {
      throw Exception(response.body?['message'] ?? 'Erro ao realizar login');
    }

    // No seu back-end de login, se o retorno for direto no body:
    return AuthModel.fromJson(response.body);
  }

  @override
  Future<String> requestSignUp(Map<String, dynamic> userData) async {

    final response = await _provider.signUp(userData);

    if (response.status.hasError) {
      throw Exception(response.body?['message'] ?? 'Erro ao solicitar cadastro');
    }

    // De acordo com seu JSON: retorna data['token']
    return response.body['data']['token'];
  }

  @override
  Future<UserEntity> confirmSignUp(String tempToken, String code) async {
    final response = await _provider.confirmSignUp(tempToken, code);

    if (response.status.hasError) {
      throw Exception(response.body?['message'] ?? 'Código inválido');
    }

    final data = response.body['data'];
    
    // O ERRO ESTÁ AQUI: Verifique se 'user' ou 'id' existem no data
    if (data == null || data['user'] == null) {
      throw Exception("Dados do usuário não retornados pelo servidor");
    }

    // Extração explícita para garantir que não passamos nulos inesperados
    final userMap = Map<String, dynamic>.from(data['user']);
    final String? token = data['token'];

    return AuthModel.fromJson({
      'id': userMap['id'],
      'name': userMap['name'],
      'email': userMap['email'],
      'token': token, // Adicionando o token explicitamente
    });
  }
}