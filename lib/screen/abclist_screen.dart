import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mobile_application_2/utils/store_utils.dart';

class AbcListScreen extends StatefulWidget{
  const AbcListScreen({Key? key, this.existingList}): super(key: key);

  final File? existingList;

  @override
  State<StatefulWidget> createState() => _AbcListScreen();
}

class _AbcListScreen extends State<AbcListScreen> {

  final TextEditingController taskNameController = TextEditingController();
  final List<TextEditingController> textControllerList = List.generate(26, (_) => TextEditingController());

  @override
  void initState() {
    if (widget.existingList == null) {
      _updateValue(taskNameController, "New TaskList");
    } else {
      _updateContent(StoreUtils().getContent(widget.existingList!.path));
      _updateValue(taskNameController, StoreUtils.getOnlyFileName(widget.existingList!.path).split(".").first);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: taskNameController,
        ),
        actions: getActionButtons(),
      ),
      body: ListView.builder(
          itemCount: 26,
          itemBuilder: (BuildContext context, int index){
            return Card(
              child: Row(
                children: [
                  const Icon(Icons.arrow_forward_ios),
                  Text("${const AsciiDecoder().convert([65+index])} "),
                  const Spacer(),
                  SizedBox(
                    child: TextField(
                      controller: textControllerList[index],
                    ),
                    width: MediaQuery.of(context).size.width-50,
                  )
                ],
              ),
            );
          }
      ),
    );
  }

  _updateContent(String value){
    final valueList = value.split("\n");
    textControllerList.asMap().forEach((index, controller) { 
      _updateValue(controller, valueList[index]);
    });
  }

  _updateValue(TextEditingController tec, String value){
    tec.value = TextEditingValue(
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
          if (StoreUtils().createAndSaveFile("${taskNameController.text}.abc", textControllerList.map((e) => "${e.text}\n").join())) {
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
            var path = await StoreUtils.getPath() + "/${taskNameController.text}.abc";
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