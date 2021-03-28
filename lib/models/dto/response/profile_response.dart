class Profile{
  int id;
  String userNickname;
  String imagUrl;
  List<String> roles;

  @override
  String toString() {
    return 'Profile{id: $id, userNickname: $userNickname, imagUrl: $imagUrl, roles: $roles}';
  }

  Profile({this.id, this.userNickname, this.imagUrl, this.roles});

  factory Profile.fromMap(dynamic map) {
    if (null == map) return null;
    var temp;
    return Profile(
      id: null == (temp = map['id']) ? null : (temp is num ? temp.toInt() : int
          .tryParse(temp)),
      userNickname: map['userNickname']?.toString(),
      imagUrl: map['imagUrl']?.toString(),
      roles: null == (temp = map['roles']) ? [] : (temp is List ? temp.map((
          map) => map?.toString()).toList() : []),
    );
  }




}