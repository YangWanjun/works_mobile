import 'dart:convert';

import 'package:works_mobile/entities/TaskField.dart';
import 'package:works_mobile/utils/ajax.dart';
import 'package:works_mobile/utils/constants.dart' as Constants;

const String API_CREATE_TASK = "${Constants.HOST_API}/api/task/tasks/";

class TaskApi {
  static Future<String> createTask(Map<String, dynamic> data) {
    return Ajax.post(API_CREATE_TASK, data);
  }

  static Future<String> changeTask(int taskId, Map<String, dynamic> data) {
    return Ajax.put('${Constants.HOST_API}/api/task/tasks/${taskId}/', data);
  }

  static Future<void> deleteTask(int taskId) {
    return Ajax.delete('${Constants.HOST_API}/api/task/tasks/${taskId}/');
  }

  static Future<List<TaskField>> getTaskForm(int taskId) {
    return Ajax.get('${Constants.HOST_API}/api/task/tasks/${taskId}/form/')
        .then((data) => TaskField.fromJsonList(json.decode(data)));
  }

  /**
   * タスクを承認する
   */
  static Future<String> approvalNode(int taskId, int nodeId) {
    return Ajax.put('${Constants.HOST_API}/api/task/tasks/${taskId}/nodes/${nodeId}/approval/', {});
  }

  /**
   * タスクを差戻す
   */
  static Future<String> undoNode(int taskId, int nodeId, String reason) {
    return Ajax.put('${Constants.HOST_API}/api/task/tasks/${taskId}/nodes/${nodeId}/undo/', {
      reason: reason
    });
  }

  static Future<String> getTaskUndoInfo(int taskId) {
    return Ajax.get('${Constants.HOST_API}/api/task/tasks/${taskId}/undo-info/');
  }
}