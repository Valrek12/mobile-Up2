import 'package:flutter/material.dart';
import 'package:up2_application_mobile/models/data_tasks.dart';
import 'package:up2_application_mobile/models/task.dart';
import 'package:up2_application_mobile/models/tasks.dart';
import 'package:up2_application_mobile/pages/tracker_page.dart';
import 'package:up2_application_mobile/utils/color_page.dart';
import 'package:percent_indicator/percent_indicator.dart';

class TablePage extends StatefulWidget {
  final Future Function() notifyParent;
  final DataTasks dataTasks;
  final int weekDay;
  final String login;
  final String password;
  final String selectDay;
  final String searchTream;
  const TablePage({
    Key key,
    this.dataTasks,
    this.weekDay,
    this.login,
    this.password,
    this.selectDay,
    this.searchTream,
    @required this.notifyParent,
  }) : super(key: key);

  TablePageState createState() => TablePageState();
}

class TablePageState extends State<TablePage> {
  final Color appColor = HexColor.fromHex('#242424');
  DataTasks dataTasks;
  bool sort;
  bool ascending = false;
  int sortColumnIndex;
  TextEditingController controller = TextEditingController();
  String _searchResult = '';

  @override
  void initState() {
    sortColumnIndex = 0;
    sort = false;
    dataTasks = widget.dataTasks;
    super.initState();
    onSort(widget.dataTasks.tasks.tasks);
  }

  List<Task> onSort(List<Task> listTasks) {
    if (sortColumnIndex == 0) {
      if (sort) {
        listTasks.sort((a, b) => a.number.compareTo(b.number));
      } else {
        listTasks.sort((a, b) => b.number.compareTo(a.number));
      }
    }
    return listTasks.toList();
  }

  List<Task> onSortTitle(List<Task> listTasks) {
    if (sortColumnIndex == 1) {
      if (sort) {
        listTasks.sort((a, b) => a.title.compareTo(b.title));
      } else {
        listTasks.sort((a, b) => b.title.compareTo(a.title));
      }
    }
    return listTasks.toList();
  }

  List<Task> onSearch(DataTasks dataTasks) {
    {
      if (_searchResult != null && _searchResult.isNotEmpty) {
        List<Task> newlist = dataTasks.tasks.tasks
            .where((value) =>
                value.id.toLowerCase().contains(_searchResult) ||
                value.number.toString().toLowerCase().contains(_searchResult) ||
                value.title.toLowerCase().contains(_searchResult))
            ?.toList();
        return newlist;
      } else {
        return dataTasks.tasks.tasks.toList();
      }
    }
  }

  Widget getCard() {
    return Card(
      child: new ListTile(
          leading: new Icon(Icons.search),
          title: new TextField(
            controller: controller,
            decoration: new InputDecoration(
                hintText: 'Search', border: InputBorder.none),
            onChanged: (value) {
              setState(() {
                _searchResult = value;
              });
            },
          ),
          trailing: new IconButton(
              icon: new Icon(Icons.cancel),
              onPressed: () {
                setState(() {
                  controller.clear();
                  _searchResult = '';
                });
              })),
    );
  }

