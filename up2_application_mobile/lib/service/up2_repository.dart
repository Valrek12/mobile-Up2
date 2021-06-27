import 'package:up2_application_mobile/models/data_items.dart';
import 'package:up2_application_mobile/models/data_tasks.dart';
import 'package:up2_application_mobile/models/time_object.dart';
import 'package:up2_application_mobile/models/user_credentionals.dart';
import 'package:up2_application_mobile/models/user_details.dart';
import 'package:up2_application_mobile/service/up2_provider.dart';

class Up2Repository {
  Up2Provider up2provider = new Up2Provider();

  Future<UserDetails> getCurrentUser(String token) =>
      up2provider.getCurrentUser(token);

  Future<UserCred> signIn(String login, String password) =>
      up2provider.signIn(login, password);

  Future<DataTasks> getTasks(String token, String userId, String period) =>
      up2provider.getTasks(token, userId, period);

  Future<TimeObject> updateTime(
          String token,
          String businessObjectId,
          String sign,
          String comment,
          String date,
          bool force,
          int hours,
          int minutes,
          String userId) =>
      up2provider.updateTimeObject(token, businessObjectId, sign, comment, date,
          force, hours, minutes, userId);

  Future<DataItems> getBusiness(String task, String login, String password) =>
      up2provider.getBusiness(task, login, password);
}
