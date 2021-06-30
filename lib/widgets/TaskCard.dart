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

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => TaskDetail(task: widget.task)
        )
      ),
      child: Center(
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
              Container(
                padding: EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    getTaskStatus(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget getTaskStatus() {
    String text = 'UNKNOWN';
    Color foreColor = Colors.white;
    Color backColor = Colors.black54;
    switch(widget.task.status) {
      case '01':
        text = '新 規';
        backColor = Colors.green.shade100;
        foreColor = Colors.black;
        break;
      case '02':
        text = '差戻し';
        backColor = Color(0xfff80031);
        break;
      case '10':
        text = '申請中';
        backColor = Color(0xff03acca);
        break;
      case '11':
        text = '承認中';
        backColor = Color(0xff03acca);
        break;
      case '90':
        text = '完 了';
        backColor = Colors.black54;
        break;
      default:
        text = 'UNKNOWN';
        break;
    }
    return Container(
      padding: EdgeInsets.only(left: 8, right: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: backColor),
        color: backColor
      ),
      child: Text(
        text,
        style: TextStyle(
          color: foreColor,
        ),
      ),
    );
  }
}