import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:works_mobile/utils/constants.dart' as Constants;

const storage = FlutterSecureStorage();

class Ajax {
  static Future<http.Response> get(String url) {
    return storage.read(key: Constants.ACCESS_TOKEN)
        .then((jwt) => http.get(Uri.parse(url), headers: {"Authorization": "JWT ${jwt}"}));
  }
}
