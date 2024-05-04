class UserModel {
  String? uid;
  String? fullName;
  String? email;
  String? address;
  String? role;
  String? image;
  String? about;
  String? createdAt;
  bool? isOnline;
  String? lastActive;
  String? pushToken;

  UserModel({
    this.uid,
    this.fullName,
    this.email,
    this.address,
    this.role,
    this.image,
    this.about,
    this.createdAt,
    this.isOnline,
    this.lastActive,
    this.pushToken,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'],
      fullName: json['fullName'],
      email: json['email'],
      address: json['address'],
      role: json['role'],
      image: json['image'],
      about: json['about'],
      createdAt: json['created_at'],
      isOnline: json['is_online'],
      lastActive: json['last_active'],
      pushToken: json['push_token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'fullName': fullName,
      'email': email,
      'address': address,
      'role': role,
      'image': image,
      'about': about,
      'created_at': createdAt,
      'is_online': isOnline,
      'last_active': lastActive,
      'push_token': pushToken,
    };
  }
}
