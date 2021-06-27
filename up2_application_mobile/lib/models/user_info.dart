class UserInfo {
  final String title;
  final String login;

  UserInfo({this.title, this.login});

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(login: json['login'], title: json['title']);
  }
}
