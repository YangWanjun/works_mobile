class ListTask {
  final String name;
  final DateTime dateTime;
  final String approver;
  final String status;

  ListTask({
    required this.name,
    required this.dateTime,
    required this.approver,
    required this.status
  });

  factory ListTask.fromJson(Map<String, dynamic> data) {
    String approver = '';
    if (data['approver_list'] != null) {
      approver = data['approver_list'].map((i) => i['user_name']).join(',');
    }
    return ListTask(
        name: data['name'],
        dateTime: DateTime.parse(data['created_dt']),
        approver: approver,
        status: data['status']
    );
  }

  static List<ListTask> fromJsonList(Iterable dataArray) {
    return dataArray.map((data) => ListTask.fromJson(data)).toList();
  }
}