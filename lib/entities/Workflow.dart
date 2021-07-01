import 'dart:convert';

import 'package:works_mobile/utils/ajax.dart';
import 'package:works_mobile/utils/constants.dart' as Constants;

const String API_WORKFLOW_LIST = "${Constants.HOST_API}/api/task/workflows/";

class Workflow {
  final String code;
  final String name;
  final bool is_active;
  final String? comment;

  Workflow({
    required this.code,
    required this.name,
    required this.is_active,
    this.comment,
  });

  factory Workflow.fromJson(Map<String, dynamic> data) {
    return Workflow(
      code: data['code'],
      name: data['name'],
      is_active: data['is_active'],
      comment: data['comment'],
    );
  }

  static List<Workflow> fromJsonList(Iterable dataArray) {
    return dataArray.map((data) => Workflow.fromJson(data)).toList();
  }

  static Future<List<Workflow>> list() async {
    final res = await Ajax.get(API_WORKFLOW_LIST);
    Map<String, dynamic> data = json.decode(res);
    // ログイン情報を格納する
    return Workflow.fromJsonList(data['results']);
  }

  static Future<Workflow> getById(String code) {
    return Ajax.get("${Constants.HOST_API}/api/task/workflows/${code}/")
      .then((res) => Workflow.fromJson(json.decode(res)));
  }
}