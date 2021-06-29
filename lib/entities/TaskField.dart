import 'package:works_mobile/utils/common.dart' as common;

class TaskField {
  final int id;
  final String name;
  final String label;
  final String dataType;
  final bool isRequired;
  final int? maxLength;
  final String? helpText;
  final String? value;
  final String? attachment;
  final List? choices;  // 選択肢

  TaskField({
    required this.id,
    required this.name,
    required this.label,
    required this.dataType,
    required this.isRequired,
    this.maxLength,
    this.helpText,
    this.value,
    this.attachment,
    this.choices,
  });

  factory TaskField.fromJson(Map<String, dynamic> data) {
    return TaskField(
      id: data['id'],
      name: data['name'],
      label: data['label'],
      dataType: data['data_type'],
      isRequired: data['is_required'],
      maxLength: data['max_length'],
      helpText: data['help_text'],
      value: data['value'],
      attachment: data['attachment'],
      choices: data['choices'],
    );
  }

  static List<TaskField> fromJsonList(Iterable dataArray) {
    return dataArray.map((data) => TaskField.fromJson(data)).toList();
  }

  String getDisplayText() {
    if (this.choices == null) {
      return this.value == null ? "" : this.value!;
    } else if (this.value != null && this.choices != null) {
      return common.getChoiceText(this.value!, this.choices!);
    } else {
      return "";
    }
  }
}