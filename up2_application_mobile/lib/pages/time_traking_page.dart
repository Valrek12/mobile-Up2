import 'package:flutter/widgets.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter/material.dart';
import 'package:up2_application_mobile/models/data_tasks.dart';
import 'package:up2_application_mobile/models/task.dart';
import 'package:up2_application_mobile/pages/table_task_page.dart';
import 'package:up2_application_mobile/pages/tracker_page.dart';
import 'package:up2_application_mobile/service/up2_repository.dart';
import 'package:up2_application_mobile/utils/date_converter.dart';

class TimeTracking extends StatefulWidget {
  final Task task;
  final String login;
  final String password;
  const TimeTracking({Key key, this.task, this.login, this.password})
      : super(key: key);
  TimeTrackingState createState() => TimeTrackingState();
}

class TimeTrackingState extends State<TimeTracking> {
  var _calendarController = CalendarController();
  Task task;
  DataTasks dataTask;
  Up2Repository basicAuthUp2 = new Up2Repository();
  String startDay;
  String startDay1;
  String errorMessage;

  Future<DataTasks> refresh() async {
    setState(() {
      getTasks(startDay1).then((value) => {dataTask = value});
    });

    return dataTask;
  }

  @override
  void initState() {
    errorMessage = null;
    startDay = DateConverter.selectDay(DateTime.now());
    startDay1 = DateConverter.firstDayOfMonthDayOfWeek();
    task = widget.task;
    super.initState();
  }

  Widget calendar() {
    return TableCalendar(
      locale: 'ru',
      headerVisible: false,
      initialCalendarFormat: CalendarFormat.week,
      startingDayOfWeek: StartingDayOfWeek.monday,
      calendarController: _calendarController,
      calendarStyle: CalendarStyle(selectedColor: Colors.orange),
      onVisibleDaysChanged: (dateTime, dateTime2, calendarFormat) {
        setState(() {
          startDay =
              "${dateTime.year.toString().padLeft(2, '0')}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}";
        });
      },
      onDaySelected: (day, events, holidays) {
        setState(() {
          startDay =
              "${day.year.toString().padLeft(2, '0')}-${day.month.toString().padLeft(2, '0')}-${day.day.toString().padLeft(2, '0')}";
        });
      },
      availableCalendarFormats: const {
        CalendarFormat.week: 'Week',
      },
    );
  }

  Future<DataTasks> getTasks(String firstDay) async {
    await basicAuthUp2
        .signIn(widget.login, widget.password)
        .then((value) async => {
              errorMessage = value.message,
              await basicAuthUp2
                  .getTasks(value.data.token, value.data.id, firstDay)
                  .then((value) => {dataTask = value})
            });

    return dataTask;
  }

  Widget _waitingScreen() {
    return Container(
      alignment: Alignment.center,
      child: CircularProgressIndicator(),
    );
  }

  Widget _showErrorMessage() {
    if (errorMessage != null && errorMessage.length > 0) {
      return new Container(
          padding: const EdgeInsets.fromLTRB(60.0, 100.0, 0.0, 0.0),
          child: Text(
            errorMessage,
            style: TextStyle(
              fontSize: 15,
              color: Colors.black38,
              height: 5.0,
              fontWeight: FontWeight.w300,
            ),
          ));
    } else {
      return new Container(
        height: 0.0,
      );
    }
  }

  Widget getTaskTable() {
    return Container(
        child: FutureBuilder(
      future: getTasks(startDay1),
      builder: (context, AsyncSnapshot<DataTasks> snapshot) {
        if (errorMessage != null && errorMessage.length > 0) {
          return _showErrorMessage();
        }
        if (snapshot.hasData) {
          var task = dataTask.tasks.tasks
              .where((element) => element.number == widget.task.number)
              .first;
          return new TablePageTask(tasks: task);
        } else {
          return _waitingScreen();
        }
      },
    ));
  }

  Widget appBar() {
    return AppBar(
      centerTitle: true,
      title: Text(
        widget.task.title,
        style: TextStyle(color: Colors.orange, fontSize: 10.0),
        textAlign: TextAlign.justify,
      ),
    );
  }

  Widget scafold() {
    return Scaffold(
        appBar: appBar(),
        body: ListView(
          padding: EdgeInsets.zero,
          addAutomaticKeepAlives: false,
          children: <Widget>[
            calendar(),
            getTaskTable(),
            Tracking(
              task: task,
              login: widget.login,
              password: widget.password,
              notifyParent: refresh,
            )
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return scafold();
  }
}