  Widget datable(List<Task> listOfColumns, int weekDay) {
    return DataTable(
      columnSpacing: 20,
      dataRowHeight: 50,
      sortAscending: sort,
      sortColumnIndex: sortColumnIndex,
      columns: <DataColumn>[
        DataColumn(
            label: Text('Id'),
            onSort: (columnIndex, ascending) {
              setState(() {
                sortColumnIndex = 0;
                sort = !sort;
              });
            }),
        DataColumn(
            label: Text('Задача'),
            onSort: (columnIndex, ascending) {
              setState(() {
                sortColumnIndex = 1;
                sort = !sort;
              });
            }),
        DataColumn(label: Text('Всего')),
      ],
      rows: listOfColumns
          .map(
            ((element) => DataRow(
                  selected: listOfColumns.contains(element),
                  cells: <DataCell>[
                    DataCell(Text(element.number.toString())),
                    DataCell(
                      Text(element.title),
                      onTap: () => {
                        showModalBottomSheet<void>(
                            context: context,
                            builder: (BuildContext context) {
                              return Container(
                                child: new Tracking(
                                  selectDay: widget.selectDay,
                                  login: widget.login,
                                  password: widget.password,
                                  task: element,
                                  notifyParent: widget.notifyParent,
                                ),
                              );
                            })
                      },
                    ),
                    DataCell(Text(element.weekWriteOffTimes[weekDay])),
                  ],
                  color: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                    if (element.state == "В работе") return Colors.white;
                    return null;
                  }),
                )),
          )
          .toList(),
    );
  }

  double getSummDay(Tasks tasks) {
    double summ = 0;
    tasks.tasks.forEach((element) {
      double hourse;
      double minute;
      double result;
      String time = element.weekWriteOffTimes[widget.weekDay];
      if (time.toString().contains('-')) {
        minute = double.parse(time.toString().substring(3)) / 60;
        hourse = double.parse(time.toString().substring(0, 2));
        result = hourse - minute;
      } else {
        minute = double.parse(time.toString().substring(2)) / 60;
        hourse = double.parse(time.toString().substring(0, 1));
        result = minute + hourse;
      }

      summ += result;
    });

    return num.parse(summ.toStringAsFixed(2));
  }

  double getSummWeek(Tasks tasks) {
    double summ = 0;
    tasks.tasks.forEach((element) {
      element.weekWriteOffTimes.forEach((time) {
        double hourse;
        double minute;
        double result;
        if (time.toString().contains('-')) {
          minute = double.parse(time.toString().substring(3)) / 60;
          hourse = double.parse(time.toString().substring(0, 2));
          result = hourse - minute;
        } else {
          minute = double.parse(time.toString().substring(2)) / 60;
          hourse = double.parse(time.toString().substring(0, 1));
          result = minute + hourse;
        }

        summ += result;
      });
    });
    return num.parse(summ.toStringAsFixed(2));
  }

  double getPrecentWeek() {
    double summ = getSummWeek(widget.dataTasks.tasks);
    if (summ > 0.0) {
      double precent = (summ / 40.0 * 100) / 100;
      return precent;
    }
    return 0.0;
  }

  double getPrecentDay() {
    double summ = getSummDay(widget.dataTasks.tasks);
    if (summ > 0.0) {
      double precent = (summ / 8 * 100) / 100;
      return precent;
    }
    return 0.0;
  }

  @override
  Widget build(BuildContext context) {
    List<Task> tasks = onSearch(widget.dataTasks);
    List<Task> sortTask;
    if (sortColumnIndex == 0) {
      sortTask = onSort(tasks);
    } else {
      sortTask = onSortTitle(tasks);
    }
    return Wrap(
      children: <Widget>[
        Center(
          child: Container(
              width: 350,
              height: 100,
              decoration: BoxDecoration(
                  color: appColor,
                  border: Border.all(color: Colors.grey, width: 5.0),
                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
              child: Wrap(
                children: <Widget>[
                  ButtonBar(
                    alignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Text(
                        'Время за неделю:',
                        style: TextStyle(color: Colors.orange, fontSize: 17.0),
                      ),
                      Text(
                        getSummWeek(widget.dataTasks.tasks).toString(),
                        style: TextStyle(color: Colors.white, fontSize: 17.0),
                      ),
                      CircularPercentIndicator(
                        radius: 30.0,
                        animation: true,
                        percent: getPrecentWeek(),
                        animationDuration: 1200,
                        circularStrokeCap: CircularStrokeCap.round,
                        progressColor: Colors.orange,
                        backgroundColor: Colors.grey,
                      )
                    ],
                  ),
                  ButtonBar(
                    alignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Text(
                        'Время за день: ',
                        style: TextStyle(
                            color: Colors.orange,
                            fontSize: 17.0,
                            wordSpacing: 7.0),
                      ),
                      Text(
                        getSummDay(widget.dataTasks.tasks).toString(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17.0,
                        ),
                      ),
                      CircularPercentIndicator(
                        radius: 30.0,
                        animation: true,
                        percent: getPrecentDay(),
                        animationDuration: 1200,
                        circularStrokeCap: CircularStrokeCap.round,
                        progressColor: Colors.orange,
                        backgroundColor: Colors.grey,
                      )
                    ],
                  )
                ],
              )),
        ),
        new Container(child: getCard()),
        datable(sortTask, widget.weekDay)
      ],
    );
    //datable(tasks, widget.weekDay),
  }
}
