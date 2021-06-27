import 'package:flutter/material.dart';
import 'package:up2_application_mobile/bloc/task/task_bloc.dart';
import 'package:up2_application_mobile/models/data_tasks.dart';
import 'package:up2_application_mobile/service/up2_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:up2_application_mobile/widgets/action_buttons.dart';
import 'package:up2_application_mobile/widgets/table_searched.dart';

class SearchTaskPage extends StatefulWidget {
  final String login;
  final String password;
  final String userInfo;

  const SearchTaskPage({Key key, this.login, this.password, this.userInfo})
      : super(key: key);
  SearchTaskPageState createState() => SearchTaskPageState();
}

class SearchTaskPageState extends State<SearchTaskPage> {
  final up2repository = Up2Repository();
  DataTasks asyncGetTasks;
  var refreshKey = GlobalKey<RefreshIndicatorState>();
  TextEditingController controller = TextEditingController();
  TaskBloc taskBloc;
  String _searchResult = '';

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  Widget getCard() {
    return Card(
      child: new ListTile(
          leading: new Icon(Icons.search),
          title: new TextField(
            controller: controller,
            decoration: new InputDecoration(
                hintText: 'укажите id или наименование',
                border: InputBorder.none),
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

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
        value: new TaskBloc(
            password: widget.password,
            login: widget.login,
            up2repository: up2repository,
            task: _searchResult),
        child: ListView(
          children: <Widget>[
            getCard(),
            ActionButtons(),
            TableSearhed(
              login: widget.login,
              password: widget.password,
              userInfo: widget.userInfo,
            ),
          ],
        ));
  }
}
