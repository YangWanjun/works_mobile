import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:works_mobile/utils/NavigationService.dart';
import 'package:works_mobile/utils/common.dart';
import 'package:works_mobile/utils/locator.dart';
import 'package:works_mobile/views/account/LoginView.dart';
import 'package:works_mobile/views/home/StatsListView.dart';
import 'package:works_mobile/views/task/WorkflowListView.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");
}

void main() {
  setupLocator();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EB Work',
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginView(),
        '/home': (context) => StatsListView(),
        '/task/workflows': (context) => WorkflowListView(),
      },
      navigatorKey: locator<NavigationService>().navigatorKey,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder(
        future: jwtOrEmpty,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return LoginView();
          } else if (snapshot.data != "") {
            var jwt = snapshot.data;
            if (jwt != null) {
              return StatsListView();
            } else {
              return LoginView();
            }
          } else {
            return LoginView();
          }
        },
      ),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
    );
  }
}
