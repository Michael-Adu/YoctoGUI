import 'package:flutter/material.dart';
import 'package:yocto_gui/components/fileButtons.dart';
import '../global.dart' as global;
import 'dart:io';
import 'dart:math' as math;

class FolderButtons extends StatefulWidget {
  Directory? folder;

  FolderButtons({this.folder, Key? key}) : super(key: key);

  @override
  _FolderButtonsState createState() => _FolderButtonsState();
}

class _FolderButtonsState extends State<FolderButtons> {
  var folders = ValueNotifier(global.Folder(Directory(""), [], []));
  List<global.CodeTabs> _tabs = List<global.CodeTabs>.empty(growable: true);
  bool collapsed = false;
  @override
  void initState() {
    super.initState();
    global.getAllDirectory(widget.folder!).then((value) {
      folders.value.subFolder = value;
    });
    global.getAllFiles(widget.folder!).then((value) {
      folders.value.filesInFolder = value;
    });
  }

  void callSubFolders() async {}

  @override
  Widget build(BuildContext context) {
    folders.value.folder = widget.folder!;
    return Container(
        child: Column(children: [
      Container(
          height: MediaQuery.of(context).size.height * 0.04,
          child: Row(
            children: [
              AnimatedContainer(
                duration: Duration(milliseconds: 500),
                child: Transform.rotate(
                    angle: collapsed ? math.pi / 2 : 0,
                    child: IconButton(
                        onPressed: () {
                          setState(() {
                            collapsed = !collapsed;
                            global
                                .getAllDirectory(widget.folder!)
                                .then((value) {
                              folders.value.subFolder = value;
                            });
                          });
                        },
                        icon: Icon(
                          Icons.arrow_forward_ios_outlined,
                          color: Colors.white,
                          size: 15,
                        ))),
              ),
              Container(
                  alignment: Alignment.centerLeft,
                  child: Text(folders.value.folder.path.substring(
                      folders.value.folder.path.lastIndexOf('/') + 1))),
            ],
          )),
      ValueListenableBuilder(
          valueListenable: folders,
          builder: ((context, value, child) {
            if (collapsed == true) {
              return Container(
                  width: MediaQuery.of(context).size.width * 0.3,
                  padding: EdgeInsets.fromLTRB(25, 0, 0, 0),
                  child: Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: folders.value.subFolder
                            .map((e) => FolderButtons(folder: e.folder))
                            .toList(),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: folders.value.filesInFolder
                            .map((e) => Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.04,
                                child: FileButtons(
                                  file: e,
                                  onLeftClick: (file) async {
                                    File file = File(e.path);

                                    _tabs = global.allCodeTabs.value;
                                    String code = await file.readAsString();
                                    if (global.allCodeTabs.value.indexWhere(
                                            (element) =>
                                                element.directory == e) <
                                        0) {
                                      setState(() {
                                        global.allCodeTabs.value.add(
                                            global.CodeTabs(
                                                e.path.substring(
                                                    e.path.lastIndexOf("/") +
                                                        1),
                                                e,
                                                code,
                                                code,
                                                true,
                                                false));
                                        global.tabsChanged.value = true;
                                      });

                                      print("Opening " +
                                          e.path.substring(
                                              e.path.lastIndexOf("/") + 1));
                                    } else {
                                      print("File is already open ");
                                    }
                                  },
                                  onRightClick: (file) {
                                    print("Menu for " +
                                        e.path.substring(
                                            e.path.lastIndexOf("/") + 1));
                                  },
                                )))
                            .toList(),
                      )
                    ],
                  )));
            } else {
              return Container();
            }
          }))
    ]));
  }
}
