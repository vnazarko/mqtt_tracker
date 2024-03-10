import 'package:flutter/material.dart';
import 'package:mqtt_tracker/models/workspace_model.dart';
import 'package:provider/provider.dart';

class EditWorkspaceWidgetPage extends StatelessWidget {
  const EditWorkspaceWidgetPage({super.key});

  @override
  Widget build(BuildContext context) {
    final form = (ModalRoute.of(context)?.settings.arguments) as Widget;

    return Consumer<WorkspaceModel>(
      builder: (context, value, child) {
        return Scaffold(

        );
      }
    );
  }
}