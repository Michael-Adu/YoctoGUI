import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:yocto_gui/components/codeEditor.dart';
import 'package:yocto_gui/components/menuButtons.dart';
import 'package:yocto_gui/components/terminal_bake.dart';
import '../components/button.dart';
import '../components/explorer.dart';
import 'dart:io';
import '../global.dart' as global;

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var currentFolder = ValueNotifier(Directory("/home"));
  List<global.CodeTabs> _tabs = List<global.CodeTabs>.empty(growable: true);
  List<global.MenuButton> menuButtons =
      List<global.MenuButton>.empty(growable: true);

  @override
  void initState() {
    super.initState();
    _tabs = global.allCodeTabs.value;
    menuButtons.add(global.MenuButton("File", () {
      setState(() {
        global.getDirectory().then((value) {
          global.getAllDirectory(value);
          currentFolder.value = value;
        });
      });
    }));
    menuButtons.add(global.MenuButton("Edit", () {}));
    menuButtons.add(global.MenuButton("View", () {}));
    menuButtons.add(global.MenuButton("Terminal", () {}));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(builder: (context, constraints) {
        Size windowSize = Size(constraints.maxWidth, constraints.maxHeight);
        return Container(
            width: windowSize.width,
            height: windowSize.height,
            child: Column(children: [
              Container(
                  width: windowSize.width,
                  height: windowSize.height * 0.03,
                  color: Colors.black,
                  child: Container(
                      decoration: BoxDecoration(color: Colors.grey[700]),
                      height: windowSize.height * 0.05,
                      child: MoveWindow(
                          child: Stack(
                        children: [
                          Container(
                              padding: EdgeInsets.fromLTRB(5, 0, 0.0, 0),
                              height: windowSize.height * 0.05,
                              width: constraints.maxWidth * 0.12,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: menuButtons
                                    .map((e) => MenuButtons(
                                          label: e.label,
                                          onClick: e.onClick,
                                        ))
                                    .toList(),
                              )),
                          Container(
                            width: windowSize.width,
                            height: windowSize.height * 0.05,
                            alignment: Alignment.center,
                            child: Text("Home",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                )),
                          ),
                          Container(
                              alignment: Alignment.centerRight,
                              width: windowSize.width,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  MinimizeWindowButton(),
                                  MaximizeWindowButton(),
                                  CloseButton()
                                ],
                              ))
                        ],
                      )))),
              Container(
                  height: windowSize.height * 0.95,
                  width: windowSize.width,
                  child: Column(children: [
                    Container(
                        height: 0.547 * windowSize.height,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                                height: 0.547 * windowSize.height,
                                width: 0.263 * windowSize.width,
                                decoration: BoxDecoration(
                                  border: Border(
                                      right:
                                          BorderSide(color: Colors.grey[900]!),
                                      bottom:
                                          BorderSide(color: Colors.grey[900]!)),
                                  color: Colors.black,
                                ),
                                child: ValueListenableBuilder(
                                    valueListenable: currentFolder,
                                    builder: (context, value, child) {
                                      return Explorer(
                                        folder_dir: currentFolder.value,
                                      );
                                    })),
                            Container(
                                child: Container(
                              decoration: const BoxDecoration(
                                color: Colors.black,
                              ),
                              height: 0.547 * windowSize.height,
                              width: 0.736 * windowSize.width,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 5, 0, 10),
                                      alignment: Alignment.centerLeft,
                                      width: windowSize.width * 0.736,
                                      child: const Text("Code Editor",
                                          style: TextStyle(fontSize: 15))),
                                  ValueListenableBuilder(
                                      valueListenable: global.allCodeTabs,
                                      builder: (context, value, child) {
                                        if (_tabs != value) {
                                          setState(() {
                                            _tabs = value;
                                          });
                                        }

                                        return CodeEditor();
                                      })
                                ],
                              ),
                            ))
                          ],
                        )),
                    Expanded(
                        child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey[900]!),
                              color: Colors.black,
                            ),
                            child: TerminalBake()))
                  ]))
            ]));
      }),
    );
  }
}
