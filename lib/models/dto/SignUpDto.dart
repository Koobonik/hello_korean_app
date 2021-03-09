class SignUpDto {
  String userEmail;
  String emailCode;
  String password;
  String nickName;
  String firebaseToken;

  SignUpDto({this.userEmail, this.emailCode, this.password, this.nickName,
      this.firebaseToken});

  Map<String, dynamic> toMap() {
    return {
      'userEmail': userEmail,
      'emailCode': emailCode,
      'password': password,
      'nickName': nickName,
      'firebaseToken': firebaseToken,
    };
  }
}