import 'package:flutter/material.dart';
import 'package:yocto_gui/components/codeEditor.dart';
import 'package:yocto_gui/components/menuBar.dart';
import 'package:yocto_gui/components/terminal_bake.dart';
import 'package:yocto_gui/global.dart' as global;
import '../components/explorer.dart';

class MainPage extends StatefulWidget {
  List<global.MenuButton>? menuButtons;
  ValueNotifier? currentFolder;
  List<global.CodeTabs>? tabs;
  Function(String)? enableOverlay;
  MainPage(
      {this.currentFolder,
      this.tabs,
      this.menuButtons,
      this.enableOverlay,
      Key? key})
      : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      Size windowSize = Size(constraints.maxWidth, constraints.maxHeight);
      return Column(children: [
        Container(
            width: windowSize.width,
            height: windowSize.height * 0.03,
            child: MenuBarWidget(
              menuButtons: widget.menuButtons!,
            )),
        Container(
            height: windowSize.height * 0.95,
            width: windowSize.width,
            child: Column(children: [
              YoctoTitle(
                title: "Home",
                onAddClick: () {
                  widget.enableOverlay!("Layers");
                },
              ),
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
                                right: BorderSide(color: Colors.grey[900]!),
                                bottom: BorderSide(color: Colors.grey[900]!)),
                            color: Colors.black,
                          ),
                          child: ValueListenableBuilder(
                              valueListenable: widget.currentFolder!,
                              builder: (context, value, child) {
                                return Explorer(
                                  folder_dir: widget.currentFolder!.value,
                                );
                              })),
                      Container(
                          child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.black,
                        ),
                        height: 0.547 * windowSize.height,
                        width: 0.736 * windowSize.width,
                        child: ValueListenableBuilder(
                            valueListenable: global.tabsChanged,
                            builder: (context, value, child) {
                              print("Change in Tabs");
                              global.tabsChanged.value = false;
                              if (global.allCodeTabs.isEmpty) {
                                return Container();
                              } else {
                                return CodeEditor();
                              }
                            }),
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
      ]);
    });
  }
}

class YoctoTitle extends StatefulWidget {
  String title;
  Function? onHomeClick;
  Function? onAddClick;
  YoctoTitle(
      {this.title = "Project Name:",
      this.onAddClick,
      this.onHomeClick,
      Key? key})
      : super(key: key);

  @override
  _YoctoTitleState createState() => _YoctoTitleState();
}

class _YoctoTitleState extends State<YoctoTitle> {
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[900]!),
        ),
        height: MediaQuery.of(context).size.height * 0.052962963,
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Icon(Icons.home, color: Colors.white),
          Text(widget.title),
          IconButton(
              onPressed: () {
                widget.onAddClick!();
              },
              icon: Icon(Icons.add_circle_outline, color: Colors.white))
        ]));
  }
}
