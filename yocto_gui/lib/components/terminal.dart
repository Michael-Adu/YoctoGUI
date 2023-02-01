import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:yocto_gui/global.dart' as global;

class Terminal extends StatefulWidget {
  const Terminal({Key? key}) : super(key: key);

  @override
  _TerminalState createState() => _TerminalState();
}

class _TerminalState extends State<Terminal> {
  List<global.TerminalCommand> commands =
      List<global.TerminalCommand>.empty(growable: true);
  @override
  void initState() {
    if (global.allCommands.isEmpty) {
      global
          .executeCommand(
              global.TerminalCommand(0, "", "", "init", "", "", "", false))
          .then(
        (value) {
          setState(() {
            global.allCommands.add(global.TerminalCommand(
                0, value.user_hostName, value.wd, "execute", "", "", "", true));
            commands = global.allCommands;
          });
        },
      );
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
            height: constraints.maxHeight,
            width: MediaQuery.of(context).size.width * 0.7,
            child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Container(
                  padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: global.allCommands
                          .map((e) => Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                              '''${e.user_hostName}${e.wd}\$ ''',
                                              style: TextStyle(
                                                color: Colors.green,
                                              )),
                                          Expanded(
                                            child: TextField(
                                              autofocus: true,
                                              cursorColor: Colors.grey,
                                              cursorWidth: 10,
                                              enabled: e.enabled ? true : false,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14),
                                              decoration: InputDecoration(
                                                border: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.white,
                                                      width: 2.0),
                                                ),
                                              ),
                                              onSubmitted: (value) async {
                                                if (value == "clear") {
                                                  global.allCommands.forEach(
                                                      (e) => print(e.command));
                                                  global.allCommands.clear();
                                                  global.allCommands.add(
                                                      global.TerminalCommand(
                                                          0,
                                                          global.user_host,
                                                          global.initWD,
                                                          "",
                                                          "execute",
                                                          "",
                                                          "",
                                                          true));
                                                  setState(() {
                                                    commands =
                                                        global.allCommands;
                                                  });
                                                } else {
                                                  global
                                                      .executeCommand(e)
                                                      .then((value) {
                                                    e.enabled = value.enabled;
                                                    e.stdout = value.stdout;
                                                    e.stderr = value.stderr;
                                                    global.allCommands.add(
                                                        global.TerminalCommand(
                                                            global.allCommands
                                                                .length,
                                                            global.user_host,
                                                            global.initWD,
                                                            "execute",
                                                            "",
                                                            "",
                                                            "",
                                                            true));
                                                    setState(() {
                                                      commands =
                                                          global.allCommands;
                                                    });
                                                  });
                                                }
                                              },
                                              onChanged: (value) {
                                                e.command = value;
                                              },
                                            ),
                                          )
                                        ]),
                                    Container(
                                        child: Text('${e.stdout}\n${e.stderr}',
                                            style:
                                                TextStyle(color: Colors.white)))
                                  ]))
                          .toList()),
                )));
      },
    );
  }
}
