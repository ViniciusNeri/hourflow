import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  UserModel({
    required super.id,
    required super.name,
    required super.email,
    required super.companyName,
    required super.managerEmail,
    required super.receiveCopy,
    super.createdAt,
    required super.token,
  });

  // De JSON para Objeto (usado na resposta da API)
  factory UserModel.fromJson(Map<String, dynamic> json) {
    print("DEBUG JSON: $json");
    return UserModel(
      id: json['id'] ?? json['_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      companyName: json['companyName'] ?? '',
      managerEmail: json['managerEmail'] ?? '',
      receiveCopy: json['receiveCopy'] ?? false,
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt']) 
          : null,
      token: json['token'] ?? '',
    );
  }

  // De Objeto para JSON (usado para salvar no Modal de Settings)
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'companyName': companyName,
      'managerEmail': managerEmail,
      'receiveCopy': receiveCopy,
      'token': token,
    };
  }
}