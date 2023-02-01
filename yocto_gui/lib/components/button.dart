import 'package:flutter/material.dart';

class Button extends StatefulWidget {
  @required
  Function? onClick;
  @required
  String name;
  @required
  String type;
  Size buttonSize;

  Button(
      {this.onClick,
      this.name = "Button",
      this.type = "TextButton",
      this.buttonSize = const Size(100, 100),
      Key? key})
      : super(key: key);

  @override
  _ButtonState createState() => _ButtonState();
}

class _ButtonState extends State<Button> {
  String type = "TextButton";

  @override
  void initState() {
    super.initState();
    type = widget.type;
  }

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case "TextButton":
        return InkWell(
            onTap: () {
              widget.onClick!();
            },
            child: Container(
                width: widget.buttonSize.width,
                height: widget.buttonSize.height,
                child:
                    Text(widget.name, style: TextStyle(color: Colors.white))));
      default:
        return InkWell();
    }
    ;
  }
}
