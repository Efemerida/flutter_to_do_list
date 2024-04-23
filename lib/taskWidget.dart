
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'model.dart';

class TaskWidget extends StatelessWidget {


  final Task task;
  final Function() onDelete;
  final Function(String) onPriorityChange;
  final Function() onToggleCompletion;
  final Function(String) onChangeText;

  const TaskWidget({
    Key? key,
    required this.task,
    required this.onDelete,
    required this.onPriorityChange,
    required this.onToggleCompletion,
    required this.onChangeText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(children: [
        SizedBox(
          height: 100,
          child: Row(
            children: [
              Checkbox(
                value: task.isCompleted,
                onChanged: (value) => onToggleCompletion(),
              ),
              Expanded(
                child: TextField(
                  onSubmitted:  onChangeText,
                  decoration:
                  const InputDecoration.collapsed(hintText: 'Enter task'),
                  controller: TextEditingController(text: task.text),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: onDelete,
              ),
            ],
          ),
        ),
        SizedBox(
          height: 100,
          child: Row(
            verticalDirection: VerticalDirection.up,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Column(children: <Widget>[
                Text(
                    '${task.date.day}/${task.date.month}/${task.date.year} ${task.date.hour}:${task.date.minute}'),
                Text('${task.date.hour}:${task.date.minute}'),
              ]),
              const SizedBox(width: 40),
              Text("Приоритет: "),
              Expanded(
                child: TextField(
                  keyboardType: TextInputType.number,
                  onSubmitted:  onPriorityChange,
                  decoration:
                  const InputDecoration.collapsed(hintText: '0'),
                  controller: TextEditingController(text: task.priority.toString()),
                ),
              ),
              // for (int i = 1; i <= 5; i++)
              //   IconButton(
              //     icon: Icon(
              //       i <= task.priority ? Icons.star : Icons.star_border,
              //       color: Colors.orange,
              //     ),
              //     onPressed: () => onPriorityChange(i),
              //   ),
            ],
          ),
        ),
      ]),
    );
  }
}
