import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class HistoryScreen extends StatefulWidget{
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HistoryScreen();
}

class _HistoryScreen extends State<HistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder(
        future: getTaskLists(),
        builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            final a = snapshot.data!.join(", ");
            return Text(a);
          } else {
            return const Text("Loading...");
          }
        }
      ),
    );
  }

  Future<List<String>> getTaskLists() async {
    final directory = (await getApplicationDocumentsDirectory()).path;
    return Directory(directory).listSync().map((e) => e.toString()).toList();
  }
}