import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:works_mobile/utils/common.dart' as common;
import 'NavigationService.dart';
import 'locator.dart';

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

  static Future<String> post(String url, Map<String, dynamic> body) {
    return getJwt()
      .then((jwt) => http.post(Uri.parse(url), headers: {
        "Authorization": "JWT ${jwt}",
        "Content-Type": "application/json",
      }, body: json.encode(body)))
      .then((response) {
        if (response.statusCode >= 200 && response.statusCode < 400) {
          // JSONの文字列を返す
          return utf8.decode(response.bodyBytes);
        } else {
          throw utf8.decode(response.bodyBytes);
        }
      });
  }

  static Future<String> getJwt() {
    return common.jwtOrEmpty.then((jwt) {
      if (jwt != "") {
        return jwt;
      } else {
        final NavigationService _navigationService = locator<NavigationService>();
        _navigationService.pushNamed('/login');
        return new Future.error({"error": true});
      }
    });
  }
}
