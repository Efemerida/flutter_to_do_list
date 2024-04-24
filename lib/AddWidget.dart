import 'package:date_format_field/date_format_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import 'model.dart';

//Show a bottom sheet that allows the user to create or edit a task.
//### MISSING FEATURES ###
// Proper Form Focus and keyboard actions.
// BottomModalSheet size is too big and doesn't work proper with keyboard.
// Keyboard must push the sheet up so the "ADD TASK" button is visible.

class AddWidget extends StatefulWidget {

  //final Task task;
  final Function(Task task) add;
  bool isChange = false;
  Task? task;


  AddWidget({required this.add, required this.isChange, this.task});



  @override
  _AddWidgetState createState() => _AddWidgetState(add: add,
      isChange: isChange, task: task);
}

class _AddWidgetState extends State<AddWidget> {
  TextEditingController textEditingControllerDate = TextEditingController();
  var formatter = DateFormat('dd-MM-yyyy');
  DateTime selectedDate = DateTime.now();
  TextEditingController text = TextEditingController();
  TextEditingController prioretyText = TextEditingController();
  DateTime dateTime = DateTime.now();

  String date = "";

  String? errorName = null;
  String? errorPriorety = null;
  String? errorDate = null;


  //final Task task;
  final Function(Task task) add;
  bool isChange = false;
  Task? task;


  _AddWidgetState({required this.add, required this.isChange,  this.task}){
    if(task!=null){
      text.text = task!.text;
      prioretyText.text = task!.priority.toString();
      selectedDate = task!.date;
      textEditingControllerDate.text = "${selectedDate.day}-${selectedDate.month}-${selectedDate.year}";
    }
  }

  void _cleartext() {
    textEditingControllerDate.clear();
  }

  @override
  Widget build(BuildContext context) {


    return Container(
      padding: EdgeInsets.only(
        top: 100,
          bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: TextField(
              controller: text,
              decoration: InputDecoration(
                  hintText: 'Задача',
              errorText: errorName),
            ),
          ),

          Expanded(
            child: TextField(
              keyboardType: TextInputType.number,
              controller: prioretyText,
              decoration: InputDecoration(
                  hintText: 'Приоритет',
              errorText: errorPriorety),
            ),
          ),

          DateFormatField(
            type: DateFormatType.type4,
            addCalendar: true,
            controller: textEditingControllerDate,
            decoration: InputDecoration(
              // errorText: _validate ? "Неккоректный ввод" : null,
              hintText: 'Дата',
              errorText: errorDate,
              hintStyle: const TextStyle(fontWeight: FontWeight.bold),
              border: const OutlineInputBorder(),
              suffixIcon: IconButton(
                  onPressed: _cleartext, icon: const Icon(Icons.clear)),
            ), onComplete: (date) {
            setState(() {
             // try {
                selectedDate = DateUtils.dateOnly(date!);
                print("AAAAAAAAAAAAaa");
                print(selectedDate);
              // }
              // catch(e){
              //   print("AAAAAAAAAAAAaa");
              //   errorDate = "Неккоректный формат ввода данных";
              // }
            });
            textEditingControllerDate.text=formatter.format(selectedDate);
          },
          ),
          ElevatedButton(
            onPressed: () {
              bool f = false;
              errorName = null;
              errorPriorety = null;
              errorDate = null;

              if(text.text.isEmpty){
                setState(() {
                  errorName = "Введите задачу";
                  f = true;
                });

              }
              try{
                int.parse(prioretyText.text);
              }catch(e){
                setState(() {
                  errorPriorety = "Неккоректно введен приоритет";
                  f = true;
                });
              }
              try{
                selectedDate = formatter.parse(textEditingControllerDate.text);
              }catch(e){
                setState(() {
                  if(textEditingControllerDate.text.isNotEmpty) {
                    errorDate = "Неккоректный формат даты";
                    f = true;
                  }
                });
              }
              if(!f) {
                final newTask = Task(
                  text: text.text,
                  date: selectedDate,
                  priority: int.parse(prioretyText.text),
                );
                add(newTask);
                Navigator.pop(context);
              }
            },
            child: const Text('Добавить'),
          ),
        ],
      ),
    );
  }
}
