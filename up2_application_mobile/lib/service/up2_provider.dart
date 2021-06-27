import 'dart:convert';

import 'package:up2_application_mobile/models/data_items.dart';
import 'package:up2_application_mobile/models/data_tasks.dart';
import 'package:up2_application_mobile/models/time_object.dart';
import 'package:up2_application_mobile/models/user_credentionals.dart';
import 'package:http/http.dart' as http;
import 'package:up2_application_mobile/models/user_details.dart';
import 'package:up2_application_mobile/service/constants.dart';

class Up2Provider {
  Future<UserDetails> getCurrentUser(String token) async {
    final response = await http.get(Constants.userApi,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'token': token
        });
    if (response.statusCode == 200) {
      return UserDetails.fromJson(jsonDecode(response.body));
    }
    return null;
  }

  Future<UserCred> signIn(String login, String password) async {
    try {
      if (login.isNotEmpty && password.isNotEmpty) {
        final response = await http.post(
          'https://mng.logrocon.ru/tt/api/user/login',
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(
              <String, String>{'login': login, 'password': password}),
        );
        if (response.statusCode == 200) {
          return UserCred.fromJson(jsonDecode(response.body));
        } else {
          // If the server did not return a 201 CREATED response,
          // then throw an exception.
          return null;
        }
      }
    } catch (Ex) {
      return UserCred(message: "Отсутствует подключение к сети");
    }
  }

  Future<DataItems> getBusinessObject(String token, String task) async {
    var queryParameters = {
      'task': task,
    };
    var uri =
        Uri.https('mng.logrocon.ru', Constants.businesObject, queryParameters);
    final response = await http.get(uri, headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'token': token
    });

    if (response.statusCode == 200) {
      return DataItems.fromJson(jsonDecode(response.body));
    } else {
      return null;
    }
  }

  Future<DataTasks> getTasks(String token, String userId, String period) async {
    var queryParameters = {
      'period': period,
      'userId': userId,
    };
    var uri =
        Uri.https('mng.logrocon.ru', Constants.periodApi, queryParameters);
    final response = await http.get(uri, headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'token': token
    });
    if (response.statusCode == 200) {
      return DataTasks.fromJson(jsonDecode(response.body));
    } else {
      return null;
    }
  }

  Future<DataItems> getBusiness(
      String task, String login, String password) async {
    var asyncGetTasks;
    await signIn(login, password).then((value) async => {
          if (value.message == null)
            await getBusinessObject(value.data.token, task)
                .then((value) => {asyncGetTasks = value})
        });
    return asyncGetTasks;
  }

  Future<WorkObject> addWork(String token, String taskId, String userId,
      String periodStartDate) async {
    final response = await http.post(Constants.addWork,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'token': token
        },
        body: jsonEncode(<String, Object>{
          'periodStartDate': periodStartDate,
          'taskId': taskId,
          'userId': userId
        }));

    if (response.statusCode == 200) {
      return WorkObject.fromJson(jsonDecode(response.body));
    } else {
      return null;
    }
  }

  Future<TimeObject> updateTimeObject(
      String token,
      String businessObjectId,
      String sign,
      String comment,
      String date,
      bool force,
      int hours,
      int minutes,
      String userId) async {
    final response = await http.post(
      Constants.timeApi,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'token': token
      },
      body: jsonEncode(<String, Object>{
        'businessObjectId': businessObjectId,
        'comment': comment,
        'date': date,
        'force': force,
        'hours': hours,
        'minutes': minutes,
        'sign': sign,
        'userId': userId
      }),
    );
    if (response.statusCode == 200) {
      return TimeObject.fromJson(jsonDecode(response.body));
    } else {
      return null;
    }
  }
}
