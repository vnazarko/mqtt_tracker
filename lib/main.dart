import 'package:flutter/material.dart';
import 'package:mqtt_tracker/models/workspace_model.dart';
import 'package:mqtt_tracker/pages/add_workspace_page.dart';
import 'package:mqtt_tracker/pages/intro_page.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => WorkspaceModel(),
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          iconTheme: IconThemeData(color: Color.fromRGBO(208, 188, 255, 1)),
        )
      ),
      home: IntroPage(),
      routes: {
        '/home': (context) => IntroPage(),
        '/add-workspace':(context) => AddWorkspacePage(),
      }
    );
  }
}
