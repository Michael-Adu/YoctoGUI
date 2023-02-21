import 'package:flutter/material.dart';
import 'package:process_run/shell.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import './pages/home.dart';
import './global.dart' as global;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  doWhenWindowReady(() async {
    const initialSize = Size(1920, 1080);
    appWindow.minSize = Size(1280, 720);
    appWindow.size = initialSize;
    appWindow.alignment = Alignment.center;
    appWindow.show();
    runServer();
    global.retrieveBranches();
  });
  runApp(const MyApp());
}

void runServer() async {
  var shell = Shell();
  await shell.run('''killall node
  
  node ./lib/test.js''');
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: global.navigatorKey,
      theme: global.darkTheme,
      title: 'Yocto GUI',
      home: Home(),
    );
  }
}
