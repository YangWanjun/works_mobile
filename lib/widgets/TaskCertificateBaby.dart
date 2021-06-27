import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:works_mobile/entities/Workflow.dart';

class TaskCertificateBaby extends StatefulWidget {
  const TaskCertificateBaby({Key? key, required this.formKey, required this.workflow, required this.data})
      : super(key: key);

  final Workflow workflow;
  final Map<String, dynamic> data;
  final formKey;

  @override
  State<TaskCertificateBaby> createState() => _TaskCertificateBabyState();
}

class _TaskCertificateBabyState extends State<TaskCertificateBaby> {
  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> data = this.widget.data;

    return Column(
      children: <Widget>[
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
                  maxLength: 200,
                  decoration: const InputDecoration(
                    labelText: "指定書式URL	 （*）",
                  ),
                  validator: (String? value) {
                    return value == null || value.isEmpty ? 'この項目は必須です' : null;
                  },
                  initialValue: data["url_format"],
                  onChanged: (String? value) {
                    data["url_format"] = value;
                  },
                ),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: const InputDecoration(
                    labelText: "枚数 （*）",
                  ),
                  keyboardType: TextInputType.number,
                  validator: (String? value) {
                    return value == null || value.isEmpty ? 'この項目は必須です' : null;
                  },
                  initialValue: data["count"],
                  onChanged: (String? value) {
                    data["count"] = value;
                  },
                ),
                DropdownButtonFormField<String>(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  value: data['delivery_type'],
                  decoration: const InputDecoration(
                    labelText: "送付方法 （*）",
                  ),
                  items: [
                    DropdownMenuItem(value: '01', child: Text('自宅へ郵送'),),
                    DropdownMenuItem(value: '02', child: Text('本社で受取'),),
                    DropdownMenuItem(value: '03', child: Text('自宅で印刷'),),
                    DropdownMenuItem(value: '10', child: Text('電話連絡により'),),
                  ],
                  validator: (String? value) {
                    return value == null || value.isEmpty ? 'この項目は必須です' : null;
                  },
                  onChanged: (value) {
                    data['delivery_type'] = value;
                  },
                ),
                TextFormField(
                  maxLength: 200,
                  decoration: const InputDecoration(
                    labelText: "備考",
                  ),
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  initialValue: data["comment"],
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
