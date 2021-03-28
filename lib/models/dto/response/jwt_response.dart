class JwtResponse {
  String jwt;
  String refreshJwt;

  JwtResponse({this.jwt, this.refreshJwt});

  factory JwtResponse.fromMap(dynamic map) {
    if (null == map) return null;
    var temp;
    return JwtResponse(jwt: map['jwt']?.toString(),
      refreshJwt: map['refreshJwt']?.toString(),
    );
  }




}