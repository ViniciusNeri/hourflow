import '../entities/user_entity.dart';

abstract class AuthRepository {
  // O contrato diz: "Quem me usar, terá que implementar esse método"
  Future<UserEntity> login(String email, String password);
  
  Future<void> logout();
}