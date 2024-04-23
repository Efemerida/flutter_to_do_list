import 'dart:convert';
import 'package:date_format_field/date_format_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_to_do_list/taskWidget.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'model.dart';

void main() {
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const TaskListPage(),
    );
  }
}

class TaskListPage extends StatefulWidget {
  const TaskListPage({super.key});

  @override
  _TaskListPageState createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  late List<Task> tasks;
  TextEditingController textEditingController = TextEditingController();
  TextEditingController textEditingControllerDate = TextEditingController();
  var formatter = DateFormat('dd-MM-yyyy');
  DateTime selectedDate = DateTime.now();


  @override
  void initState() {
    super.initState();
    loadTasks();
  }

  void loadTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final taskList = prefs.getStringList('tasks');
    if (taskList != null) {
      tasks = taskList
          .map((taskJson) => Task.fromJson(jsonDecode(taskJson)))
          .toList();
    } else {
      tasks = [];
    }
    setState(() {});
  }

  void saveTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String> taskJsonList =
    tasks.map((task) => jsonEncode(task.toJson())).toList();
    prefs.setStringList('tasks', taskJsonList);
  }

  void sortByDate() {
    setState(() {
      tasks.sort((b, a) => a.date.compareTo(b.date));
    });
  }

  void sortByPriority() {
    setState(() {
      tasks.sort((b, a) => a.priority.compareTo(b.priority));
    });
  }

  void _cleartext() {
    textEditingControllerDate.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Список задач'),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: sortByDate,
          ),
          IconButton(
            icon: const Icon(Icons.sort),
            onPressed: sortByPriority,
          ),
        ],
      ),
      body: Column(
        children: [
          task,
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: textEditingController,
                    decoration: const InputDecoration(
                        hintText: 'Задача'),
                  ),
                ),
                DateFormatField(
                  type: DateFormatType.type4,
                  addCalendar: true,
                  controller: textEditingControllerDate,
                  decoration: InputDecoration(
                    // errorText: _validate ? "Неккоректный ввод" : null,
                    hintText: 'Дата',
                    hintStyle: const TextStyle(fontWeight: FontWeight.bold),
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                        onPressed: _cleartext, icon: const Icon(Icons.clear)),
                  ), onComplete: (date) {
                  setState(() {
                    selectedDate = DateUtils.dateOnly(date!);
                  });
                  textEditingControllerDate.text=formatter.format(selectedDate);
                },
                ),
                Expanded(
                  child: TextField(
                    controller: textEditingController,
                    decoration: const InputDecoration(
                        hintText: 'Приоритет'),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (textEditingController.text.isNotEmpty) {
                      final newTask = Task(
                        text: textEditingController.text,
                        date: DateTime.now(),
                        priority: 1,
                      );
                      setState(() {
                        tasks.add(newTask);
                        saveTasks();
                        textEditingController.clear();
                      });
                    }
                  },
                  child: const Text('Добавить'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget get task =>
      Expanded(
        child: ListView.builder(
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            final task = tasks[index];
            return TaskWidget(
              task: task,
              onDelete: () {
                setState(() {
                  tasks.removeAt(index);
                  saveTasks();
                });
              },
              onPriorityChange: (String newPriority) {
                setState(() {
                  task.changePriority(newPriority);
                  saveTasks();
                });
              },
              onToggleCompletion: () {
                setState(() {
                  task.toggleCompletion();
                  saveTasks();
                });
              },
              onChangeText: (String newText) {
                setState(() {
                  task.changeText(newText);
                  saveTasks();
                });
              },
            );
          },
        ),
      );
}
