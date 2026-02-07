import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageService {
  final _storage = const FlutterSecureStorage();

  // Salva o Token
  Future<void> saveToken(String token) async {
    await _storage.write(key: 'jwt_token', value: token);
  }

  // Recupera o Token
  Future<String?> getToken() async {
    return await _storage.read(key: 'jwt_token');
  }

  // Deleta o Token (Logout)
  Future<void> deleteToken() async {
    await _storage.delete(key: 'jwt_token');
  }
}