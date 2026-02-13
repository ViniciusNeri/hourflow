import '../../domain/entities/user_entity.dart';

class AuthModel extends UserEntity {
  AuthModel({
    required String id,
    required String name,
    required String email,
    required String companyName,
    required String managerEmail,
    required bool receiveCopy,
    required String token,
  }) : super(
          id: id,
          name: name,
          email: email,
          companyName: companyName,
          managerEmail: managerEmail,
          receiveCopy: receiveCopy,
          token: token,
        );

  factory AuthModel.fromJson(Map<String, dynamic> json) {
  final userData = json['user'] ?? json; 

  return AuthModel(
    id: userData['id'] ?? '',
    name: userData['name'] ?? '',
    email: userData['email'] ?? '',
    companyName: userData['companyName'] ?? '',
    managerEmail: userData['managerEmail'] ?? '',
    receiveCopy: userData['receiveCopy'] ?? false,
    token: json['token'] ?? userData['token'] ?? '', 
  );
}
}