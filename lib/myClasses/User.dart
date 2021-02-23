class User {
  int uid;
  String nickName;
  String avatar;
  String createTime;
  String signature;
  String phoneNumber;
  String email;
  User(
      {this.avatar,
      // this.createTime,
      this.email,
      this.nickName,
      this.phoneNumber,
      this.signature,
      this.uid});
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        uid: json['uid'],
        avatar: json['avatar'],
        phoneNumber: json['phoneNumber'],
        email: json['email'],
        signature: json['signature'],
        nickName: json['nickName']);
  }
}
