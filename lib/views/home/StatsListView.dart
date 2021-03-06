import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foldable_sidebar/foldable_sidebar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:works_mobile/entities/TaskStatistics.dart';
import 'package:works_mobile/utils/ajax.dart';
import 'package:works_mobile/utils/constants.dart' as Constants;
import 'package:works_mobile/widgets/Sidebar.dart';
import 'package:works_mobile/widgets/StatsCard.dart';
import 'package:works_mobile/widgets/TopBar.dart';

class StatsListView extends StatefulWidget {
  StatsListView();

  @override
  State<StatsListView> createState() => _StatsListState();
}

class _StatsListState extends State<StatsListView> {
  late Future<TaskStatistics> futureTaskStatistics;
  FSBStatus _fsbStatus = FSBStatus.FSB_CLOSE;

  @override
  void initState() async {
    super.initState();
    futureTaskStatistics = fetchTaskStatistics();

    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    print('User granted permission: ${settings.authorizationStatus}');

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
    });

  }

  toggleOpen () {
    setState(() {
      _fsbStatus = _fsbStatus == FSBStatus.FSB_OPEN ?
      FSBStatus.FSB_CLOSE : FSBStatus.FSB_OPEN;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: TopBar(
          text: 'ホーム',
          callback: this.toggleOpen,
        ),
        body: FoldableSidebarBuilder(
          drawerBackgroundColor: Colors.cyan[100],
          drawer: Sidebar(
            drawerClose: () => {
              setState(() {
                _fsbStatus = FSBStatus.FSB_CLOSE;
              })
            },
          ),
          screenContents: StatsList(),
          status: _fsbStatus,
        )
      ),
    );
  }

  Future<TaskStatistics> fetchTaskStatistics() async {
    final data = await Ajax.get(Constants.API_TASK_STATS);

    return TaskStatistics.fromJson(jsonDecode(data));
  }

  Widget StatsList() {
    return Center(
      child: FutureBuilder(
          future: this.futureTaskStatistics,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              TaskStatistics data = snapshot.data as TaskStatistics;
              return ListView(
                children: <Widget>[
                  StatsCard(
                    title: '申請タスク数:${data.totalCount}',
                    description: 'いままで申請したタスク数',
                    icon: FontAwesomeIcons.handPointer,
                    link: null,
                  ),
                  StatsCard(
                    title: '処理中タスク数:${data.unresolvedCount}',
                    description: '現在処理中のタスク数',
                    icon: FontAwesomeIcons.handshake,
                    link: Constants.API_TASK_UNRESOLVED,
                  ),
                  StatsCard(
                    title: '完了タスク数:${data.finishedCount}',
                    description: '処理完了したタスク数',
                    icon: FontAwesomeIcons.handPaper,
                    link: Constants.API_TASK_FINISHED,
                  ),
                  StatsCard(
                    title: '承認要タスク数:${data.approvalCount}',
                    description: '現在処理必要なタスク数',
                    icon: FontAwesomeIcons.handPointRight,
                    link: Constants.API_TASK_APPROVAL,
                  ),
                ],
              );
            } else if (snapshot.hasError) {
              return Text("An error occurred");
            } else {
              return CircularProgressIndicator();
            }
          }
      ),
    );
  }
}