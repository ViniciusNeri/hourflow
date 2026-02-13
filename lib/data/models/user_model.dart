import '../../domain/entities/user_entity.dart';
// Exemplo de como ajustar o construtor do seu UserModel
class UserModel extends UserEntity {
  UserModel({
    super.id,
    super.name,
    super.email,
    super.token,
    super.companyName,
    super.managerEmail,
    super.receiveCopy,
  });

  // Garanta que o factory do Model também mapeie os novos campos
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      token: json['token'],
      companyName: json['companyName'],
      managerEmail: json['managerEmail'],
      receiveCopy: json['receiveCopy'] ?? false,
    );
  }
}