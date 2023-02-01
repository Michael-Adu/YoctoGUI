import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_code_editor/flutter_code_editor.dart';
import 'package:flutter_highlight/themes/a11y-dark.dart';
import 'package:highlight/languages/cpp.dart';
import 'package:highlight/languages/makefile.dart';
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
  CodeController? _codeController;

  @override
  void initState() {
    super.initState();
    _tabs = global.allCodeTabs.value;
    selectedTab = _tabs[0];
    _codeController = CodeController(
      language: cpp,
    );
  }

  @override
  void dispose() {
    _codeController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("value.length");
    setState(() {
      selectedTab = global.allCodeTabs.value.last;
    });

    return ValueListenableBuilder(
        valueListenable: global.allCodeTabs,
        builder: ((context, value, child) {
          try {
            if (_tabs != value) {
              setState(() {
                _tabs = value;
              });
            }
          } catch (e) {}

          return Column(children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.03,
              child: YoctoGUITabs(
                tabs: _tabs.map((e) => e.name).toList(),
                onSwitch: (tab) {
                  print(tab);

                  setState(() {
                    _codeController!.clear();
                    selectedTab = _tabs[
                        _tabs.indexWhere((element) => element.name == tab)];
                    _codeController!.fullText = selectedTab.currentCode;
                  });
                },
                type: "code",
              ),
            ),
            SingleChildScrollView(
                child: CodeTheme(
                    data: CodeThemeData(
                      styles: a11yDarkTheme,
                    ),
                    child: Container(
                      child: CodeField(
                        background: Colors.black,
                        controller: _codeController!,
                      ),
                    )))
          ]);
        }));
  }
}
