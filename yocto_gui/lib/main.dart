import 'package:flutter/material.dart';
import './pages/home.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import './global.dart' as global;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Must add this line.
  doWhenWindowReady(() {
    const initialSize = Size(1920, 1080);
    appWindow.minSize = Size(1280, 720);
    appWindow.size = initialSize;
    appWindow.alignment = Alignment.center;
    appWindow.show();
  });
  runApp(const MyApp());
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
