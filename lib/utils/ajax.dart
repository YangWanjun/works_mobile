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
    return _request('get', url, {});
  }

  static Future<String> post(String url, Map<String, dynamic> body) {
    return _request('post', url, body);
  }

  static Future<String> put(String url, Map<String, dynamic> body) {
    return _request('put', url, body);
  }

  static Future<String> delete(String url) {
    return _request('delete', url, {});
  }

  static Future<String> _request(String method, String url, Map<String, dynamic> body) {
    return getJwt().then((jwt) {
      var headers = {
        "Authorization": "JWT ${jwt}",
        "Content-Type": "application/json",
      };
      if (method == 'get') {
        return http.get(Uri.parse(url), headers: {"Authorization": "JWT ${jwt}"});
      } else if (method == 'post') {
        return http.post(Uri.parse(url), headers: headers, body: json.encode(body));
      } else if (method == 'put') {
        return http.put(Uri.parse(url), headers: headers, body: json.encode(body));
      } else if (method == 'delete') {
        return http.delete(Uri.parse(url), headers: headers);
      } else {
        return new Future.error({"error": true});
      }
    }).then((response) {
      if (response.statusCode >= 200 && response.statusCode < 400) {
        // JSONの文字列を返す
        return utf8.decode(response.bodyBytes);
      } else if (response.statusCode == 401) {
        final NavigationService _navigationService = locator<NavigationService>();
        _navigationService.pushNamed('/login');
        common.setJwt("");
        return new Future.error({"error": true});
      } else {
        throw Exception('Failed to call api');
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
