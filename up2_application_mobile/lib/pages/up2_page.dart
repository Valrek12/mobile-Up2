import 'package:flutter/material.dart';
import 'package:up2_application_mobile/models/data_tasks.dart';
import 'package:up2_application_mobile/pages/table_page.dart';
import 'package:up2_application_mobile/service/up2_repository.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:up2_application_mobile/utils/date_converter.dart';

class Up2Page extends StatefulWidget {
  final String login;
  final String password;

  const Up2Page({Key key, this.login, this.password}) : super(key: key);
  Up2PagePageState createState() => Up2PagePageState();
}

class Up2PagePageState extends State<Up2Page> {
  final up2repository = Up2Repository();

  var _calendarController = CalendarController();
  DataTasks asyncGetTasks;
  String startDay;
  String selectedDay;
  int dayWeek;
  String errorMessage;
  var refreshKey = GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    errorMessage = null;
    asyncGetTasks = null;
    dayWeek = DateConverter.dayOfMonthDayOfWeek(DateTime.now());
    startDay = DateConverter.firstDayOfMonthDayOfWeek();
    selectedDay = DateConverter.selectDay(DateTime.now());
    super.initState();
  }

  Widget _waitingScreen() {
    return Container(
      alignment: Alignment.center,
      child: CircularProgressIndicator(),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<DataTasks> getTasks(String firstDay) async {
    await up2repository
        .signIn(widget.login, widget.password)
        .then((value) async => {
              errorMessage = value.message,
              if (errorMessage == null)
                await up2repository
                    .getTasks(value.data.token, value.data.id, firstDay)
                    .then((value) => {asyncGetTasks = value})
            });
    return asyncGetTasks;
  }

  Future<void> refresh() async {
    setState(() {});
  }

  Future<void> refreshList() async {
    refreshKey.currentState?.show(atTop: true);
    await getTasks(startDay);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: bodyListView(),
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

  Widget bodyListView() {
    return new ListView(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        addAutomaticKeepAlives: false,
        children: <Widget>[
          new TableCalendar(
            locale: 'ru',
            headerVisible: true,
            initialCalendarFormat: CalendarFormat.week,
            formatAnimation: FormatAnimation.slide,
            startingDayOfWeek: StartingDayOfWeek.monday,
            availableGestures: AvailableGestures.horizontalSwipe,
            calendarController: _calendarController,
            calendarStyle: CalendarStyle(selectedColor: Colors.orange),
            onVisibleDaysChanged: (dateTime, dateTime2, calendarFormat) {
              setState(() {
                startDay =
                    "${dateTime.day.toString().padLeft(2, '0')}.${dateTime.month.toString().padLeft(2, '0')}.${dateTime.year.toString().padLeft(2, '0')}";
              });
            },
            onDaySelected: (day, events, holidays) {
              setState(() {
                dayWeek = DateConverter.dayOfMonthDayOfWeek(day);
                selectedDay = DateConverter.selectDay(day);
              });
            },
            availableCalendarFormats: const {
              CalendarFormat.week: 'Week',
            },
          ),

          //вынести в отельный метод и обернуть в RefreshIndictor
          Container(
            child: FutureBuilder(
              future: getTasks(startDay),
              builder: (context, AsyncSnapshot<DataTasks> snapshot) {
                if (errorMessage != null && errorMessage.length > 0) {
                  return _showErrorMessage();
                }
                if (snapshot.hasData) {
                  return asyncGetTasks != null
                      ? RefreshIndicator(
                          backgroundColor: Colors.black,
                          key: refreshKey,
                          child: new TablePage(
                            dataTasks: snapshot.data,
                            weekDay: dayWeek,
                            login: widget.login,
                            password: widget.password,
                            selectDay: selectedDay,
                            notifyParent: refresh,
                          ),
                          onRefresh: refreshList)
                      : _waitingScreen();
                } else {
                  return _waitingScreen();
                }
              },
            ),
          ),
        ]);
  }
}
