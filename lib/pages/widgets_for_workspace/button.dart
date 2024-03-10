import 'package:flutter/material.dart';
import 'package:mqtt_tracker/models/workspace_model.dart';
import 'package:mqtt_tracker/pages/widgets_for_workspace/widget.dart';
import 'package:mqtt_tracker/pages/workspace_page.dart';
import 'package:provider/provider.dart';

class ButtonWidget extends ElemOfWorkspace {
  final String widgetText;
  final String? text;
  ButtonWidget({super.key, required this.widgetText, super.inWorkspace, super.topic, this.text});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        minWidth: 0,
        maxWidth: 250,
        minHeight: 90,
      ),
      child: SizedBox(
        width: inWorkspace! ? 250 : 130,
        height: 60,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (text != null)
              Column(
                children: [
                  Text(
                    text!,
                    style: const TextStyle(
                      color: Color.fromRGBO(208, 188, 255, 1),
                      fontWeight: FontWeight.w500,
                      fontSize: 22,
                    ),
                  ),
                  const SizedBox(height: 7,),
                ],
              ),
            ElevatedButton(
              onPressed: null,
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(const Color.fromRGBO(208, 188, 255, 1)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  widgetText,
                  style: TextStyle(
                    color: const Color.fromRGBO(27, 10, 49, 1),
                    fontWeight: FontWeight.w500,
                    fontSize: inWorkspace! ? 22 : 18,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ButtonWidgetForm extends StatelessWidget {
  final WorkspaceModel workspaceList;
  final String index;

  const ButtonWidgetForm({super.key, required this.workspaceList, required this.index});


  @override
  Widget build(BuildContext context) {
  final TextEditingController name = TextEditingController();
  final TextEditingController text = TextEditingController();
  final TextEditingController topic = TextEditingController();


    return Form(
      child: Column(
        children: [
          WorkspaceTextField(
            hintText: 'Led in the living room', 
            labelText: 'Name', 
            controller: name,
          ),
          const SizedBox(height: 25,),
          WorkspaceTextField(
            hintText: 'LED', 
            labelText: 'Text*', 
            controller: text,
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
            text: text,
            topic: topic,
            index: index,
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
  final TextEditingController text;
  final TextEditingController topic;
  final String index;


  const SaveButton({
    super.key, required this.name, required this.text, required this.topic, required this.workspaceList, required this.index,
  });

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> widgetInfo = {
      'Name': '',
      'Text': '',
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
              if (text.value.text.isNotEmpty && topic.value.text.isNotEmpty) {
                widgetInfo['Name'] = name.text;
                widgetInfo['Text'] = text.text;
                widgetInfo['Topic'] = topic.text;
                widgetInfo['Widget'] = ButtonWidget(widgetText: text.text, inWorkspace: true, topic: topic.text, text: name.text,);

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