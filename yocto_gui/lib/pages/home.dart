import 'package:flutter/material.dart';
import 'package:yocto_gui/pages/mainPage.dart';
import 'package:yocto_gui/pages/openEmbeddedLayerSelector.dart';
import 'package:yocto_gui/pages/overlay.dart';

import 'dart:io';
import '../global.dart' as global;

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var currentFolder = ValueNotifier(Directory("/home"));
  List<global.MenuButton> menuButtons =
      List<global.MenuButton>.empty(growable: true);
  bool _overlayEnabled = false;
  Widget _overlayChild = Container();

  @override
  void initState() {
    super.initState();
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
            color: Colors.black,
            child: Stack(children: [
              MainPage(
                currentFolder: currentFolder,
                menuButtons: menuButtons,
                enableOverlay: (type) {
                  setState(() {
                    _overlayEnabled = true;
                    switch (type) {
                      case "Layers":
                        _overlayChild = OpenEmbeddedLayerSelector();
                        break;
                    }
                  });
                },
              ),
              IgnorePointer(
                  ignoring: !_overlayEnabled,
                  child: YoctoOverlay(
                    closeOverlay: () {
                      setState(() {
                        _overlayEnabled = false;
                      });
                    },
                    overlayEnabled: _overlayEnabled,
                    overLay: _overlayChild,
                  ))
            ]));
      }),
    );
  }
}
