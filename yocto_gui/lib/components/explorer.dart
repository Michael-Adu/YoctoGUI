import 'package:flutter/material.dart';
import 'package:yocto_gui/components/folderButtons.dart';
import '../global.dart' as global;
import 'dart:io';

class Explorer extends StatefulWidget {
  @required
  Directory? folder_dir;
  Explorer({this.folder_dir, Key? key}) : super(key: key);

  @override
  _ExplorerState createState() => _ExplorerState();
}

class _ExplorerState extends State<Explorer> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.folder_dir!.path != "/home") {
      return Container(
          height: MediaQuery.of(context).size.height * 0.5,
          width: MediaQuery.of(context).size.width * 0.2,
          child: Column(
            children: [
              Text("Explorer"),
              Container(
                  height: MediaQuery.of(context).size.height * 0.45,
                  child: SingleChildScrollView(
                      child: FolderButtons(folder: widget.folder_dir)))
            ],
          ));
    } else {
      return Container(
          color: Colors.black,
          child: Column(children: [
            Text("Explorer"),
            Text("Import Project to View from Explorer")
          ]));
    }
  }
}
