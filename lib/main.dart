import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:mqtt_tracker/models/workspace_model.dart';
import 'package:mqtt_tracker/mqtt_settings.dart';
import 'package:mqtt_tracker/pages/add_workspace_page.dart';
import 'package:mqtt_tracker/pages/edit_workspace_page.dart';
import 'package:mqtt_tracker/pages/edit_workspace_widget_page.dart';
import 'package:mqtt_tracker/pages/intro_page.dart';
import 'package:mqtt_tracker/pages/workspace_page.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  // if (MqttSettings.MqttServer != null && MqttSettings.MqttPort != null && MqttSettings.MqttUser != null && MqttSettings.MqttPassword != null) {
  //   final server = MqttSettings.MqttServer;
  //   final port = MqttSettings.MqttPort;
  //   final user = MqttSettings.MqttUser;
  //   final password = MqttSettings.MqttPassword;

  //   final client = MqttServerClient(server!, '');
  //   client.port = port!;
  //   client.logging(on: true);

  //   client.onConnected = () {
  //     print('Connected');
  //   };

  //   client.onDisconnected = () {
  //     print('Disconnected');
  //   };

  //   final connMess = MqttConnectMessage()
  //         .withClientIdentifier('your_client_id')
  //         .startClean()
  //         .authenticateAs(user, password)
  //         .keepAliveFor(60); // Must agree with the keep alive set above
  //   client.connectionMessage = connMess;

  //   await client.connect();
  // }

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
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          iconTheme: IconThemeData(color: Color.fromRGBO(208, 188, 255, 1)),
        )
      ),
      home: IntroPage(),
      routes: {
        '/home': (context) => const IntroPage(),
        '/add-workspace': (context) => AddWorkspacePage(),
        '/edit-workspace': (context) => const EditWorkspacePage(),
        '/workspace': (context) => const WorkspacePage(),
        '/edit-widget': (context) => const EditWorkspaceWidgetPage(),
      }
    );
  }
}

