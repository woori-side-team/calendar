import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "Calendar",
        home: Scaffold(appBar: AppBar(title: const Text("Calendar"))));
  }
}
