class UserSession {
  final int userId;
  final String mobileNumber;
  final String userName;

  UserSession({
    required this.userId,
    required this.mobileNumber,
    required this.userName,
  });

  Map<String, dynamic> toJson() => {
    'userId': userId,
    'mobileNumber': mobileNumber,
    'userName': userName,
  };

  factory UserSession.fromJson(Map<String, dynamic> json) {
    return UserSession(
      userId: json['userId'],
      mobileNumber: json['mobileNumber'],
      userName: json['userName'],
    );
  }
}
