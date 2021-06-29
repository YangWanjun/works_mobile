import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:works_mobile/entities/Task.dart';
import 'package:works_mobile/views/task/TaskDetail.dart';

class TaskCard extends StatefulWidget {
  const TaskCard({
    Key? key,
    required this.task,
  }) : super(key: key);

  final Task task;

  @override
  State<TaskCard> createState() => _TaskCardState();

}

class _TaskCardState extends State<TaskCard> {
  @override
  Widget build(BuildContext context) {
    DateFormat formatter = DateFormat('yyyy/MM/dd HH:mm');

    return Center(
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              title: Text(widget.task.name),
              trailing: Text(formatter.format(widget.task.dateTime.toLocal())),
            ),
            Container(
              padding: EdgeInsets.only(left: 16, right: 16),
              child: Row(
                children: <Widget>[
                  Text("承認者:${widget.task.approver}")
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                // TextButton(
                //   child: const Text('BUY TICKETS'),
                //   onPressed: () {/* ... */},
                // ),
                // const SizedBox(width: 8),
                TextButton(
                  child: const Text('VIEW'),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TaskDetail(task: widget.task)
                        )
                    );
                  },
                ),
                const SizedBox(width: 8),
              ],
            ),
          ],
        ),
      ),
    );
  }

}