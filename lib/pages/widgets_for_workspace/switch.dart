import 'package:flutter/material.dart';
import 'package:mqtt_tracker/models/workspace_model.dart';
import 'package:mqtt_tracker/mqtt_manager.dart';
import 'package:mqtt_tracker/pages/widgets_for_workspace/widget.dart';

class SwitchOfWorkspace extends ElemOfWorkspaceWithState {
  final String text;
  final Map<String, dynamic> currentWorkspace;

  SwitchOfWorkspace({super.key, super.topic, super.inWorkspace, required this.text, required this.currentWorkspace});

  @override
  State<SwitchOfWorkspace> createState() => _SwitchOfWorkspaceState();
}

class _SwitchOfWorkspaceState extends State<SwitchOfWorkspace> {
  bool isActive = false;

  @override
  Widget build(BuildContext context) {

    final mqttManager = MqttManager(
      server: widget.currentWorkspace['Server'],
      username: widget.currentWorkspace['User'], 
      password: widget.currentWorkspace['Password'], 
      port: int.parse(widget.currentWorkspace['Port']),
      clientId: 'switch/${widget.text}/${widget.currentWorkspace['Widgets'].length}',
    );

    if (widget.inWorkspace != false) mqttManager.connect();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Switch(
          value: isActive,
          activeColor: const Color.fromRGBO(56, 30, 114, 1),
          activeTrackColor: const Color.fromRGBO(208, 188, 255, 1),
          inactiveThumbColor: const Color.fromRGBO(147, 143, 153, 1),
          inactiveTrackColor: const Color.fromRGBO(54, 52, 59, 1),
          onChanged: (bool value) {
            setState(() {
              isActive = value;
              if (value == true) {
                mqttManager.publishMessage(widget.topic!, '1');
              } else {
                mqttManager.publishMessage(widget.topic!, '0');
              }
            });
          },
        ),
        const SizedBox(width: 10,),
        Text(
          widget.text,
          style: TextStyle(
            color: const Color.fromRGBO(208, 188, 255, 1),
            fontWeight: FontWeight.w500,
            fontSize: widget.inWorkspace! ? 22 : 18,
          ),
        )
      ],
    );
  }
}

class SwitchWidgetForm extends StatelessWidget {
  final WorkspaceModel workspaceList;
  final String index;
  final Map<String, dynamic> currentWorkspace;

  const SwitchWidgetForm({super.key, required this.workspaceList, required this.index, required this.currentWorkspace});


  @override
  Widget build(BuildContext context) {
  final TextEditingController name = TextEditingController();
  final TextEditingController topic = TextEditingController();


    return Form(
      child: Column(
        children: [
          WorkspaceTextField(
            hintText: 'Temperature in the living room', 
            labelText: 'Name', 
            controller: name,
          ),
          const SizedBox(height: 25,),
          WorkspaceTextField(
            hintText: '/topic', 
            labelText: 'MQTT Topic*', 
            controller: topic,
          ),
          const SizedBox(height: 25,),
          SaveButton(
            workspaceList: workspaceList,
            name: name,
            topic: topic,
            index: index,
            currentWorkspace: currentWorkspace
          )
        ]
      )
    );
  }
}

class WorkspaceTextField extends StatelessWidget {
  final String? hintText; 
  final String? labelText;
  final TextEditingController controller;

  const WorkspaceTextField ({
    super.key,
    required String this.hintText,
    required String this.labelText, 
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(
          color: Color.fromRGBO(147, 143, 153, 1)
        ),
        labelText: labelText,
        labelStyle: const TextStyle(
          color: Color.fromRGBO(208, 188, 255, 1)
        ),
        border: const OutlineInputBorder(),
      ),
      style: const TextStyle(
        color: Colors.white
      ),
    );
  }
}

class SaveButton extends StatelessWidget {
  final WorkspaceModel workspaceList; 
  final TextEditingController name;
  final TextEditingController topic;
  final String index;
  final Map<String, dynamic> currentWorkspace;


  const SaveButton({
    super.key, required this.name, required this.topic, required this.workspaceList, required this.index, required this.currentWorkspace,
  });

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> widgetInfo = {
      'Name': '',
      'Topic': '',
      // 'Widget': null,
      'Type': 'Switch',
    };

    return Column(
      children: [
        SizedBox(
          width: 120,
          child: OutlinedButton(
            style: ButtonStyle(
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50.0),
                ),
              ),
              side: MaterialStateProperty.all(
                const BorderSide(color: Color.fromRGBO(147, 143, 153, 1), width: 1),
              ),
            ),
            onPressed: () {
              if (topic.value.text.isNotEmpty) {
                widgetInfo['Name'] = name.text;
                widgetInfo['Topic'] = topic.text;
                // widgetInfo['Widget'] = SwitchOfWorkspace(inWorkspace: true, topic: topic.text, text: name.text, currentWorkspace: currentWorkspace);

                workspaceList.addWidget(widgetInfo, index);

                Navigator.pop(context);
              }
            },
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(Icons.add, color: Color.fromRGBO(208, 188, 255, 1),),
                Text(
                  'Add', 
                  style: TextStyle(
                    color: Color.fromRGBO(208, 188, 255, 1),
                    fontWeight: FontWeight.w500,
                    fontSize: 20.0
                  )
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}