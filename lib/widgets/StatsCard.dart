import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:works_mobile/views/task/TaskListView.dart';

class StatsCard extends StatefulWidget {
  const StatsCard({
    Key? key,
    required this.title,
    required this.description,
    required this.icon,
    required this.link,
  }) : super(key: key);

  final String title;
  final String description;
  final IconData icon;
  final String link;

  @override
  State<StatsCard> createState() => _StatsCardState();

}

class _StatsCardState extends State<StatsCard> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                child: FaIcon(widget.icon),
              ),
              title: Text(widget.title),
              subtitle: Text(widget.description),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                // TextButton(
                //   child: const Text('BUY TICKETS'),
                //   onPressed: () {/* ... */},
                // ),
                // const SizedBox(width: 8),
                TextButton(
                  child: const Text('VIEW'),
                  onPressed: () {
                    if (widget.link != "") {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TaskListView(widget.link)
                          )
                      );
                    }
                  },
                ),
                const SizedBox(width: 8),
              ],
            ),
          ],
        ),
      ),
    );
  }

}