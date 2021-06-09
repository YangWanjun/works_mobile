import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:works_mobile/utils/constants.dart' as Constants;

const storage = FlutterSecureStorage();

class Ajax {
  static Future<http.Response> getWithoutAuth(String url) {
    return http.get(Uri.parse(url));
  }

  static Future<String> get(String url) {
    return getJwt()
      .then((jwt) => http.get(Uri.parse(url), headers: {"Authorization": "JWT ${jwt}"}))
      .then((response) {
        if (response.statusCode >= 200 && response.statusCode < 400) {
          // JSONの文字列を返す
          return utf8.decode(response.bodyBytes);
        } else {
          throw Exception('Failed to call api');
        }
      });
  }

  static Future<String> post(String url, Object? body) {
    return getJwt()
      .then((jwt) => http.post(Uri.parse(url), headers: {"Authorization": "JWT ${jwt}"}, body: body))
      .then((response) {
        if (response.statusCode >= 200 && response.statusCode < 400) {
          // JSONの文字列を返す
          return utf8.decode(response.bodyBytes);
        } else {
          throw Exception('Failed to call api');
        }
      });
  }

  static Future<String> getJwt() {
    return storage.read(key: Constants.ACCESS_TOKEN).then((jwt) {
      if (jwt != null) {
        return jwt;
      } else {
        return new Future.error({"error": true});
      }
    });
  }
}
