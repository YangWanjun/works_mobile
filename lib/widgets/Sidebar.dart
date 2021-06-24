import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:works_mobile/entities/UserProfile.dart';
import 'package:works_mobile/utils/NavigationService.dart';
import 'package:works_mobile/utils/locator.dart';
import 'package:works_mobile/utils/constants.dart' as Constants;

const storage = FlutterSecureStorage();

class Sidebar extends StatefulWidget {
  const Sidebar({Key? key, required this.drawerClose}) : super(key: key);

  final Function drawerClose;

  @override
  _SidebarState createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    return Container(
      color: Colors.white,
      width: mediaQuery.size.width * 0.60,
      height: mediaQuery.size.height,
      child: FutureBuilder(
        future: storage.read(key: Constants.KEY_USER),
        builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
          String email = '';
          late CircleAvatar avatar1;
          late ClipOval avatar2;
          if (snapshot.hasData) {
            String data = snapshot.data as String;
            UserProfile userProfile = UserProfile.fromJson(json.decode(data));
            email = userProfile.email;
            avatar2 = ClipOval(child: CachedNetworkImage(
              imageUrl: userProfile.avatar,
              placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) => Icon(Icons.person, size: 60,),
              width: 100,
            ));
          } else {
            avatar1 = CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/avatar.png'),
            );
          }
          final NavigationService _navigationService = locator<NavigationService>();
          return Column(
            children: <Widget>[
              Container(
                width: double.infinity,
                height: 200,
                color: Colors.grey.withAlpha(30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    snapshot.hasData ? avatar2 : avatar1,
                    SizedBox(
                      height: 10,
                    ),
                    Text(email)
                  ],
                )
              ),
              ListTile(
                onTap: () {
                  _navigationService.pushNamed('/home');
                },
                leading: Icon(Icons.home),
                title: Text("ホーム"),
              ),
              Divider(
                height: 1,
                color: Colors.grey,
              ),
              ListTile(
                onTap: () {
                  _navigationService.pushNamed('/task/workflows');
                },
                leading: Icon(Icons.article),
                title: Text("各種手続き"),
              ),
              Divider(
                height: 1,
                color: Colors.grey,
              ),

              ListTile(
                onTap: () {
                  debugPrint("Tapped Log Out");
                },
                leading: Icon(Icons.exit_to_app),
                title: Text("Log Out"),
              ),
            ],
          );
        },
      ),
    );
  }
}