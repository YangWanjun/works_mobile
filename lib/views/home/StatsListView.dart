import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:works_mobile/utils/constants.dart' as Constants;
import 'package:works_mobile/widgets/StatsCard.dart';

final storage = FlutterSecureStorage();

class StatsListView extends StatelessWidget {
  StatsListView(this.jwt);

  final String jwt;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ホーム'),
      ),
      body: Center(
        child: FutureBuilder(
          future: http.read(Uri.parse("${Constants.HOST_API}/api/account/task/statistics/"), headers: {"Authorization": "JWT ${jwt}"}),
          builder: (context, snapshot) => (
            snapshot.hasData ? ListView(
              children: <Widget>[
                StatsCard(
                  title: '申請タスク数:${snapshot.data}',
                  description: 'いままで申請したタスク数',
                  icon: FontAwesomeIcons.handPointer,
                ),
                StatsCard(
                  title: '処理中タスク数',
                  description: '現在処理中のタスク数',
                  icon: FontAwesomeIcons.handshake,
                ),
                StatsCard(
                  title: '完了タスク数',
                  description: '処理完了したタスク数',
                  icon: FontAwesomeIcons.handPaper,
                ),
                StatsCard(
                  title: '承認要タスク数',
                  description: '現在処理必要なタスク数',
                  icon: FontAwesomeIcons.handPointRight,
                ),
              ],
            ) : (
              snapshot.hasError ? Text("An error occurred") : CircularProgressIndicator()
            )
          ),
        ),
      )
    );
  }
}