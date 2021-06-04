import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:works_mobile/entities/ListTask.dart';
import 'package:works_mobile/utils/constants.dart' as Constants;
import 'package:works_mobile/widgets/TaskCard.dart';

var storage = FlutterSecureStorage();

class TaskListView extends StatefulWidget {
  TaskListView(this.endpoint);

  final String endpoint;

  @override
  State<TaskListView> createState() => _TaskListState();
}

class _TaskListState extends State<TaskListView> {
  late Future<List<ListTask>> futureTasks;

  @override
  void initState() {
    super.initState();
    futureTasks = fetchTasks();
  }

  Future<List<ListTask>> fetchTasks() async {
    final jwt = await storage.read(key: Constants.ACCESS_TOKEN);
    final response = await http.get(Uri.parse(widget.endpoint), headers: {"Authorization": "JWT ${jwt}"});

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return ListTask.fromJsonList(json.decode(utf8.decode(response.bodyBytes)));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load UnresolvedTask');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(this.getTitle()),
      ),
      body: Center(
        child: FutureBuilder(
          future: this.futureTasks,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<ListTask> data = snapshot.data as List<ListTask>;
              return ListView.builder(
                itemCount: data.length,
                itemBuilder: (BuildContext context, int index) {
                  return TaskCard(
                    name: data[index].name,
                    dateTime: data[index].dateTime,
                    approver: data[index].approver,
                    status: data[index].status,
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Text("An error occurred");
            } else {
              return CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }

  String getTitle() {
    if (widget.endpoint == Constants.API_TASK_APPROVAL) {
      return "承認待ち一覧";
    } else if (widget.endpoint == Constants.API_TASK_FINISHED) {
      return "申請済一覧";
    } else if (widget.endpoint == Constants.API_TASK_UNRESOLVED) {
      return "申請中タスク一覧";
    } else {
      return "";
    }
  }

}