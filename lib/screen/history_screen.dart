import 'dart:io';

import 'package:flutter/material.dart';
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
                    child: Text(StoreUtils.getOnlyFileName(taskLists[index].path)),
                    onPressed: () => openTaskList(taskLists[index]),
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

  openTaskList(File file){
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => TaskListScreen(existingList: file,)),
    );
  }
}