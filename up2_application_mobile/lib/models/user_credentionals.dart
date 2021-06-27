import 'package:up2_application_mobile/models/data.dart';

class UserCred {
  final Data data;
  final String message;

  UserCred({this.data, this.message});

  factory UserCred.fromJson(Map<String, dynamic> json) {
    return UserCred(
        data: Data.fromJson(json['data']), message: json['message']);
  }
}
