import 'package:flutter/material.dart';
import 'package:yocto_gui/global.dart' as global;

class YoctoGUITabs extends StatefulWidget {
  List<global.Tab>? tabs;
  Function(global.Tab)? onSwitch;
  String type;
  bool saved;
  YoctoGUITabs(
      {this.tabs,
      this.onSwitch,
      this.type = "console",
      this.saved = true,
      Key? key})
      : super(key: key);

  @override
  _YoctoGUITabsState createState() => _YoctoGUITabsState();
}

class _YoctoGUITabsState extends State<YoctoGUITabs> {
  global.Tab selectedTab = global.Tab("", () {}, () {});
  bool hovered = false;
  bool deleteHovered = false;

  @override
  void initState() {
    selectedTab = widget.tabs![0];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: widget.type == "code"
              ? widget.tabs!
                  .map((e) => Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: selectedTab.tabData == e.tabData
                              ? Colors.grey[900]
                              : Colors.transparent),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            InkWell(
                              child: Expanded(
                                  child: Container(
                                      width: constraints.maxWidth * 0.1,
                                      alignment: Alignment.center,
                                      child: Text(e.tabData.name,
                                          style: TextStyle(
                                              color: selectedTab.tabData ==
                                                      e.tabData
                                                  ? Colors.cyan
                                                  : Colors.white)))),
                              onTap: () {
                                widget.onSwitch!(e);
                                setState(() {
                                  selectedTab = e;
                                });
                              },
                            ),
                            InkWell(
                                onHover: (value) {
                                  setState(() {
                                    deleteHovered = value;
                                  });
                                },
                                child: Container(
                                    child: widget.saved
                                        ? InkWell(
                                            child: Icon(Icons.close,
                                                color: Colors.white),
                                            onTap: () {
                                              e.onDelete!();
                                            })
                                        : Container(
                                            child: Icon(
                                            Icons.circle,
                                            color: Colors.white,
                                          ))))
                          ])))
                  .toList()
              : widget.tabs!
                  .map((e) => Expanded(
                          child: InkWell(
                        child: Container(
                            width: constraints.maxWidth * 0.8,
                            alignment: Alignment.center,
                            color: Colors.transparent,
                            child: Text(e.tabData,
                                style: TextStyle(
                                    color: selectedTab.tabData == e.tabData
                                        ? Colors.cyan
                                        : Colors.white))),
                        onTap: () {
                          widget.onSwitch!(e);
                          setState(() {
                            selectedTab = e;
                          });
                        },
                      )))
                  .toList());
    });
  }
}
