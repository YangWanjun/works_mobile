import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:works_mobile/api/task.dart';
import 'package:works_mobile/entities/Task.dart';
import 'package:works_mobile/entities/TaskField.dart';
import 'package:works_mobile/entities/Workflow.dart';
import 'package:works_mobile/utils/NavigationService.dart';
import 'package:works_mobile/utils/common.dart' as common;
import 'package:works_mobile/utils/constants.dart' as Constants;
import 'package:works_mobile/utils/locator.dart';

import 'TaskCreateView.dart';

class TaskDetail extends StatefulWidget {
  const TaskDetail({Key? key, required this.task})
      : super(key: key);

  final Task task;

  @override
  State<TaskDetail> createState() => _TaskDetailState();
}

class _TaskDetailState extends State<TaskDetail> {
  bool _isLoading = false;
  String? _undoReason;
  Future<String>? taskInfoFuture;
  List<TaskField>? _taskFields;

  @override
  void initState() {
    super.initState();
    if (widget.task.status == '02') {
      // 差戻した場合
      taskInfoFuture = TaskApi.getTaskUndoInfo(widget.task.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.task.name),
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(16),
          child: _isLoading ? CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
          ) : Column(
            children: <Widget>[
              FutureBuilder(
                future: TaskApi.getTaskForm(widget.task.id),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<TaskField> fields = snapshot.data as List<TaskField>;
                    _taskFields = fields;
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
              SizedBox(height: 64,),
              FutureBuilder(
                future: taskInfoFuture,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    Map<String, dynamic> taskInfo = json.decode(snapshot.data.toString());
                    return Table(
                      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                      columnWidths: const <int, TableColumnWidth>{
                        0: IntrinsicColumnWidth(),
                        1: FlexColumnWidth(),
                      },
                      children: <TableRow>[
                        TableRow(
                          children: <TableCell>[
                            TableCell(
                                child: Container(
                                  padding: EdgeInsets.only(right: 16, top: 8, bottom: 8),
                                  child: Text('承認者'),
                                )
                            ),
                            TableCell(child: Text(taskInfo['approver'])),
                          ]
                        ),
                        TableRow(
                          children: <TableCell>[
                            TableCell(
                                child: Container(
                                  padding: EdgeInsets.only(right: 16, top: 8, bottom: 8),
                                  child: Text('差戻し理由'),
                                )
                            ),
                            TableCell(child: Text(taskInfo['reason'] == null ? '' : taskInfo['reason'])),
                          ],
                        )
                      ],
                    );
                  } else {
                    return SizedBox(height: 0,);
                  }
                },
              ),
              getActions(),
            ],
          ),
        )
      ),
    );
  }

  Widget getActions() {
    if (widget.task.nodeId != null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          ElevatedButton(
            onPressed: () {
              // 差戻す
              common.displayDialog(
                context: context,
                title: "差戻す理由　（＊）",
                content: TextFormField(
                  autovalidateMode: AutovalidateMode.always,
                  maxLength: 200,
                  validator: (String? value) {
                    return value == null || value.isEmpty ? 'この項目は必須です' : null;
                  },
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  onChanged: (String? value) {
                    this._undoReason = value;
                  },
                ),
                autoClose: false,
                callback: () {
                  if (this._undoReason != null && !this._undoReason!.isEmpty) {
                    Navigator.pop(context);
                    setState(() {
                      _isLoading = true;
                    });
                    TaskApi.undoNode(widget.task.id, widget.task.nodeId!, this._undoReason!).then((value) {
                      final NavigationService _navigationService = locator<NavigationService>();
                      _navigationService.pushNamed('/home');
                      ScaffoldMessenger.of(context).showSnackBar(
                        common.successSnackBar(content: Constants.SUCCESS_UNDO_TASK)
                      );
                    }).catchError((err) {
                      Map<String, dynamic> error = json.decode(err);
                      ScaffoldMessenger.of(context).showSnackBar(
                        common.errorSnackBar(
                          content: error['detail'],
                        ),
                      );
                    }).whenComplete(() {
                      setState(() {
                        _isLoading = false;
                      });
                    });
                  }
                }
              );
            },
            child: Text("差戻す"),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(
                Colors.redAccent,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              // 申請
              common.displayConfirm(
                context: context,
                content: "承認します、よろしいですか？",
                callback: () {
                  setState(() {
                    _isLoading = true;
                  });
                  TaskApi.approvalNode(widget.task.id, widget.task.nodeId!).then((value) {
                    final NavigationService _navigationService = locator<NavigationService>();
                    _navigationService.pushNamed('/home');
                    ScaffoldMessenger.of(context).showSnackBar(
                      common.successSnackBar(content: Constants.SUCCESS_SUBMITTED)
                    );
                  }).catchError((err) {
                    Map<String, dynamic> error = json.decode(err);
                    ScaffoldMessenger.of(context).showSnackBar(
                      common.errorSnackBar(
                        content: error['detail'],
                      ),
                    );
                  }).whenComplete(() {
                    setState(() {
                      _isLoading = false;
                    });
                  });
                }
              );
            },
            child: Text("承認"),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(
                Colors.indigo,
              ),
            ),
          ),
        ],
      );
    } else if (widget.task.status == '02') {
      // 差戻した場合
      return Column(
        children: <Widget>[
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Workflow.getById(widget.task.workflow).then((workflow) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TaskCreateView(
                      workflow: workflow,
                      task: this.widget.task,
                      taskFields: this._taskFields,
                      callback: () {
                        final NavigationService _navigationService = locator<NavigationService>();
                        _navigationService.pushNamed('/home');
                      },
                    )
                  )
                );
              }),
              child: Text("変更")
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => common.displayConfirm(
                context: context,
                content: "削除します、よろしいですか？",
                callback: () {
                  setState(() {
                    setState(() {
                      _isLoading = true;
                    });
                    TaskApi.deleteTask(this.widget.task.id).then((value) {
                      final NavigationService _navigationService = locator<NavigationService>();
                      _navigationService.pushNamed('/home');
                      ScaffoldMessenger.of(context).showSnackBar(
                          common.successSnackBar(content: Constants.SUCCESS_DELETED)
                      );
                    }).catchError((err) {
                      Map<String, dynamic> error = json.decode(err);
                      ScaffoldMessenger.of(context).showSnackBar(
                        common.errorSnackBar(
                          content: error['detail'],
                        ),
                      );
                    }).whenComplete(() {
                      setState(() {
                        _isLoading = false;
                      });
                    });
                  });
                }
              ),
              child: Text("削除"),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                  Colors.redAccent,
                ),
              ),
            ),
          )
        ],
      );
    } else {
      return Row();
    }
  }
}
