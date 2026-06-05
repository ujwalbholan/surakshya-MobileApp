library user_model;

class UserModel {
  const UserModel({
    required this.name,
    required this.email,
    this.phone,
    this.avatarPath,
    this.bloodType,
    this.age,
  });

  final String name;
  final String email;
  final String? phone;
  final String? avatarPath;
  final String? bloodType;
  final int? age;

  UserModel copyWith({
    String? name,
    String? email,
    String? phone,
    String? avatarPath,
    String? bloodType,
    int? age,
  }) =>
      UserModel(
        name: name ?? this.name,
        email: email ?? this.email,
        phone: phone ?? this.phone,
        avatarPath: avatarPath ?? this.avatarPath,
        bloodType: bloodType ?? this.bloodType,
        age: age ?? this.age,
      );

  Map<String, dynamic> toMap() => {
        'name': name,
        'email': email,
        'phone': phone,
        'avatarPath': avatarPath,
        'bloodType': bloodType,
        'age': age,
      };

  factory UserModel.fromMap(Map<String, dynamic> map) => UserModel(
        name: map['name'] as String,
        email: map['email'] as String,
        phone: map['phone'] as String?,
        avatarPath: map['avatarPath'] as String?,
        bloodType: map['bloodType'] as String?,
        age: map['age'] as int?,
      );
}
