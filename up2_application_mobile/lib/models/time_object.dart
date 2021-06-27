class TimeObject {
  final String data;
  final String mesage;
  final int status;
  TimeObject({this.data, this.mesage, this.status});

  factory TimeObject.fromJson(Map<String, dynamic> json) {
    return TimeObject(
        data: json['data'], mesage: json['message'], status: json['status']);
  }
}

class WorkObject {
  final bool data;
  final String mesage;
  final int status;

  WorkObject({this.data, this.mesage, this.status});

  factory WorkObject.fromJson(Map<String, dynamic> json) {
    return WorkObject(
        data: json['data'], mesage: json['message'], status: json['status']);
  }
}
