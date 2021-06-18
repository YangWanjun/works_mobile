import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:works_mobile/entities/Workflow.dart';

class TaskCreateView extends StatefulWidget {
  const TaskCreateView({Key? key, required this.workflow})
        : super(key: key);

  final Workflow workflow;

  @override
  State<TaskCreateView> createState() => _TaskCreateState();

}

class _TaskCreateState extends State<TaskCreateView> {
  Map<String, dynamic> data = new Map<String, dynamic>();
  File? _image;
  final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('作成：${this.widget.workflow.name}'),
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: trafficTaskWidget(data),
        ),
      ),
    );
  }

  // 画像の読み込み
  Future _getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);  //カメラ
    // final pickedFile = await picker.getImage(source: ImageSource.gallery);  //アルバム

    setState(() {
      if(pickedFile!=null) {
        _image = File(pickedFile.path);
      }
    });
  }

  Widget trafficTaskWidget(Map<String, dynamic> data) {

    return ListView(
      children: <Widget>[
        InputDatePickerFormField(
          firstDate: DateTime.utc(2021, 4, 1),
          lastDate: DateTime.utc(9999, 12, 31),
          initialDate: DateTime.now(),
          fieldLabelText: "通勤開始日",
          onDateSaved: (DateTime value) {
            data["start_date"] = value;
            print(value);
          },
        ),
        TextFormField(
          autovalidateMode: AutovalidateMode.always,
          maxLength: 15,
          decoration: const InputDecoration(
            labelText: "自宅駅 （*）"
          ),
          validator: (String? value) {
            return value == null || value.isEmpty ? 'この項目は必須です' : null;
          },
          onSaved: (String? value) {
            data["home_station"] = value;
          },
        ),
        TextFormField(
          autovalidateMode: AutovalidateMode.always,
          maxLength: 15,
          decoration: const InputDecoration(
              labelText: "勤務地駅 （*）"
          ),
          validator: (String? value) {
            return value == null || value.isEmpty ? 'この項目は必須です' : null;
          },
          onSaved: (String? value) {
            data["work_station"] = value;
          },
        ),
        TextFormField(
          maxLength: 100,
          decoration: const InputDecoration(
              labelText: "自宅住所"
          ),
          onSaved: (String? value) {
            data["home_address"] = value;
          },
        ),
        TextFormField(
          maxLength: 100,
          decoration: const InputDecoration(
              labelText: "勤務地住所"
          ),
          onSaved: (String? value) {
            data["work_address"] = value;
          },
        ),
        TextFormField(
          autovalidateMode: AutovalidateMode.always,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly,
          ],
          decoration: const InputDecoration(
              labelText: "金額 （*）"
          ),
          validator: (String? value) {
            return value == null || value.isEmpty ? 'この項目は必須です' : null;
          },
          onSaved: (String? value) {
            data["amount"] = value;
          },
        ),
        Row(
          children: <Widget>[
            ElevatedButton(
              onPressed: _getImage,
              child: Text("写真撮影"),
            ),
            SizedBox(
              width: 10,
            ),
            _image == null
                ? Text('No image selected.')
                : Image.file(_image!, width: 200, height: 100,)
          ],
        ),
      ],
    );
  }
}
