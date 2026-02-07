import '../../domain/entities/user_entity.dart';

class AuthModel extends UserEntity {
  AuthModel({
    required super.id,
    required super.email,
    required super.token,
  });

  // Este é o "mapeador": transforma o JSON da API em um objeto AuthModel
  factory AuthModel.fromJson(Map<String, dynamic> json) {
    return AuthModel(
      id: json['user']['email'] ?? '', 
      email: json['user']['email'] ?? '',
      token: json['token'] ?? '',
    );
  }

  // Caso precise enviar de volta (raro para auth, mas útil)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'token': token,
    };
  }
}