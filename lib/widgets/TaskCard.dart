import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TaskCard extends StatefulWidget {
  const TaskCard({
    Key? key,
    required this.name,
    required this.dateTime,
    required this.approver,
    required this.status,
  }) : super(key: key);

  final String name;
  final DateTime dateTime;
  final String approver;
  final String status;

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
              title: Text(widget.name),
              trailing: Text(formatter.format(widget.dateTime.toLocal())),
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