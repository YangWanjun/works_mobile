import 'dart:convert';

import 'package:works_mobile/entities/ResidenceStatus.dart';
import 'package:works_mobile/utils/ajax.dart';
import 'package:works_mobile/utils/constants.dart' as Constants;

class Employee {
  static Future<ResidenceStatus> getResidenceStatus(int employee) async {
    final res = await Ajax.get("${Constants.HOST_API}/api/employee/employees/${employee}/residence-status/");
    return ResidenceStatus.fromJson(json.decode(res));
  }

}