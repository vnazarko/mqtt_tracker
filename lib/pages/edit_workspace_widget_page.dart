import 'package:flutter/material.dart';
import 'package:mqtt_tracker/models/workspace_model.dart';
import 'package:provider/provider.dart';

class EditWorkspaceWidgetPage extends StatelessWidget {
  const EditWorkspaceWidgetPage({super.key});

  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments) as Map<String, dynamic>;

    return Consumer<WorkspaceModel>(
      builder: (context, value, child) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: Colors.black,
            title: Text(
              arguments['text'],
              style: const TextStyle(
                color: Color.fromRGBO(208, 188, 255, 1),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          body: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black,
                  Color.fromRGBO(20, 3, 55, 1),
                ],
                begin: FractionalOffset(0.0, 0.0),
                end: FractionalOffset(1.0, 1.0),
                tileMode: TileMode.mirror
              ),
            ),
            child: ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(horizontal: 35.0, vertical: 20),
              children: [
                Column(
                  children: [
                    arguments['widget'],  
                  ]
                ),
                const SizedBox(height: 50,),
                arguments['form'],
              ]
            )
          )
        );
      }
    );
  }
}

