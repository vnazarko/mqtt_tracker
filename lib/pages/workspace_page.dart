import 'package:flutter/material.dart';
import 'package:mqtt_tracker/models/workspace_model.dart';
import 'package:mqtt_tracker/pages/widgets_for_workspace/button.dart';
import 'package:mqtt_tracker/pages/widgets_for_workspace/circular_progress_bar.dart';
import 'package:mqtt_tracker/pages/widgets_for_workspace/slider.dart';
import 'package:mqtt_tracker/pages/widgets_for_workspace/switch.dart';
import 'package:mqtt_tracker/pages/widgets_for_workspace/text.dart';
import 'package:provider/provider.dart';

enum Types {
  button, 
  text,
  slider,
  switchElem,
  temperatureGauge
}

class WorkspacePage extends StatefulWidget {
  const WorkspacePage({super.key});

  @override
  State<WorkspacePage> createState() => _WorkspacePageState();
}

class _WorkspacePageState extends State<WorkspacePage> {
  bool isClicked = false;
  @override
  Widget build(BuildContext context) {

    final provider = Provider.of<WorkspaceModel>(context);

    final String workspaceId = ModalRoute.of(context)!.settings.arguments as String;  
    Map<String, dynamic> currentWorkspace = {};


    for (final workspace in provider.workspaceList.toList()) {
      if (workspace['Id'] == workspaceId) {
        currentWorkspace = workspace; 
      }
    }

    void pushToEditWorkspacePage(BuildContext context, String id) {
      Navigator.pushNamed(context, '/edit-workspace', arguments: id);
    }


    return Consumer<WorkspaceModel>(
      builder: (context, value, child) => Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.black,
          title: Text(
            currentWorkspace['Header']!,
            style: const TextStyle(
              color: Color.fromRGBO(208, 188, 255, 1),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        body: Container(
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
          padding: const EdgeInsets.all(15),
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [ 
              Container(
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(27, 10, 49, 1),
                  borderRadius: BorderRadius.circular(16)
                ),
                width: double.infinity,
                child: const Workspace(),
              ),
              AnimatedPositioned(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                bottom: isClicked ? MediaQuery.of(context).size.height / 1.48 : 10,
                child: Container(
                  width: 100,
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(22, 4, 39, 1),
                    borderRadius: BorderRadius.circular(500)
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(2),
                    child: Row(
                      children: [
                        WorkspaceButton(
                          icon: Icons.add, 
                          action: () { 
                            setState(() {
                                isClicked = !isClicked;
                            });
                          }
                        ),
                        WorkspaceButton(icon: Icons.settings_outlined, action: () => pushToEditWorkspacePage(context, currentWorkspace['Id']!)),
                      ]
                    ),
                  ),
                )
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                height: isClicked ? MediaQuery.of(context).size.height / 1.5 : 0.0,
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(22, 4, 39, 1),
                    borderRadius: BorderRadius.circular(16)
                  ),
                  child: const ListOfWidgets(),
                )
              )
            ]
          ),
        )
      ),
    );
  }
}

class Workspace extends StatelessWidget {
  const Workspace({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
        ],
      ),
    );
  }
}

class ListOfWidgets extends StatelessWidget {

  const ListOfWidgets({super.key});


  @override
  Widget build(BuildContext context) {
    
    final widgets = [
      WidgetForWorkspace(
        text: 'Button', 
        widget: ButtonWidget(
          inWorkspace: false,
          widgetText: 'Button',
        ), 
      ),
      const SizedBox(height: 12,),
      WidgetForWorkspace(
        text: 'Text', 
        widget: TextOfWorkspace(
          inWorkspace: false,
        ), 
      ),
      const SizedBox(height: 12,),
      WidgetForWorkspace(
        text: 'Slider', 
        widget: SliderOfWorkspace(
          inWorkspace: false,
          min: 0,
          max: 20,
        ),
      ),
      const SizedBox(height: 12,),
      WidgetForWorkspace(
        text: 'Switch', 
        widget: SwitchOfWorkspace(
          inWorkspace: false,
        )
      ),
      const SizedBox(height: 12,),
      WidgetForWorkspace(
        text: 'Gauge', 
        widget: CircularProgressBarOfWorkspace(
          inWorkspace: false,
        )
      ),
    ];

    return Expanded(
      child: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          for (final widget in widgets) 
            widget
        ],
      )
    );
  }
}

class WidgetForWorkspace extends StatelessWidget {
  final String text;
  final Widget widget;

  const WidgetForWorkspace({super.key, required this.text, required this.widget});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Navigator.pushNamed(context, '/edit-widget', arguments: );
      },
      child: Container(
        height: 80,
        decoration: BoxDecoration(
          color: const Color.fromRGBO(34, 12, 51, 1),
          borderRadius: BorderRadius.circular(14)
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              widget,
              Text(
                text,
                style: const TextStyle(
                  color: Color.fromRGBO(208, 188, 255, 1),
                  fontWeight: FontWeight.w500,
                  fontSize: 22
                )
              ),
            ],
          )
        ),
      ),
    );
  }
}

class WorkspaceButton extends StatelessWidget {
  final IconData icon;
  final void Function() action;

  const WorkspaceButton({
    super.key,
    required this.icon,
    required this.action,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      alignment: Alignment.center,
      onPressed: action, 
      icon: Icon(
        icon,
        color: const Color.fromRGBO(208, 188, 255, 1),
      ),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(const Color.fromRGBO(34, 12, 51, 1))
      )
    );
  }
}