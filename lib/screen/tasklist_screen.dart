import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mobile_application_2/utils/store_utils.dart';

class TaskListScreen extends StatefulWidget{
  const TaskListScreen({Key? key, this.existingList}): super(key: key);

  final File? existingList;

  @override
  State<StatefulWidget> createState() => _TaskListScreen();
}

class _TaskListScreen extends State<TaskListScreen> {

  final TextEditingController taskNameController = TextEditingController();
  final TextEditingController taskContentController = TextEditingController();

  @override
  void initState() {
    if (widget.existingList == null) {
      _updateName("New TaskList");
    } else {
      _updateContent(StoreUtils().getContent(widget.existingList!.path));
      _updateName(StoreUtils.getOnlyFileName(widget.existingList!.path));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(taskNameController.text),
        actions: getActionButtons(),
      ),
      body: SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width-100,
                  child: TextField(
                    controller: taskNameController,
                    decoration: const InputDecoration(
                        label: Text("TaskList Name")
                    ),
                    onChanged: (_) => setState((){}),
                  ),
                ),
              ),
              TextField(
                decoration: const InputDecoration(
                    label: Text("Content")
                ),
                controller: taskContentController,
                maxLines: (MediaQuery.of(context).size.width/12).round(),
              ),
            ],
          )
      ),
    );
  }

  _updateName(String value){
    taskNameController.value = TextEditingValue(
      text: value,
      selection: TextSelection.fromPosition(
        TextPosition(offset: value.length),
      ),
    );
  }

  _updateContent(String value){
    taskContentController.value = TextEditingValue(
      text: value,
      selection: TextSelection.fromPosition(
        TextPosition(offset: value.length),
      ),
    );
  }

  List<IconButton> getActionButtons(){
    var buttonList = <IconButton>[];
    buttonList.add(IconButton(
        onPressed: () {
          final SnackBar snackBar;
          if (StoreUtils().createAndSaveFile(taskNameController.text, taskContentController.text)) {
            snackBar = const SnackBar(
                content: Text("Successfully created the List!")
            );
          } else {
            snackBar = const SnackBar(
                content: Text("A Problem while creating the List occurred!")
            );
          }
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        },
        icon: const Icon(Icons.save)
    ));
    if (widget.existingList != null) {
      buttonList.add(IconButton(
          onPressed: () async {
            var path = await StoreUtils.getPath() + "/${taskNameController.text}";
            final SnackBar snackBar;
            if (!StoreUtils().deleteList(path)) {
              snackBar = const SnackBar(
                  content: Text("A Problem while deleting the List occurred!")
              );
            } else {
              snackBar = const SnackBar(
                  content: Text("Successfully deleted the List!")
              );
            }
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          },
          icon: const Icon(Icons.delete)
      ));
    }
    return buttonList;
  }
}