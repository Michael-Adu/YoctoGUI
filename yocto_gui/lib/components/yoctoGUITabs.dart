import 'package:flutter/material.dart';

class YoctoGUITabs extends StatefulWidget {
  List<String> tabs;
  Function(String)? onSwitch;
  String type;
  YoctoGUITabs(
      {this.tabs = const ["Terminal", "Serial Console"],
      this.onSwitch,
      this.type = "console",
      Key? key})
      : super(key: key);

  @override
  _YoctoGUITabsState createState() => _YoctoGUITabsState();
}

class _YoctoGUITabsState extends State<YoctoGUITabs> {
  String selectedText = "";
  bool hovered = false;

  @override
  void initState() {
    selectedText = widget.tabs[0];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: widget.tabs
          .map((e) => Expanded(
                  child: InkWell(
                child: Container(
                  alignment: Alignment.center,
                  color: widget.type == "code"
                      ? selectedText == e
                          ? Colors.grey[900]
                          : Colors.transparent
                      : Colors.transparent,
                  child: Text(e,
                      style: TextStyle(
                          color:
                              selectedText == e ? Colors.cyan : Colors.white)),
                ),
                onTap: () {
                  widget.onSwitch!(e);
                  setState(() {
                    selectedText = e;
                  });
                  print(e);
                },
              )))
          .toList(),
    ));
  }
}
