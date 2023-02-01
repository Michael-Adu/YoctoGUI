import 'package:flutter/material.dart';
import 'package:yocto_gui/components/terminal.dart';
import 'package:yocto_gui/components/yoctoGUITabs.dart';

class TerminalBake extends StatefulWidget {
  const TerminalBake({Key? key}) : super(key: key);

  @override
  _TerminalBakeState createState() => _TerminalBakeState();
}

class _TerminalBakeState extends State<TerminalBake> {
  Widget terminalWidget = Container();
  Widget serialConsoleWidget = Container();
  Widget activeConsole = Container();

  @override
  void initState() {
    super.initState();
    terminalWidget = Terminal();
    activeConsole = terminalWidget;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Container(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey))),
          alignment: Alignment.centerLeft,
          height: MediaQuery.of(context).size.height * 0.03,
          width: MediaQuery.of(context).size.width,
          child: Container(
              width: MediaQuery.of(context).size.width * 0.12,
              child: YoctoGUITabs(
                type: "console",
                tabs: ["Terminal", "Serial Console"],
                onSwitch: (value) {
                  if (value == "Terminal") {
                    setState(() {
                      activeConsole = terminalWidget;
                    });
                    print("Switching to ${value}");
                  } else {
                    setState(() {
                      activeConsole = serialConsoleWidget;
                    });
                  }
                },
              )),
        ),
        Row(
          children: [
            Container(
                child: activeConsole,
                height: constraints.maxHeight * 0.9,
                width: constraints.maxWidth * 0.8),
            Container()
          ],
        )
      ]));
    });
  }
}
