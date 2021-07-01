class Task {
  final int id;
  final String name;
  final DateTime createdDt;
  final DateTime updatedDt;
  final String approver;
  final String status;
  final int? nodeId;  // 承認必要なタスク（画面下部に「承認」、「差戻す」のボタンを表示する）
  final String workflow;

  Task({
    required this.id,
    required this.name,
    required this.createdDt,
    required this.updatedDt,
    required this.approver,
    required this.status,
    required this.workflow,
    this.nodeId,
  });

  factory Task.fromJson(Map<String, dynamic> data) {
    String approver = '';
    if (data['approver_list'] != null) {
      approver = data['approver_list'].map((i) => i['user_name']).join(',');
    }
    return Task(
      id: data['id'],
      name: data['name'],
      createdDt: DateTime.parse(data['created_dt']),
      updatedDt: DateTime.parse(data['updated_dt']),
      approver: approver,
      status: data['status'],
      workflow: data['workflow'],
      nodeId: null,
    );
  }

  static List<Task> fromJsonList(Iterable dataArray) {
    return dataArray.map((data) => Task.fromJson(data)).toList();
  }

  factory Task.fromTaskNodeJson(Map<String, dynamic> data) {
    return Task(
      id: data['task'],
      name: data['workflow_name'],
      createdDt: DateTime.parse(data['created_dt']),
      updatedDt: DateTime.parse(data['updated_dt']),
      approver: data['approver_name'],
      status: data['status'],
      workflow: data['workflow'],
      nodeId: data['id'],
    );
  }

  static List<Task> fromTaskNodeJsonList(Iterable dataArray) {
    return dataArray.map((data) => Task.fromTaskNodeJson(data)).toList();
  }
}