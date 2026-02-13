import '../models/user_model.dart';
import '../providers/user_provider.dart';

class UserRepository {
  final UserProvider _provider;

  UserRepository(this._provider);

  Future<UserModel?> getUser(String id) async {
    final response = await _provider.getUserProfile(id);
    
    if (response.status.hasError) {
      throw Exception("Erro ao buscar usuário: ${response.statusText}");
    }

    if (response.body != null) {
    // Se vier como MAPA (Objeto único - O esperado agora)
    if (response.body is Map<String, dynamic>) {
      return UserModel.fromJson(response.body);
    } 
    // Se ainda vier como LISTA (Caso o backend mude)
    else if (response.body is List && response.body.isNotEmpty) {
      return UserModel.fromJson(response.body[0]);
    }
    }

    return null; // Retorna null se não conseguir criar o UserModel
  }

  // Atualiza o usuário
  Future<bool> update(String id, UserModel user) async {
    final response = await _provider.updateUserProfile(id, user.toJson());
    return response.status.isOk;
  }
}