class LoginDto {
  String userEmail;
  String userPassword;

  LoginDto({this.userEmail, this.userPassword});

  Map<String, dynamic> toMap() {
    return {
      'userEmail': userEmail,
      'userPassword': userPassword,
    };
  }
}