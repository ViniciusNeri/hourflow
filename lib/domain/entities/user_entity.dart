class UserEntity {
  final String id;
  final String name;
  final String email;
  final String companyName;
  final String managerEmail;
  final bool receiveCopy;
  final DateTime? createdAt;
  final String token;

  UserEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.companyName,
    required this.managerEmail,
    required this.receiveCopy,
    this.createdAt,
    required this.token,
  });
}