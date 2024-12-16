
class User {
  final String fullname;
  final String email;
  final String password;
  final String phone;

  User({
    required this.fullname,
    required this.email,
    required this.password,
    required this.phone,
  });

  // Method to convert User object to JSON (Serialization)
  Map<String, dynamic> toJson() {
    return {
      'fullname': fullname,
      'email': email,
      'password': password,
      'phone': phone,
    };
  }

  // Factory constructor to create User object from JSON (Deserialization)
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      fullname: json['fullname'],
      email: json['email'],
      password: json['password'],
      phone: json['phone'],
    );
  }

  @override
  String toString() {
    return 'User(name: $fullname, email: $email, password: $password, phone: $phone)';
  }
}
