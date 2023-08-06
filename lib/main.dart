import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:writer/writer/writer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final brightness = PlatformDispatcher.instance.platformBrightness;
    return MaterialApp(
      title: 'Writer',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            brightness: brightness, seedColor: Colors.deepPurple),
        brightness: brightness,
        useMaterial3: true,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const Writer(),
    );
  }
}
