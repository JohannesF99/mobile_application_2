import 'package:flutter/material.dart';
import 'package:mobile_application_2/screen/history_screen.dart';

import 'abclist_screen.dart';
import 'tasklist_screen.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  bool _isOpen = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          body: Center(
            child: SizedBox(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ExpansionPanelList(
                    children: [
                      ExpansionPanel(
                          headerBuilder: (BuildContext context, bool isOpen) {
                            return Row(
                              children: const [
                                Icon(Icons.add),
                                Text("Create a new list!")
                              ],
                            );
                          },
                          body: Column(
                            children: [
                              TextButton(
                                  onPressed: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const AbcListScreen()),
                                  ),
                                  child: const Text("ABC Liste")
                              ),
                              TextButton(
                                  onPressed: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const TaskListScreen()),
                                  ),
                                  child: const Text("Normale Liste")
                              ),
                            ],
                          ),
                          isExpanded: _isOpen,
                          canTapOnHeader: true
                      ),
                    ],
                    expansionCallback: (i, isOpen) => setState(() {
                      _isOpen = !isOpen;
                    }),
                  ),
                  Card(
                    child: TextButton(
                      child: Row(
                        children: const [
                          Icon(Icons.edit),
                          Text(
                            "Edit existing Tasklist",
                            style: TextStyle(
                                color: Colors.black
                            ),
                          ),
                        ],
                      ),
                      onPressed: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const HistoryScreen()),
                        );
                      },
                    ),
                  ),
                ],
              ),
              width: MediaQuery.of(context).size.width-190,
            ),
          ),
        ),
    );
  }
}
