import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:works_mobile/utils/constants.dart' as Constants;

final storage = FlutterSecureStorage();

Future<String> get jwtOrEmpty async {
  var jwt = await storage.read(key: Constants.ACCESS_TOKEN);
  if(jwt == null) return "";
  return jwt;
}
