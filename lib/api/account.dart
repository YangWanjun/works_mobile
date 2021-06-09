import 'dart:convert';

import 'package:works_mobile/entities/UserProfile.dart';
import 'package:works_mobile/utils/ajax.dart';
import 'package:works_mobile/utils/constants.dart' as Constants;

const String API_ACCOUNT_ME = "${Constants.HOST_API}/api/account/me/";

class Account {
  static Future<UserProfile> getMe() async {
    final res = await Ajax.post(API_ACCOUNT_ME, null);
    Map<String, dynamic> data = json.decode(res);
    // ログイン情報を格納する
    storage.write(key: Constants.KEY_USER, value: json.encode(data['me']));
    return UserProfile.fromJson(data['me']);
  }
}