import 'package:flutter/material.dart';
import 'package:yocto_gui/global.dart' as global;
import 'package:yocto_gui/components/menuButtons.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';

class MenuBarWidget extends StatefulWidget {
  List<global.MenuButton>? menuButtons;
  MenuBarWidget({this.menuButtons, Key? key}) : super(key: key);

  @override
  _MenuBarWidgetState createState() => _MenuBarWidgetState();
}

class _MenuBarWidgetState extends State<MenuBarWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(color: Colors.grey[700]),
        height: MediaQuery.of(context).size.height * 0.05,
        child: MoveWindow(
            child: Stack(
          children: [
            Container(
                padding: EdgeInsets.fromLTRB(5, 0, 0.0, 0),
                height: MediaQuery.of(context).size.height * 0.05,
                width: MediaQuery.of(context).size.width * 0.12,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: widget.menuButtons!
                      .map((e) => MenuButtons(
                            label: e.label,
                            onClick: e.onClick,
                          ))
                      .toList(),
                )),
            Container(
                alignment: Alignment.centerRight,
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    MinimizeWindowButton(
                      colors: WindowButtonColors(
                          iconNormal: Colors.white, iconMouseOver: Colors.blue),
                    ),
                    MaximizeWindowButton(
                      colors: WindowButtonColors(
                          iconNormal: Colors.white, iconMouseOver: Colors.blue),
                    ),
                    CloseButton(color: Colors.white)
                  ],
                ))
          ],
        )));
  }
}
