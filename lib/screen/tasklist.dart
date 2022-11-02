import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class TaskListScreen extends StatefulWidget{
  const TaskListScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TaskListScreen();
}

class _TaskListScreen extends State<TaskListScreen> {

  late File file;
  String taskListName = "New TaskList";
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(taskListName),
        actions: [
          IconButton(
              onPressed: createFile,
              icon: const Icon(Icons.save)),
        ],
      ),
      body: Column(
        children: [
          TextField(
            decoration: const InputDecoration(label: Text("He")),
            onChanged: (text) => setState(() {
              text.isEmpty ? taskListName = "New TaskList" : taskListName = text;
            })
          ),
        ],
      ),
    );
  }

  void createFile() async {
    final dir = await getApplicationDocumentsDirectory();
    final directory = dir.path;
    final fileObjet = File('$directory/$taskListName');
    file = await fileObjet.create();
  }

  void saveFile(){
    file.writeAsString("Hello");
  }
}