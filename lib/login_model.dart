class Loguser {
  final String email;
  final String password;

  Loguser({
    required this.email,
    required this.password,
  });

  // Method to convert User object to JSON (Serialization)
  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
    };
  }

  // Factory constructor to create User object from JSON (Deserialization)
  factory Loguser.fromJson(Map<String, dynamic> json) {
    return Loguser(
      email: json['email'],
      password: json['password'],
    );
  }

  @override
  String toString() {
    return 'Loguser( email: $email, password: $password)';
  }
}
