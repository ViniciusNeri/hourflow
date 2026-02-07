import 'package:dio/dio.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/api_datasource.dart';
import '../models/auth_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final ApiDatasource _datasource;

  AuthRepositoryImpl(this._datasource);

  @override
  Future<UserEntity> login(String email, String password) async {
    try {
      final response = await _datasource.httpClient.post(
        '/sessions', // Endpoint que definimos no back-end
        data: {
          'email': email,
          'password': password,
        },
      );

      // Usamos o Model para "traduzir" o JSON que o Render enviou
      return AuthModel.fromJson(response.data);
    } on DioException catch (e) {
      // Aqui você pode tratar erros específicos (ex: senha errada)
      throw Exception(e.response?.data['error'] ?? 'Erro ao realizar login');
    }
  }

  @override
  Future<void> logout() async {
    // Lógica para limpar o token futuramente
  }
}