class Task {
  final int id;
  final String name;
  final DateTime dateTime;
  final String approver;
  final String status;

  Task({
    required this.id,
    required this.name,
    required this.dateTime,
    required this.approver,
    required this.status
  });

  factory Task.fromJson(Map<String, dynamic> data) {
    String approver = '';
    if (data['approver_list'] != null) {
      approver = data['approver_list'].map((i) => i['user_name']).join(',');
    }
    return Task(
        id: data['id'],
        name: data['name'],
        dateTime: DateTime.parse(data['created_dt']),
        approver: approver,
        status: data['status']
    );
  }

  static List<Task> fromJsonList(Iterable dataArray) {
    return dataArray.map((data) => Task.fromJson(data)).toList();
  }

  factory Task.fromTaskNodeJson(Map<String, dynamic> data) {
    return Task(
        id: data['task'],
        name: data['workflow_name'],
        dateTime: DateTime.parse(data['updated_dt']),
        approver: data['approver_name'],
        status: data['status']
    );
  }

  static List<Task> fromTaskNodeJsonList(Iterable dataArray) {
    return dataArray.map((data) => Task.fromTaskNodeJson(data)).toList();
  }
}