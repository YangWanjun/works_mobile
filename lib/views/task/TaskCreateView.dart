import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:works_mobile/api/account.dart';
import 'package:works_mobile/api/task.dart';
import 'package:works_mobile/entities/Task.dart';
import 'package:works_mobile/entities/TaskField.dart';
import 'package:works_mobile/entities/UserProfile.dart';
import 'package:works_mobile/entities/Workflow.dart';
import 'package:works_mobile/utils/common.dart' as common;
import 'package:works_mobile/widgets/TaskCertificate.dart';
import 'package:works_mobile/widgets/TaskCertificateBaby.dart';
import 'package:works_mobile/widgets/TaskTraffic.dart';
import 'package:works_mobile/widgets/TaskVisa.dart';

class TaskCreateView extends StatefulWidget {
  const TaskCreateView({Key? key, required this.workflow, this.task, this.taskFields, this.callback})
        : super(key: key);
  static const routeName = '/task/create';

  final Workflow workflow;
  final Task? task;
  final List<TaskField>? taskFields;
  final VoidCallback? callback;

  @override
  State<TaskCreateView> createState() => _TaskCreateState();

}

class _TaskCreateState extends State<TaskCreateView> {
  Map<String, dynamic> data = new Map<String, dynamic>();
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    this.data = this.getInitialData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.task == null ? '作成' : '変更'}：${this.widget.workflow.name}'),
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

  Map<String, dynamic> getInitialData() {
    Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.widget.taskFields != null) {
      this.widget.taskFields!.forEach((field) {
        data[field.name] = field.value;
      });
    }
    return data;
  }

  Widget _createWorkflowForm(int employee) {
    switch (this.widget.workflow.code) {
      case '01':  // 証明書発行
        return TaskCertificate(
          formKey: _formKey,
          workflow: this.widget.workflow,
          data: data,
        );
      case '02':  // 証明書発行(保育園用)
        return TaskCertificateBaby(
          formKey: _formKey,
          workflow: this.widget.workflow,
          data: data,
        );
      case '03':  // ビザ変更
        return TaskVisa(
          formKey: _formKey,
          workflow: this.widget.workflow,
          data: data,
          employee: employee,
        );
      case '10':  // 通勤変更
        return TaskTraffic(
          formKey: _formKey,
          workflow: this.widget.workflow,
          data: data,
        );
      case '11':  // 経費精算
        return TaskTraffic(
          formKey: _formKey,
          workflow: this.widget.workflow,
          data: data,
        );
      default:
        return TaskTraffic(
          formKey: _formKey,
          workflow: this.widget.workflow,
          data: data,
        );
    }
  }

  _onSubmit(int employee) async {
    String code = this.widget.workflow.code;
    if (!_formKey.currentState!.validate()) {
      return false;
    }
    setState(() {
      _isLoading = true;
    });
    Map<String, dynamic> params = new Map<String, dynamic>();
    params['employee'] = employee;
    params['workflow'] = code;
    params['status'] = '10';
    params['fields'] = data;
    Future<String> request;
    if (this.widget.task != null) {
      request = TaskApi.changeTask(this.widget.task!.id, params);
    } else {
      request = TaskApi.createTask(params);
    }
    request.then((value) {
      ScaffoldMessenger.of(context).showSnackBar(
        common.successSnackBar(
          content: 'タスク：${this.widget.workflow.name}は申請しました。',
        ),
      );
      Navigator.pop(context);
      if (this.widget.callback != null) {
        this.widget.callback!();
      }
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