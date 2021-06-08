import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:works_mobile/entities/TaskStatistics.dart';
import 'package:works_mobile/utils/ajax.dart';
import 'package:works_mobile/utils/constants.dart' as Constants;
import 'package:works_mobile/views/account/LoginView.dart';
import 'package:works_mobile/widgets/StatsCard.dart';

class StatsListView extends StatefulWidget {
  StatsListView();

  @override
  State<StatsListView> createState() => _StatsListState();
}

class _StatsListState extends State<StatsListView> {
  late Future<TaskStatistics> futureTaskStatistics;

  @override
  void initState() {
    super.initState();
    futureTaskStatistics = fetchTaskStatistics();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ホーム'),
        actions: <Widget>[IconButton(
          icon: Icon(Icons.logout),
          onPressed: () {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => LoginView()
                )
            );
          }, // The icon of your choice
        ),],
      ),
      body: Center(
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
                    link: '',
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
      )
    );
  }

  Future<TaskStatistics> fetchTaskStatistics() async {
    final response = await Ajax.get(Constants.API_TASK_STATS);

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return TaskStatistics.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load TaskStatistics');
    }
  }

}