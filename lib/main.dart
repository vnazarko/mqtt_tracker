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
    // Использовать FutureBuilder для управления загрузкой данных.
    return FutureBuilder<List<Map<String, dynamic>>?>(
      // «future» должен быть вашим вызовом асинхронного метода, который возвращает Future.
      future: Provider.of<WorkspaceModel>(context, listen: false).loadListOfWorkspaces('workspaces'),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          // После завершения загрузки данных, сохраняем их в модели.
          if (snapshot.data != null) {
            Provider.of<WorkspaceModel>(context, listen: false).setWorkspaceList(snapshot.data);
          }

          // Ваше приложение готово к использованию.
          return MaterialApp(
            debugShowCheckedModeBanner: false,
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
        else if (snapshot.hasError) {
          // В случае ошибки загрузки данных
          return MaterialApp(home: Scaffold(body: Center(child: Text('Ошибка загрузки данных'))));
        }
        else {
          // Пока данные загружаются, отображать индикатор загрузки
          return MaterialApp(home: Scaffold(body: Center(child: CircularProgressIndicator())));
        }
      },
    );
  }
}


