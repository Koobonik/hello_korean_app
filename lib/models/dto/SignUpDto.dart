class SignUpDto {
  String userLoginId;
  String userLoginPassword;
  String nickName;
  String email;
  String firebaseToken;
  String secretCode;


  SignUpDto(this.userLoginId, this.userLoginPassword, this.nickName, this.email,
      this.firebaseToken, this.secretCode);

  factory SignUpDto.fromJson(dynamic json){
    return SignUpDto(json['userLoginId'] as String, json['userLoginPassword'] as String, json['nickName'] as String, json['email'] as String, json['firebaseToken'] as String, json['secretCode'] as String);
  }
  Map<String, dynamic> toJson() =>
      {
        'userLoginId' : userLoginId,
        'userLoginPassword' : userLoginPassword,
        'nickName' : nickName,
        'email' : email,
        'firebaseToken': firebaseToken,
        'secretCode': secretCode
      };

}