class ChoiceItem {
  final String value;
  final String text;

  ChoiceItem({
    required this.value,
    required this.text,
  });

  factory ChoiceItem.fromJson(Map<String, dynamic> data) {
    return ChoiceItem(
      value: data['value'],
      text: data['text'],
    );
  }

  static List<ChoiceItem> fromJsonList(Iterable dataArray) {
    return dataArray.map((data) => ChoiceItem.fromJson(data)).toList();
  }
}