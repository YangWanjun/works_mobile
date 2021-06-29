import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:works_mobile/api/task.dart';
import 'package:works_mobile/entities/Task.dart';
import 'package:works_mobile/entities/TaskField.dart';

class TaskDetail extends StatefulWidget {
  const TaskDetail({Key? key, required this.task})
      : super(key: key);

  final Task task;

  @override
  State<TaskDetail> createState() => _TaskDetailState();
}

class _TaskDetailState extends State<TaskDetail> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.task.name),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(16),
              child: FutureBuilder(
                future: TaskApi.getTaskForm(widget.task.id),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<TaskField> fields = snapshot.data as List<TaskField>;
                    return Table(
                        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                        columnWidths: const <int, TableColumnWidth>{
                          0: IntrinsicColumnWidth(),
                          1: FlexColumnWidth(),
                        },
                        children: fields.map((e) => TableRow(
                          children: <Widget>[
                            TableCell(
                              child: Container(
                                padding: EdgeInsets.only(right: 16, top: 8, bottom: 8),
                                child: Text(e.label),
                              )
                            ),
                            TableCell(child: Text(e.getDisplayText())),
                          ],
                        )).toList()
                    );
                  } else if (snapshot.hasError) {
                    return Text("An error occurred");
                  } else {
                    return CircularProgressIndicator();
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
