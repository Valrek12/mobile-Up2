import 'package:up2_application_mobile/models/user_info.dart';

class UserDetails {
  final UserInfo userInfo;
  final String message;

  UserDetails({this.userInfo, this.message});

  factory UserDetails.fromJson(Map<String, dynamic> json) {
    return UserDetails(
        userInfo: UserInfo.fromJson(json['data']), message: json['message']);
  }
}
