import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_code_editor/flutter_code_editor.dart';
import 'package:flutter_highlight/themes/monokai-sublime.dart';
import 'package:highlight/languages/cpp.dart';
import 'package:highlight/languages/makefile.dart';
import 'package:yocto_gui/components/codeSpace.dart';
import 'package:yocto_gui/components/yoctoGUITabs.dart';
import 'package:yocto_gui/global.dart' as global;

class CodeEditor extends StatefulWidget {
  const CodeEditor({Key? key}) : super(key: key);

  @override
  _CodeEditorState createState() => _CodeEditorState();
}

class _CodeEditorState extends State<CodeEditor> {
  List<global.CodeTabs> _tabs = List<global.CodeTabs>.empty(growable: true);
  late global.CodeTabs selectedTab;
  late global.CodeTabs lastSelectedTab;
  CodeController? _codeController;

  @override
  void initState() {
    super.initState();
    _tabs = global.allCodeTabs;

    selectedTab = _tabs[0];
    lastSelectedTab = _tabs[0];
    _codeController = CodeController(
      text: selectedTab.currentCode,
      language: cpp,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: global.tabsChanged,
        builder: ((context, value, child) {
          print("Change Occured");

          return Container(
              height: 0.5 * MediaQuery.of(context).size.height,
              width: 0.735 * MediaQuery.of(context).size.width,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[900]!)),
                      height: MediaQuery.of(context).size.height * 0.05,
                      child: YoctoGUITabs(
                        tabs: _tabs
                            .map((e) =>
                                global.Tab(e, selectedTab.saved, () {}, () {
                                  if (_tabs.length < 1) {
                                    setState(() {
                                      selectedTab = lastSelectedTab;
                                      _tabs.removeWhere(
                                          (element) => element == e);
                                      lastSelectedTab = _tabs[0];
                                    });
                                  } else {
                                    _tabs
                                        .removeWhere((element) => element == e);
                                    global.tabsChanged.value = true;
                                  }
                                }))
                            .toList(),
                        onSwitch: (tab) {
                          setState(() {
                            lastSelectedTab = selectedTab;
                            selectedTab = _tabs[_tabs.indexWhere(
                                (element) => element.name == tab.tabData.name)];
                          });
                          _codeController!.fullText = selectedTab.currentCode;
                          global.tabsChanged.value = true;
                        },
                        type: "code",
                      ),
                    ),
                    Expanded(
                        child: SingleChildScrollView(
                            child: Column(children: [
                      CodeTheme(
                        data: CodeThemeData(
                          styles: monokaiSublimeTheme,
                        ),
                        child: CodeField(
                          onChanged: (code) {
                            _tabs[_tabs.indexWhere((element) =>
                                    element.name == selectedTab.name)]
                                .currentCode = code;
                            global.tabsChanged.value = true;
                            setState(() {
                              if (code != selectedTab.originalCode) {
                                selectedTab.saved = false;
                              }
                            });
                          },
                          textStyle: TextStyle(height: 1.5),
                          background: Colors.black,
                          controller: _codeController!,
                        ),
                      )
                    ])))
                  ]));
        }));
  }
}
