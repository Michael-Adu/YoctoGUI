library yocto_gui.globals;

import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:filesystem_picker/filesystem_picker.dart';
import 'dart:io';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
List<TerminalCommand> allCommands = List<TerminalCommand>.empty(growable: true);
ValueNotifier<List<CodeTabs>> allCodeTabs = ValueNotifier<List<CodeTabs>>(
    [CodeTabs("test.c", Directory(""), "", "", true, false)]);
String user_host = "";
String initWD = "";

Future<Directory> getDirectory() async {
  Directory documentPath = Directory("/home");
  String? folderPath = await FilesystemPicker.open(
    title: 'Pick Directory',
    showGoUp: true,
    context: navigatorKey.currentContext!,
    rootDirectory: documentPath!,
    fsType: FilesystemType.folder,
    pickText: 'Pick Folder',
  );
  Directory folder = Directory("/home");
  if (folderPath != null) {
    folder = Directory(folderPath!);
  }

  return folder;
}

class Folder {
  Directory folder;
  List<Folder> subFolder;
  List<Directory> filesInFolder;

  Folder(this.folder, this.subFolder, this.filesInFolder);
}

class MenuButton {
  String label;
  Function? onClick;

  MenuButton(this.label, this.onClick);
}

class TerminalCommand {
  int commandIndex;
  String user_hostName;
  String wd;
  String command;
  String commandType;
  String stdout;
  String stderr;
  bool enabled;
  TerminalCommand(
    this.commandIndex,
    this.user_hostName,
    this.wd,
    this.commandType,
    this.command,
    this.stdout,
    this.stderr,
    this.enabled,
  );

  Map toJson() => {
        "commandIndex": "${commandIndex}",
        "user_hostname": "${user_hostName}",
        "workingDirectory": "${wd}",
        "commandType": "${commandType}",
        "command": "${command}",
        "stdout": "${stdout}",
        "output": "${stderr}",
        "enabled": "${enabled}"
      };
}

class CodeTabs {
  String name;
  Directory directory;
  String currentCode;
  String originalCode;
  bool saved;
  bool changed;
  CodeTabs(this.name, this.directory, this.currentCode, this.originalCode,
      this.changed, this.saved);
  Map toJson() => {
        "name": "${name}",
        "directory": "${directory}",
        "currentCode": "${currentCode}",
        "originalCode": "${originalCode}",
        "saved": "${saved}",
        "changed": "${changed}"
      };
}

Future<List<Folder>> getAllDirectory(Directory folder) async {
  List<Folder> allFolders = List<Folder>.empty(growable: true);
  try {
    folder.listSync().forEach((e) {
      try {
        if (e.path.substring(e.path.lastIndexOf("/") + 1).contains(".")) {
        } else {
          allFolders.add(Folder(Directory(e.path), [], []));
        }
      } catch (e) {}
    });
  } catch (e) {}

  return allFolders;
}

Future<List<Directory>> getAllFiles(Directory folder) async {
  List<Directory> files = List<Directory>.empty(growable: true);
  try {
    folder.listSync().forEach((e) {
      if (e.path.substring(e.path.lastIndexOf("/") + 1).contains(".")) {
        files.add(Directory(e.path));
      }
    });
  } catch (e) {}

  return files;
}

ThemeData darkTheme = ThemeData(
    // scaffoldBackgroundColor: Colors.black,
    appBarTheme: AppBarTheme(
        backgroundColor: Colors.black,
        centerTitle: true,
        toolbarHeight: 50,
        titleTextStyle: TextStyle(fontSize: 20)),
    iconButtonTheme: IconButtonThemeData(
        style: ButtonStyle(
      iconColor: MaterialStateProperty.all<Color>(Colors.white),
    )),
    textTheme: const TextTheme(
      bodySmall: TextStyle(
        fontFamily: 'SourceCode',
        color: Colors.white,
      ),
      bodyMedium: TextStyle(color: Colors.white, fontFamily: 'SourceCode'),
      bodyLarge: TextStyle(color: Colors.white, fontFamily: 'SourceCode'),
    ));

Future<TerminalCommand> executeCommand(TerminalCommand inputCommand) async {
  TerminalCommand result = TerminalCommand(
      0, "", "", inputCommand.commandType, inputCommand.command, "", "", false);

  var response = await http.Client()
      .post(Uri.parse("http://localhost:5768"), body: jsonEncode(inputCommand));

  try {
    print(response.body.replaceAll(r'\', r"\\"));
    var finalResponse = jsonDecode(response.body.replaceAll(r'\', r"\\"));
    if (inputCommand.commandType == "execute") {
      user_host = '${finalResponse["userHostName"]}';
      result.user_hostName = '${finalResponse["userHostName"]}';
      result.wd = '${finalResponse["workingDirectory"]}';
      print(finalResponse["stdout"].toString().replaceAll('\\n', '\n'));
      result.stdout =
          '${finalResponse["stdout"].toString().replaceAll('\\n', '\n')}';
      result.stderr = '${finalResponse["stderr"]}';
    } else if (inputCommand.commandType == "init") {
      user_host = '${finalResponse["userHostName"]}';
      initWD = '${finalResponse["workingDirectory"]}';
      result.user_hostName = '${finalResponse["userHostName"]}';
      result.wd = '${finalResponse["workingDirectory"]}';
    }
  } catch (e) {
    print(e);
  }

  return result;
}
