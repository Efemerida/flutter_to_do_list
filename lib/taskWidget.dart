
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'model.dart';

class TaskWidget extends StatelessWidget {


  final Task task;
  final Function() onDelete;
  final Function() onChange;
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
    required this.onChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(children: [
        SizedBox(
          height: 100,
          child: Row(
            children: [
              Icon(Icons.star),
              Expanded(
                child: TextField(
                  keyboardType: TextInputType.number,
                  onSubmitted:  onPriorityChange,
                  decoration:
                  const InputDecoration.collapsed(hintText: '0'),
                  controller: TextEditingController(text: task.priority.toString()),
                ),
              ),
              Container(child:
                Text(
                    '${task.date.day}/${task.date.month}/${task.date.year}'),
              ),
              Checkbox(
                value: task.isCompleted,
                onChanged: (value) => onToggleCompletion(),
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: onDelete,
              ),
              IconButton(
                icon: const Icon(Icons.cached),
                onPressed: onChange,
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
              Expanded(
                child: TextField(
                  onSubmitted:  onChangeText,
                  decoration:
                  const InputDecoration.collapsed(hintText: 'Enter task'),
                  controller: TextEditingController(text: task.text),
                ),
              ),

            ],
          ),
        ),
      ]),
    );
  }
}
