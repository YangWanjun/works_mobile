import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:works_mobile/entities/ListTask.dart';
import 'package:works_mobile/utils/ajax.dart';
import 'package:works_mobile/utils/constants.dart' as Constants;
import 'package:works_mobile/widgets/TaskCard.dart';

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
    final data = await Ajax.get(widget.endpoint);
    return ListTask.fromJsonList(json.decode(data));
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