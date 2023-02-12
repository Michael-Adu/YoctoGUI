import 'package:flutter/material.dart';
import 'package:yocto_gui/global.dart' as global;
import 'dart:io';

class FileButtons extends StatefulWidget {
  @required
  Function(Directory)? onLeftClick;
  @required
  Function(Directory)? onRightClick;
  @required
  Directory? file;

  FileButtons({this.file, this.onLeftClick, this.onRightClick, Key? key})
      : super(key: key);

  @override
  _FileButtonsState createState() => _FileButtonsState();
}

class _FileButtonsState extends State<FileButtons> {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height * 0.04,
        padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
        child: GestureDetector(
            onTap: () async {
              widget.onLeftClick!(widget.file!);
            },
            onSecondaryTap: () {
              widget.onRightClick!(widget.file!);
            },
            child: Container(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                    child: Icon(Icons.file_open, color: Colors.white),
                  ),
                  Text(widget.file!.path
                      .substring(widget.file!.path.lastIndexOf("/") + 1))
                ],
              ),
            )));
  }
}
