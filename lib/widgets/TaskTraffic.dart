import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:works_mobile/entities/Workflow.dart';
import 'package:works_mobile/utils/common.dart' as common;


class TaskTraffic extends StatefulWidget {
  const TaskTraffic({Key? key, required this.workflow, required this.data})
      : super(key: key);

  final Workflow workflow;
  final Map<String, dynamic> data;

  @override
  State<TaskTraffic> createState() => _TaskTrafficState();

  static bool checkInput(Map<String, dynamic> data) {
    if (data['start_date'] == null) {
      return false;
    }
    if (data["home_station"] == null || data["home_station"] == '') {
      return false;
    }
    if (data["work_station"] == null || data["work_station"] == '') {
      return false;
    }
    if (data["amount"] == null || data["amount"] == '') {
      return false;
    }
    return true;
  }

}

class _TaskTrafficState extends State<TaskTraffic> {
  final TextEditingController _textEditingController = TextEditingController();
  File? _image;
  final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> data = this.widget.data;

    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        children: <Widget>[
          TextField(
            focusNode: AlwaysDisabledFocusNode(),
            controller: _textEditingController,
            decoration: const InputDecoration(
              labelText: "通勤開始日",
              suffixIcon: Icon(Icons.calendar_today),
            ),
            onTap: () {
              _selectDate(context, 'start_date');
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
            onChanged: (String? value) {
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
            onChanged: (String? value) {
              data["work_station"] = value;
            },
          ),
          TextFormField(
            maxLength: 100,
            decoration: const InputDecoration(
                labelText: "自宅住所"
            ),
            onChanged: (String? value) {
              data["home_address"] = value;
            },
          ),
          TextFormField(
            maxLength: 100,
            decoration: const InputDecoration(
                labelText: "勤務地住所"
            ),
            onChanged: (String? value) {
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
            keyboardType: TextInputType.number,
            onChanged: (String? value) {
              data["amount"] = value;
            },
          ),
          Row(
            children: <Widget>[
              ElevatedButton(
                onPressed: () {
                  this._showPicker(context);
                },
                child: Text("定期券の写し"),
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
      ),
    );
  }

  // 画像の読み込み
  Future _getImage(source) async {
    final pickedFile = await picker.getImage(source: source);  //カメラ
    // final pickedFile = await picker.getImage(source: ImageSource.gallery);  //アルバム

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        if (_image != null) {
          List<int> imageBytes = _image!.readAsBytesSync();
          String filename = base64Encode(utf8.encode("${DateTime.now().toString()}${common.getFileExtension(pickedFile.path)}"));
          this.widget.data['commuter_pass_image'] = "name=${filename};base64,${base64Encode(imageBytes)}";
        }
      }
    });
  }

  void _showPicker(context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Container(
            child: new Wrap(
              children: <Widget>[
                new ListTile(
                  leading: new Icon(Icons.photo_library),
                  title: new Text('写真から選択'),
                  onTap: () {
                    this._getImage(ImageSource.gallery);
                    Navigator.of(context).pop();
                  },
                ),
                new ListTile(
                  leading: new Icon(Icons.photo_camera),
                  title: new Text('写真を撮る'),
                  onTap: () {
                    this._getImage(ImageSource.camera);
                    Navigator.of(context).pop();
                  },
                )
              ],
            ),
          ),
        );
      }
    );
  }

  Future<void> _selectDate(BuildContext context, String name) async {
    final DateTime? selected = await showDatePicker(
      locale: const Locale("ja"),
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2021),
      lastDate: DateTime(9999),
    );
    if (selected != null) {
      print(DateFormat.yMd("ja").format(selected));
      this.widget.data[name] = DateFormat.yMd("ja").format(selected);
      _textEditingController
        ..text = DateFormat.yMMMd("ja").format(selected)
        ..selection = TextSelection.fromPosition(TextPosition(
            offset: _textEditingController.text.length,
            affinity: TextAffinity.upstream));
    }
  }

}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}