import 'package:flutter/material.dart';
import 'package:works_mobile/utils/authentication.dart';
import 'package:works_mobile/views/account/LoginView.dart';

class TopBar extends StatelessWidget implements PreferredSizeWidget {
  TopBar({Key? key, required this.text, required this.callback}) : super(key: key);

  final String text;
  final VoidCallback callback;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(this.text),
      leading: GestureDetector(
        onTap: this.callback,
        child: Icon(Icons.menu),
      ),
      actions: <Widget>[IconButton(
        icon: Icon(Icons.logout),
        onPressed: () {
          Authentication.signOut(context: context);
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => LoginView()
              )
          );
        }, // The icon of your choice
      ),],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

}