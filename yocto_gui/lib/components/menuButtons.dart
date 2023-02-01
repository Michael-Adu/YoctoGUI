import 'package:flutter/material.dart';

class MenuButtons extends StatefulWidget {
  String label;
  Function? onClick;
  MenuButtons({this.label = "File", this.onClick, Key? key}) : super(key: key);

  @override
  _MenuButtonsState createState() => _MenuButtonsState();
}

class _MenuButtonsState extends State<MenuButtons> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          widget.onClick!();
        },
        child: Container(child: Text(widget.label)));
  }
}
