class UserProfile {
  final int id;
  final String username;
  final String email;
  final int employee;
  final String first_name;
  final String last_name;
  final String full_name;
  final String birthday;
  final String avatar;

  UserProfile({
    required this.id,
    required this.username,
    required this.employee,
    required this.email,
    required this.first_name,
    required this.last_name,
    required this.full_name,
    required this.birthday,
    required this.avatar,
  });

  factory UserProfile.fromJson(Map<String, dynamic> data) {
    return UserProfile(
      id: data['id'],
      username: data['username'],
      email: data['email'],
      employee: data['employee'],
      first_name: data['first_name'],
      last_name: data['last_name'],
      full_name: data['full_name'],
      birthday: data['birthday'],
      avatar: data['avatar'],
    );
  }
}