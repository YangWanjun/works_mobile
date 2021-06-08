import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:works_mobile/utils/authentication.dart';
import 'package:works_mobile/utils/constants.dart' as Constants;
import 'package:works_mobile/utils/CustomColors.dart';
import 'package:works_mobile/views/home/StatsListView.dart';
import 'package:works_mobile/widgets/GoogleSignInButton.dart';

final storage = FlutterSecureStorage();

class LoginView extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('ログイン'),),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(24),
                child: FutureBuilder(
                  future: Authentication.initializeFirebase(context: context),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text('Error initializing Firebase');
                    } else if (snapshot.connectionState == ConnectionState.done) {
                      return GoogleSignInButton();
                    }
                    return CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        CustomColors.firebaseOrange,
                      ),
                    );
                  },
                ),
              ),
              const Divider(
                height: 10,
                thickness: 2,
              ),
              Container(
                padding: EdgeInsets.all(24),
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
                    SizedBox(
                      height: 24,
                    ),
                    Container(
                      width: double.infinity,
                      child: ElevatedButton(
                        child: Text('ログイン'),
                        onPressed: () async {
                          var username = _usernameController.text;
                          var password = _passwordController.text;
                          var jwt = await attemptLogIn(username, password);
                          if(jwt != null) {
                            storage.write(key: Constants.ACCESS_TOKEN, value: jwt);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => StatsListView()
                                )
                            );
                          } else {
                            displayDialog(context, "An Error Occurred", "No account was found matching that username and password");
                          }
                        },
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        )
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
        Uri.parse(Constants.API_LOGIN),
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
