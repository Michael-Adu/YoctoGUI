import 'package:flutter/material.dart';
import 'package:flutter_code_editor/flutter_code_editor.dart';
import 'package:flutter_highlight/themes/a11y-dark.dart';
import 'package:highlight/languages/cpp.dart';
import 'package:highlight/languages/makefile.dart';
import 'package:yocto_gui/components/yoctoGUITabs.dart';
import 'package:yocto_gui/global.dart' as global;

class CodeSpace extends StatefulWidget {
  String code;
  Function(String)? onChange;
  CodeSpace({this.code = "", this.onChange, Key? key}) : super(key: key);

  @override
  _CodeSpaceState createState() => _CodeSpaceState();
}

class _CodeSpaceState extends State<CodeSpace> {
  CodeController? _codeController;

  @override
  void initState() {
    super.initState();
    _codeController = CodeController(
      text: widget.code,
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
    return SingleChildScrollView(
        child: Column(children: [
      CodeTheme(
        data: CodeThemeData(
          styles: a11yDarkTheme,
        ),
        child: CodeField(
          onChanged: (code) {
            widget.onChange!(code);
          },
          background: Colors.black,
          controller: _codeController!,
        ),
      )
    ]));
  }
}
