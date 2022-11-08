import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mobile_application_2/screen/abclist_screen.dart';
import 'package:mobile_application_2/screen/tasklist_screen.dart';
import 'package:mobile_application_2/utils/store_utils.dart';

class HistoryScreen extends StatefulWidget{
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HistoryScreen();
}

class _HistoryScreen extends State<HistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Existierende Listen"),
      ),
      body: FutureBuilder(
        future: StoreUtils.getTaskList(),
        builder: (BuildContext context, AsyncSnapshot<List<File>> snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            final taskLists = snapshot.data!;
            return ListView.separated(
              padding: const EdgeInsets.all(8),
              itemCount: taskLists.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  child: TextButton(
                    child: _getFileNameAndType(taskLists[index].path),
                    onPressed: () => _checkTypeAndOpenList(taskLists[index]),
                  ),
                  height: 50,
                  color: Colors.black,
                );
              },
              separatorBuilder: (BuildContext context, int index) => const Divider(),
            );
          } else {
            return const Text("Loading...");
          }
        }
      ),
    );
  }

  _getFileNameAndType(String path){
    final fileName = StoreUtils.getOnlyFileName(path);
    final fileNameList = fileName.split(".");
    final textName = fileNameList.first;
    final Icon listTypeIcon;
    switch (fileNameList.last){
      case "abc": {
        listTypeIcon = const Icon(Icons.abc);
      }
      break;
      case "tkl": {
        listTypeIcon = const Icon(Icons.text_snippet);
      }
      break;
      default: {
        listTypeIcon = const Icon(Icons.question_mark);
      }
      break;
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        listTypeIcon,
        Text(textName)
      ],
    );
  }

  _checkTypeAndOpenList(File file){
    final StatefulWidget listScreen;
    switch (file.path.split(".").last) {
      case "abc": {
        listScreen = AbcListScreen(existingList: file);
      }
      break;
      case "tkl":
      default: {
        listScreen = TaskListScreen(existingList: file);
      }
      break;
    }
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => listScreen),
    );
  }
}