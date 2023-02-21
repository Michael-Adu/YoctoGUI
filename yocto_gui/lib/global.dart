library yocto_gui.globals;

import 'dart:io';
import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:flutter/material.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
List<TerminalCommand> allCommands = List<TerminalCommand>.empty(growable: true);
List<LayerBranches> allLayers = List<LayerBranches>.empty(growable: true);
List<CodeTabs> allCodeTabs = List<CodeTabs>.empty(growable: true);
ValueNotifier<bool> tabsChanged = ValueNotifier<bool>(false);
ValueNotifier<bool> layersLoaded = ValueNotifier<bool>(false);
ValueNotifier<bool> terminalChange = ValueNotifier<bool>(false);
String user_host = "";
String initWD = "";

class YoctoProject {
  String projectName;
  Directory projectPath;
  List<BitBakeLayer> bitBakeLayers;
  YoctoProject(this.projectName, this.projectPath, this.bitBakeLayers);
}

class BitBakeLayer {
  String layerName;
  String layerDescription;
  Directory layerPath;
  BitBakeLayer(this.layerName, this.layerDescription, this.layerPath);
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

class Tab {
  var tabData;
  Function? onClick;
  Function? onDelete;
  bool saved;
  Tab(this.tabData, this.saved, this.onClick, this.onDelete);
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

class LayerBranches {
  String branchName;
  Uri branchUri;
  List<OpenEmbeddedLayers> layers;

  LayerBranches(this.branchName, this.branchUri, this.layers);
}

class OpenEmbeddedLayers {
  String layerName;
  String description;
  String layerType;
  Uri repository;

  OpenEmbeddedLayers(
      this.layerName, this.layerType, this.description, this.repository);
}

Future<Directory> getDirectory() async {
  Directory documentPath = Directory("/home");
  String? folderPath = await FilePicker.platform.getDirectoryPath();
  Directory folder = Directory("/home");
  if (folderPath != null) {
    folder = Directory(folderPath!);
    executeCommand(TerminalCommand(0, "", "", "cd", folderPath, "", "", false))
        .then((value) {
      allCommands.clear();
      allCommands.add(
          TerminalCommand(0, user_host, initWD, "execute", "", "", "", true));
      terminalChange.value = true;
    });
  }

  return folder;
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
    var finalResponse = jsonDecode(response.body.replaceAll(r'\', r"\\"));
    if (inputCommand.commandType == "execute" ||
        inputCommand.commandType == "cd") {
      user_host = '${finalResponse["userHostName"]}';
      result.user_hostName = '${finalResponse["userHostName"]}';
      result.wd = '${finalResponse["workingDirectory"]}';
      initWD = result.wd;
      print(initWD);
      result.stdout =
          '${finalResponse["stdout"].toString().replaceAll('{nl}', '\n')}';
      result.stderr =
          '${finalResponse["stderr"].toString().replaceAll('{nl}', '\n')}';
      result.commandIndex = inputCommand.commandIndex;
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

Future<List<LayerBranches>> retrieveBranches() async {
  List<LayerBranches> branches = List<LayerBranches>.empty(growable: true);
  var response = await http.Client().get(Uri.parse(
      "https://layers.openembedded.org/layerindex/branch/master/layers/"));
  dom.Document html = dom.Document.html(response.body);
  final allElements = html
      .querySelectorAll(
          "#content > div > div > nav > div > ul:nth-child(1) > li > ul > li")
      .map((e) => e.innerHtml.trim())
      .toList();
  allElements.map((element) async {
    try {
      List<OpenEmbeddedLayers> layers =
          List<OpenEmbeddedLayers>.empty(growable: true);
      Uri url = Uri.parse(
          '''https://layers.openembedded.org${element.split("href=")[1].split(">")[0].trim().replaceAll('"', "")}''');
      String name = "";
      if (element.contains("<b>")) {
        name =
            element.split("<b>")[1].split("</b>")[0].replaceAll('"', '').trim();
      } else {
        name =
            element.split("</a>")[0].split('">')[1].replaceAll('"', '').trim();
      }
      retrieveLayers(url).then((value) {
        branches.add(LayerBranches(name, url, value));
      });
    } catch (e) {
      print('${e} for ${element}');
    }
  }).toList();
  allLayers = branches;
  print("Finished Loading Layers");
  return branches;
}

Future<List<OpenEmbeddedLayers>> retrieveLayers(Uri uri) async {
  List<OpenEmbeddedLayers> layers =
      List<OpenEmbeddedLayers>.empty(growable: true);
  var response = await http.Client().get(uri);
  dom.Document html = dom.Document.html(response.body);
  final allElements = html
      .querySelectorAll("#content > div > div > table > tbody > tr")
      .map((e) => e.innerHtml.trim())
      .toList();
  allElements.map((e) {
    List<String> tableData = e.split("/td");
    String layerName =
        tableData[0].split("/a")[0].split('">')[1].replaceAll("<", "");
    String description =
        tableData[1].split("</td>")[0].split("<td>")[1].replaceAll("<", "");
    String type =
        tableData[2].split("</td>")[0].split("<td>")[1].replaceAll("<", "");
    Uri repository = Uri.parse(
        tableData[3].split("<a")[0].split('">')[1].replaceAll('"', "").trim());
    layers.add(OpenEmbeddedLayers(layerName, type, description, repository));
  }).toList();
  layersLoaded.value = true;
  return layers;
}
