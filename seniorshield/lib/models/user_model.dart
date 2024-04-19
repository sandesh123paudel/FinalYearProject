class UserModel {
  String? uid;
  String? fullName;
  String? email;
  String? address;
  String? role;
  String? searchBy;
  String? username;

  UserModel({
    this.uid,
    this.fullName,
    this.email,
    this.address,
    this.role,
    this.searchBy,
    this.username,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'],
      fullName: map['fullName'],
      email: map['email'],
      address: map['address'],
      role: map['role'],
      searchBy: map['searchBy'],
      username: map['username'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'fullName': fullName,
      'email': email,
      'address': address,
      'role': role,
      'searchBy': searchBy,
      'username': username,
    };
  }

  static String generateSearchBy(String? email, String currentUserEmail) {
    String userEmail = email ?? currentUserEmail;
    // Extract username from email
    String usernameFromEmail = userEmail.split('@').first;
    // Capitalize first letter of username
    String capitalizedUsername = usernameFromEmail[0].toUpperCase();
    return capitalizedUsername;
  }

  static String generateUsername(String? email) {
    // Handle nullable email case
    String userEmail = email ?? '';
    // Extract username from email
    String usernameFromEmail = userEmail.split('@').first;
    // Capitalize every letter in the username
    String capitalizedUsername = usernameFromEmail.toUpperCase();
    return capitalizedUsername;
  }




}
