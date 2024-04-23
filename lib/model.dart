class Task {
  String text;
  bool isCompleted;
  DateTime date;
  int priority;

  Task({
    required this.text,
    this.isCompleted = false,
    required this.date,
    required this.priority,
  });

  void toggleCompletion() {
    isCompleted = !isCompleted;
  }

  void changePriority(String newPriority) {
    priority = newPriority as int;
  }

  void changeText(String newText) {
    text = newText;
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'isCompleted': isCompleted,
      'date': date.toIso8601String(),
      'priority': priority,
    };
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      text: json['text'],
      isCompleted: json['isCompleted'],
      date: DateTime.parse(json['date']),
      priority: json['priority'],
    );
  }
}