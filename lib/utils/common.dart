import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:works_mobile/utils/constants.dart' as Constants;
import 'package:path/path.dart' as p;

final storage = FlutterSecureStorage();

enum Toast {
  SUCCESS,
  INFO,
  WARN,
  ERROR,
}

Future<String> get jwtOrEmpty async {
  var jwt = await storage.read(key: Constants.ACCESS_TOKEN);
  if(jwt == null) return "";
  return jwt;
}

Future<void> setJwt(String jwt) {
  return storage.write(key: Constants.ACCESS_TOKEN, value: jwt);
}

Future<String?> getMe() {
  return storage.read(key: Constants.KEY_USER);
}

Future<void> setMe(String data) {
  return storage.write(key: Constants.KEY_USER, value: data);
}

Future<void> clearStorage() {
  return storage.deleteAll();
}

SnackBar errorSnackBar({required String content}) {
  return customSnackBar(content: content, toast: Toast.ERROR);
}

SnackBar successSnackBar({required String content}) {
  return customSnackBar(content: content, toast: Toast.SUCCESS);
}

SnackBar infoSnackBar({required String content}) {
  return customSnackBar(content: content, toast: Toast.INFO);
}

SnackBar warnSnackBar({required String content}) {
  return customSnackBar(content: content, toast: Toast.WARN);
}

SnackBar customSnackBar({required String content, required Toast toast}) {
  return SnackBar(
    backgroundColor: getToastStyle(toast),
    content: Text(
      content,
      style: TextStyle(color: Colors.white, letterSpacing: 0.5),
    ),
  );
}

Color getToastStyle(Toast toast) {
  switch (toast) {
    case Toast.SUCCESS:
      return Colors.teal;
    case Toast.INFO:
      return Colors.white70;
    case Toast.WARN:
      return Colors.yellowAccent;
    case Toast.ERROR:
      return Colors.redAccent;
    default:
      return Colors.white70;
  }
}

String getFileExtension(String path) {
  return p.extension(path);
}

String getChoiceText(String value, List choice) {
  var item = choice.firstWhere((element) => element['value'] == value);
  if (item != null) {
    return item['text'];
  } else {
    return "";
  }
}

void displayConfirm({
  required BuildContext context,
  required String content,
  required Function callback,
}) =>
  displayDialog(
    context: context,
    title: "確認",
    content: Text(content),
    autoClose: true,
    callback: callback,
  );

void displayDialog({
  required BuildContext context,
  required String title,
  required Widget content,
  required bool autoClose,
  required Function callback,
}) =>
  showDialog(
    context: context,
    builder: (context) =>
      AlertDialog(
        title: Text(title),
        content: content,
        actions: <Widget>[
          TextButton(
            child: Text("取消"),
            onPressed: () => Navigator.pop(context),
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all(
                Colors.redAccent,
              ),
            ),
          ),
          TextButton(
            child: Text("確定"),
            onPressed: () {
              if (autoClose) {
                Navigator.pop(context);
              }
              callback();
            },
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all(
                Colors.indigo,
              ),
            ),
          ),
        ],
      ),
  );
