import 'dart:io';

import 'package:path_provider/path_provider.dart';

class StoreUtils{
  late File file;

  bool createAndSaveFile(String name, content){
    try {
      _createFile(name).whenComplete(() => _saveFile(content));
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> _createFile(String taskListName) async {
    final dir = await getApplicationDocumentsDirectory();
    final directory = dir.path;
    final fileObjet = File('$directory/lists/$taskListName');
    file = await fileObjet.create(recursive: true);
}

  _saveFile(String content){
    file.writeAsStringSync(content);
  }

  getContent(String filename){
    return File(filename).readAsStringSync();
  }

  bool deleteList(String filename){
    try {
      File(filename).deleteSync();
      return true;
    } catch (e){
        return false;
    }
  }

  static Future<List<File>> getTaskList() async {
    final directory = await getPath();
    return Directory(directory)
        .listSync()
        .map((e) =>
          File(e.path))
        .toList();
  }

  static Future<String> getPath() async{
    return (await getApplicationDocumentsDirectory()).path + "/lists";
  }

  static String getOnlyFileName(String path){
    return path.split("/").last;
  }
}