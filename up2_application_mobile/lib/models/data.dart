class Data {
  final String id;
  final String token;

  Data({this.id, this.token});

  factory Data.fromJson(Map<String, dynamic> json) {
    if (json != null) {
      return Data(id: json['id'], token: json['auditToken']);
    } else {
      return null;
    }
  }
}
