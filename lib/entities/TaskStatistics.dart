class TaskStatistics {
  final int totalCount;
  final int unresolvedCount;
  final int finishedCount;
  final int approvalCount;

  TaskStatistics({
    required this.totalCount,
    required this.unresolvedCount,
    required this.finishedCount,
    required this.approvalCount
  });

  factory TaskStatistics.fromJson(Map<String, dynamic> data) {
    return TaskStatistics(
      totalCount: data['total'],
      unresolvedCount: data['unresolved'],
      finishedCount: data['finished'],
      approvalCount: data['approval']
    );
  }
}