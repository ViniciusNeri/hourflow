import '../entities/user_entity.dart';

abstract class AuthRepository {
  
  Future<UserEntity> login(String email, String password);

  Future<String> requestSignUp(Map<String, dynamic> userData);

  Future<UserEntity> confirmSignUp(String tempToken, String code);
}