import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:works_mobile/api/employee.dart';
import 'package:works_mobile/entities/ResidenceStatus.dart';
import 'package:works_mobile/entities/Workflow.dart';

class TaskVisa extends StatefulWidget {
  const TaskVisa({Key? key, required this.formKey, required this.workflow, required this.data, required this.employee})
      : super(key: key);

  final Workflow workflow;
  final Map<String, dynamic> data;
  final int employee;
  final formKey;

  @override
  State<TaskVisa> createState() => _TaskVisaState();
}

class _TaskVisaState extends State<TaskVisa> {

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> data = this.widget.data;

    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(16),
          child: FutureBuilder(
            future: Employee.getResidenceStatus(this.widget.employee),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                ResidenceStatus residence = snapshot.data as ResidenceStatus;
                return Table(
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  columnWidths: const <int, TableColumnWidth>{
                    0: IntrinsicColumnWidth(),
                    1: FlexColumnWidth(),
                  },
                  children: <TableRow>[
                    TableRow(
                      children: <Widget>[
                        TableCell(child: Text("住所")),
                        TableCell(child: Text(residence.address)),
                      ],
                    ),
                    TableRow(
                      children: <Widget>[
                        TableCell(
                          child: Container(
                            padding: EdgeInsets.only(right: 8),
                            child: Text("在留カード番号"),
                          )
                        ),
                        TableCell(child: Text(residence.residenceNo)),
                      ],
                    ),
                    TableRow(
                      children: <Widget>[
                        TableCell(child: Text("在留資格")),
                        TableCell(child: Text(residence.getResidenceTypeDisplay())),
                      ],
                    ),
                    TableRow(
                      children: <Widget>[
                        TableCell(child: Text("在留満了日")),
                        TableCell(child: Text(residence.visaExpireDate)),
                      ],
                    ),
                  ],
                );
              } else if (snapshot.hasError) {
                return Text("An error occurred");
              } else {
                return CircularProgressIndicator();
              }
            },
          ),
        ),
        const Divider(
          thickness: 2,
        ),
        Container(
          padding: EdgeInsets.all(16),
          child: Text(this.widget.workflow.comment == null ? "" : this.widget.workflow.comment!),
        ),
        const Divider(
          thickness: 2,
        ),
        Container(
          padding: EdgeInsets.all(16),
          child: Form(
            key: this.widget.formKey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  maxLength: 20,
                  decoration: const InputDecoration(
                    labelText: "発行元 （*）",
                    helperText: "現在ビザの発行元",
                  ),
                  validator: (String? value) {
                    return value == null || value.isEmpty ? 'この項目は必須です' : null;
                  },
                  onChanged: (String? value) {
                    data["publisher"] = value;
                  },
                ),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: const InputDecoration(
                    labelText: "勤務年数 （*）",
                    helperText: "卒業から勤務年数",
                  ),
                  keyboardType: TextInputType.number,
                  validator: (String? value) {
                    return value == null || value.isEmpty ? 'この項目は必須です' : null;
                  },
                  onChanged: (String? value) {
                    data["years"] = value;
                  },
                ),
                DropdownButtonFormField<String>(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  value: data['category'],
                  decoration: const InputDecoration(
                    labelText: "変更種類 （*）",
                  ),
                  items: [
                    DropdownMenuItem(value: '01', child: Text('転職'),),
                    DropdownMenuItem(value: '02', child: Text('EB所有ビザ更新'),),
                    DropdownMenuItem(value: '03', child: Text('転職＋ビザ更新'),),
                    DropdownMenuItem(value: '04', child: Text('高度人材'),),
                    DropdownMenuItem(value: '05', child: Text('永住'),),
                  ],
                  validator: (String? value) {
                    return value == null || value.isEmpty ? 'この項目は必須です' : null;
                  },
                  onChanged: (value) {
                    data['category'] = value;
                  },
                ),
                TextFormField(
                  maxLength: 200,
                  decoration: const InputDecoration(
                    labelText: "備考",
                  ),
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  onChanged: (String? value) {
                    data["comment"] = value;
                  },
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
