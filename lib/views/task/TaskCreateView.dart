import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:works_mobile/api/account.dart';
import 'package:works_mobile/api/task.dart';
import 'package:works_mobile/entities/UserProfile.dart';
import 'package:works_mobile/entities/Workflow.dart';
import 'package:works_mobile/utils/common.dart' as common;
import 'package:works_mobile/widgets/TaskTraffic.dart';
import 'package:works_mobile/widgets/TaskVisa.dart';

class TaskCreateView extends StatefulWidget {
  const TaskCreateView({Key? key, required this.workflow})
        : super(key: key);
  static const routeName = '/task/create';

  final Workflow workflow;

  @override
  State<TaskCreateView> createState() => _TaskCreateState();

}

class _TaskCreateState extends State<TaskCreateView> {
  Map<String, dynamic> data = new Map<String, dynamic>();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('作成：${this.widget.workflow.name}'),
      ),
      body: Center(
        child: FutureBuilder(
          future: Account.me,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              UserProfile user = snapshot.data as UserProfile;
              return Container(
                child: _isLoading ? CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                ) : ListView(
                  children: <Widget>[
                    this._createWorkflowForm(user.employee),
                    Container(
                      padding: EdgeInsets.all(16),
                      child: ElevatedButton(
                        onPressed: () {
                          // 申請
                          this._onSubmit(user.employee);
                        },
                        child: Text("申請"),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                            Colors.indigo,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
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

  Widget _createWorkflowForm(int employee) {
    switch (this.widget.workflow.code) {
      case '01':  // 証明書発行
        return TaskTraffic(workflow: this.widget.workflow, data: data,);
      case '02':  // 証明書発行(保育園用)
        return TaskTraffic(workflow: this.widget.workflow, data: data,);
      case '03':  // ビザ変更
        return TaskVisa(workflow: this.widget.workflow, data: data, employee: employee,);
      case '10':  // 通勤変更
        return TaskTraffic(workflow: this.widget.workflow, data: data,);
      case '11':  // 経費精算
        return TaskTraffic(workflow: this.widget.workflow, data: data,);
      default:
        return TaskTraffic(workflow: this.widget.workflow, data: data,);
    }
  }

  _onSubmit(int employee) async {
    String code = this.widget.workflow.code;
    if (code == "10" && !TaskTraffic.checkInput(data)) {
      return;
    }
    setState(() {
      _isLoading = true;
    });
    Map<String, dynamic> params = new Map<String, dynamic>();
    params['employee'] = employee;
    params['workflow'] = code;
    params['status'] = '10';
    params['fields'] = data;
    Task.createTask(params).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(
        common.successSnackBar(
          content: 'タスク：${this.widget.workflow.name}は申請しました。',
        ),
      );
      Navigator.pop(context);
    }).catchError((err) {
      Map<String, dynamic> error = json.decode(err);
      ScaffoldMessenger.of(context).showSnackBar(
        common.errorSnackBar(
          content: error['detail'],
        ),
      );
    }).whenComplete(() => {
      setState(() {
        _isLoading = false;
      })
    });
  }
}