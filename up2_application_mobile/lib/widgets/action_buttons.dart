import 'package:flutter/material.dart';
import 'package:up2_application_mobile/bloc/task/task_bloc.dart';
import 'package:up2_application_mobile/bloc/task/task_event.dart';
import 'package:up2_application_mobile/utils/color_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ActionButtons extends StatelessWidget {
  final Color appColor = HexColor.fromHex('#242424');

  @override
  Widget build(BuildContext context) {
    final TaskBloc taskBloc = BlocProvider.of<TaskBloc>(context, listen: true);
    return ButtonBar(
      alignment: MainAxisAlignment.center,
      children: <Widget>[
        ElevatedButton(
            onPressed: () {
              taskBloc.add(TaskLoadEvent());
            },
            style: ElevatedButton.styleFrom(
                primary: appColor, onPrimary: Colors.white),
            child: Text('Поиск',
                style: TextStyle(fontSize: 15, color: Colors.orange))),
      ],
    );
  }
}
