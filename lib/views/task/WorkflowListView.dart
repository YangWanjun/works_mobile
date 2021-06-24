import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:works_mobile/entities/Workflow.dart';

import 'TaskCreateView.dart';

class WorkflowListView extends StatefulWidget {

  @override
  State<WorkflowListView> createState() => _WorkflowListState();

}

class _WorkflowListState extends State<WorkflowListView> {
  late Future<List<Workflow>> workflows;

  @override
  void initState() {
    super.initState();
    workflows = fetchWorkflows();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("各種手続き"),
      ),
      body: Center(
        child: FutureBuilder(
          future: this.workflows,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<Workflow> data = snapshot.data as List<Workflow>;
              return ListView.builder(
                itemCount: data.length,
                itemBuilder: (BuildContext context, int index) {
                  return Center(
                    child: Card(
                      child: Container(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            ListTile(
                              trailing: CircleAvatar(
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                                child: FaIcon(this.getWorkflowIcon(data[index].code)),
                              ),
                              title: Text(
                                data[index].name,
                                style: TextStyle(fontSize: 21),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                const SizedBox(width: 8),
                                TextButton.icon(
                                  label: const Text('新規作成'),
                                  icon: Icon(Icons.add_circle_outline),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => TaskCreateView(
                                              workflow: data[index],
                                            )
                                        )
                                    );
                                  },
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
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

  Future<List<Workflow>> fetchWorkflows() async {
    final data = await Workflow.list();
    return data;
  }

  IconData getWorkflowIcon(String code) {
    switch (code) {
      case '01':  // 証明書発行
        return FontAwesomeIcons.fileAlt;
      case '02':  // 証明書発行(保育園用)
        return FontAwesomeIcons.babyCarriage;
      case '03':  // ビザ変更
        return FontAwesomeIcons.idCard;
      case '10':  // 通勤変更
        return FontAwesomeIcons.subway;
      case '11':  // 経費精算
        return FontAwesomeIcons.euroSign;
      default:
        return FontAwesomeIcons.question;
    }
  }
}