import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:up2_application_mobile/bloc/task/task_bloc.dart';
import 'package:up2_application_mobile/bloc/task/task_state.dart';
import 'package:up2_application_mobile/models/task.dart';
import 'package:up2_application_mobile/models/time_object.dart';
import 'package:up2_application_mobile/service/up2_provider.dart';
import 'package:up2_application_mobile/utils/color_page.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:up2_application_mobile/utils/date_converter.dart';

class TableSearhed extends StatefulWidget {
  final String userInfo;
  final String login;
  final String password;

  const TableSearhed({Key key, this.userInfo, this.login, this.password})
      : super(key: key);
  TableSerchedPageState createState() => TableSerchedPageState();
}

class TableSerchedPageState extends State<TableSearhed> {
  bool sort;
  bool ascending = true;
  int sortColumnIndex;
  bool selected = false;
  String taskId;
  final Color appColor = HexColor.fromHex('#242424');
  ProgressDialog pr;
  String periodDate;
  Up2Provider up2provider = new Up2Provider();
  WorkObject workObject;

  @override
  void initState() {
    periodDate = DateConverter.firstDayOfMonthDayOfWeekDef();
    sortColumnIndex = 0;
    sort = true;
    super.initState();
  }

  Future<WorkObject> updateTime(
      String taskId, String userId, String periodStartDate) async {
    var timeObject;
    await up2provider
        .signIn(widget.login, widget.password)
        .then((value) async => {
              await up2provider
                  .addWork(value.data.token, taskId, userId, periodStartDate)
                  .then((value) => {timeObject = value})
            });
    return timeObject;
  }

  addWork() {
    pr.show();
    updateTime(taskId, widget.userInfo, periodDate).then((value) =>
        {workObject = value, pr.hide().then((value) => setState(() {}))});
  }

  Widget getStatus() {
    if (workObject != null) {
      if (workObject.data) {
        return Text(
          'Задача успешно добавлена!',
          style: TextStyle(color: Colors.orange, fontSize: 12.0),
        );
      } else {
        return Text(
          'Не удалось добавить задачу!',
          style: TextStyle(color: Colors.orange, fontSize: 12.0),
        );
      }
    }
    return Text('');
  }

  Widget outButton() {
    return RaisedButton.icon(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      label: Text(
        'Назад',
        style: TextStyle(color: Colors.orange),
      ),
      icon: Icon(
        Icons.transit_enterexit_outlined,
        color: Colors.white,
      ),
      onPressed: () => Navigator.pop(context),
      textColor: Colors.white,
      splashColor: Colors.orange,
      color: appColor,
    );
  }

  Widget addButton() {
    return RaisedButton.icon(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      label: Text(
        'Взять в работу',
        style: TextStyle(color: Colors.orange),
      ),
      icon: Icon(
        Icons.add_box,
        color: Colors.white,
      ),
      onPressed: () => addWork(),
      textColor: Colors.white,
      splashColor: Colors.orange,
      color: appColor,
    );
  }

  Widget datable(List<Task> listOfColumns) {
    return DataTable(
      showBottomBorder: true,
      columnSpacing: 20,
      dataRowHeight: 60,
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
            label: Text(
              'Задача',
              softWrap: true,
            ),
            onSort: (columnIndex, ascending) {
              setState(() {
                sortColumnIndex = 1;
                sort = !sort;
              });
            }),
      ],
      rows: listOfColumns
          .map(
            ((element) => DataRow(
                  cells: <DataCell>[
                    DataCell(Text(element.number.toString())),
                    DataCell(
                      Text(element.title, softWrap: true),
                      onTap: () => {
                        setState(() {
                          taskId = element.id;
                        }),
                        showModalBottomSheet<void>(
                            context: context,
                            builder: (BuildContext context) {
                              return Wrap(
                                children: <Widget>[
                                  Center(
                                      child: Text(
                                    element.title,
                                    textAlign: TextAlign.center,
                                    softWrap: true,
                                    style: TextStyle(fontSize: 15.0),
                                  )),
                                  ButtonBar(
                                    alignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      addButton(),
                                      outButton()
                                    ],
                                  )
                                ],
                              );
                            })
                      },
                    ),
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

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskBloc, TaskState>(builder: (context, state) {
      if (state is TaskEmptyState) {
        return Center(child: Text('Выполните поиск'));
      }

      if (state is TaskLoadingState) {
        return Center(child: CircularProgressIndicator());
      }

      if (state is TaskLoadedState) {
        List<Task> sortTask;
        if (sortColumnIndex == 0) {
          sortTask = onSort(state.loadTask.tasks.tasks);
        } else {
          sortTask = onSortTitle(state.loadTask.tasks.tasks);
        }

        pr = new ProgressDialog(context);
        pr.style(
            message: 'Please Waiting...',
            borderRadius: 10.0,
            backgroundColor: Colors.white,
            progressWidget: CircularProgressIndicator(),
            elevation: 10.0,
            insetAnimCurve: Curves.easeInOut,
            progress: 0.0,
            maxProgress: 100.0,
            progressTextStyle: TextStyle(
                color: Colors.black,
                fontSize: 13.0,
                fontWeight: FontWeight.w400),
            messageTextStyle: TextStyle(
                color: Colors.black,
                fontSize: 19.0,
                fontWeight: FontWeight.w600));

        return Wrap(
            children: <Widget>[datable(sortTask), Center(child: getStatus())]);
      }

      if (state is TaskErrorState) {
        return Center(
          child: Text(
            'Error fetching users',
            style: TextStyle(fontSize: 20.0),
          ),
        );
      }
      return null;
    });
  }
}
