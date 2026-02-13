class UserEntity {
  final String? id;
  final String? name;
  final String? email;
  final String? token;
  final String? companyName;
  final String? managerEmail;
  final bool receiveCopy;

  UserEntity({
    this.id,
    this.name,
    this.email,
    this.token,
    this.companyName,
    this.managerEmail,
    this.receiveCopy = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'token': token,
      'companyName': companyName,
      'managerEmail': managerEmail,
      'receiveCopy': receiveCopy,
    };
  }

  factory UserEntity.fromJson(Map<String, dynamic> json) {
    return UserEntity(
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