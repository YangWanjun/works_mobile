import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:works_mobile/utils/constants.dart' as Constants;
import 'package:works_mobile/views/home/StatsListView.dart';

final storage = FlutterSecureStorage();

class LoginView extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('ログイン'),),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'ユーザー名'
              ),
            ),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'パスワード'
              ),
            ),
            TextButton(
              onPressed: () async {
                var username = _usernameController.text;
                var password = _passwordController.text;
                var jwt = await attemptLogIn(username, password);
                if(jwt != null) {
                  storage.write(key: "access_token", value: jwt);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => StatsListView(jwt)
                      )
                  );
                } else {
                  displayDialog(context, "An Error Occurred", "No account was found matching that username and password");
                }
              },
              child: Text('ログイン'),
            )
          ],
        ),
      ),
    );
  }

  void displayDialog(BuildContext context, String title, String text) =>
    showDialog(
      context: context,
      builder: (context) =>
        AlertDialog(
          title: Text(title),
          content: Text(text)
        ),
    );

  Future<String?> attemptLogIn(String username, String password) async {
    var res = await http.post(
        Uri.parse("${Constants.HOST_API}/api/token-auth/"),
        body: {
          "username": username,
          "password": password
        }
    );
    if(res.statusCode == 200) {
      Map<String, dynamic> jwt = json.decode(res.body);
      return jwt["token"];
    };
    return null;
  }
}
