import 'package:works_mobile/utils/ajax.dart';
import 'package:works_mobile/utils/constants.dart' as Constants;

const String API_CREATE_TASK = "${Constants.HOST_API}/api/task/tasks/";

class Task {
  static Future<String> createTask(Map<String, dynamic> data) {
    return Ajax.post(API_CREATE_TASK, data);
  }
}