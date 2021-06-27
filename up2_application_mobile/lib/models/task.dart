class Task {
  int number;
  String id;
  String title;
  String state;
  String project;
  int priority;
  String responsibleUser;
  List<dynamic> weekWriteOffTimes;
  bool selected = false;
  Task({
    this.id,
    this.number,
    this.state,
    this.title,
    this.weekWriteOffTimes,
    this.project,
    this.priority,
    this.responsibleUser,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      number: json['number'],
      state: json['state'],
      title: json['title'],
      project: json['project'],
      priority: json['priority'],
      responsibleUser: json['responsibleUser'],
      weekWriteOffTimes: json['weekWriteOffTimes'],
    );
  }
}
