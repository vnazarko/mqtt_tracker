import 'package:flutter/material.dart';
import 'package:mqtt_tracker/models/workspace_model.dart';
import 'package:mqtt_tracker/mqtt_manager.dart';
import 'package:mqtt_tracker/pages/widgets_for_workspace/widget.dart';
import 'package:provider/provider.dart';

class TextOfWorkspace extends ElemOfWorkspace {
  final String? text;
  final MqttManager mqttManager;

  TextOfWorkspace({super.key, super.inWorkspace, super.topic, this.text, required this.mqttManager});

  String recievedText = '';

  @override
  Widget build(BuildContext context) {
    mqttManager.connect();
    mqttManager.subscribeToTopic('$topic');

    return SizedBox(
      width: inWorkspace! ? 250 : 150,
      height: 91,
      child: Column(
        children: [
          if (text != null) 
            Column(
              children: [
                Text(
                  text!,
                  style: TextStyle(
                    color: const Color.fromRGBO(208, 188, 255, 1),
                    fontWeight: FontWeight.w500,
                    fontSize: inWorkspace! ? 22 : 18,
                  ),
                ),
                const SizedBox(height: 7,),
              ],
            ),
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(500),
              border: Border.all(
                color: const Color.fromRGBO(79, 55, 139, 1),
                width: 7
              )
            ),
            child: Center(
              child: Text(
                !inWorkspace! ? 'Received text' : '123', 
                style: TextStyle(
                  color: const Color.fromRGBO(208, 188, 255, 1),
                  fontWeight: FontWeight.w500,
                  fontSize: inWorkspace! ? 22 : 18,
                ),
              ),
            ),
          ),
        ],
      )
    );
  }
}

class TextWidgetForm extends StatelessWidget {
  final WorkspaceModel workspaceList;
  final String index;
  final MqttManager mqttManager;

  const TextWidgetForm({super.key, required this.workspaceList, required this.index, required this.mqttManager});


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
            mqttManager: mqttManager,
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
  final MqttManager mqttManager;


  const SaveButton({
    super.key, required this.name, required this.topic, required this.workspaceList, required this.index, required this.mqttManager
  });

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> widgetInfo = {
      'Name': '',
      'Topic': '',
      'Widget': null,
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
              if (name.value.text.isNotEmpty && topic.value.text.isNotEmpty) {
                widgetInfo['Name'] = name.text;
                widgetInfo['Topic'] = topic.text;
                widgetInfo['Widget'] = TextOfWorkspace(inWorkspace: true, topic: topic.text, text: name.text, mqttManager: mqttManager,);

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