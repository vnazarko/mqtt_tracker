import 'package:flutter/material.dart';
import 'package:mqtt_tracker/models/workspace_model.dart';
import 'package:mqtt_tracker/pages/widgets_for_workspace/widget.dart';
import 'package:http/http.dart' as http;

class CircularProgressBarOfWorkspace extends ElemOfWorkspaceWithState {
  final String? additionalText;
  final String? text;
  final String? min;
  final String? max;

  CircularProgressBarOfWorkspace({super.key, super.inWorkspace, super.topic, this.additionalText, this.text, this.min, this.max});

  @override
  State<CircularProgressBarOfWorkspace> createState() => _CircularProgressBarOfWorkspaceState();
}

class _CircularProgressBarOfWorkspaceState extends State<CircularProgressBarOfWorkspace> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  double progressValue = 0.0;

  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    
    _animation = Tween(begin: 0.0, end: progressValue).animate(_animationController)
      ..addListener(() {
        setState(() {
          progressValue = _animation.value;
        });
      });

    fetchData();
  }

  void fetchData() async {
    // Здесь может быть ваш запрос к серверу для получения значения прогресса
    // В данном примере просто устанавливаем случайное значение
    // var response = await http.get('YOUR_API_ENDPOINT');
    // var data = jsonDecode(response.body);
    // double progress = data['progress'];
    double progress = 0.8;
    
    _animationController.reset();
    _animation = Tween(begin: progressValue, end: progress).animate(_animationController);
    _animationController.forward();
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (widget.text != null)
          Column(
            children: [
              Text(
                widget.text!,
                style: const TextStyle(
                  fontSize: 22,
                  color: Color.fromRGBO(208, 188, 255, 1)
                ),
              ),
              SizedBox(height: 10,)
            ],
          ),
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: widget.inWorkspace! ? 100 : 50,
              height: widget.inWorkspace! ? 100 : 50,
              child: CircularProgressIndicator(
                value: progressValue,
                valueColor: const AlwaysStoppedAnimation(Color.fromRGBO(208, 188, 255, 1)),
                backgroundColor: const Color.fromRGBO(79, 55, 139, 1),
              ),
            ),
            Center(
              child: Text(
                widget.inWorkspace! ? '37 ${widget.additionalText}' : '47°C',
                style: TextStyle(
                  fontSize: widget.inWorkspace! ? 22 : 16,
                  color: Color.fromRGBO(208, 188, 255, 1)
                ),
              ) 
            )
          ],
        ),
      ],
    );
  }
}

class CircularProgressBarWidgetForm extends StatelessWidget {
  final WorkspaceModel workspaceList;
  final String index;

  const CircularProgressBarWidgetForm({super.key, required this.workspaceList, required this.index});


  @override
  Widget build(BuildContext context) {
  final TextEditingController name = TextEditingController();
  final TextEditingController topic = TextEditingController();
  final TextEditingController min = TextEditingController();
  final TextEditingController max = TextEditingController();
  final TextEditingController additionalText = TextEditingController();


    return Form(
      child: Column(
        children: [
          WorkspaceTextField(
            hintText: 'Peak temperature in the living room', 
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
          Row(
            children: [
              Flexible(
                child: WorkspaceTextField(
                  hintText: '50',
                  labelText: 'Min*',
                  controller: min,
                )
              ),
              const SizedBox(width: 25,),
              Flexible(
                child: WorkspaceTextField(
                  hintText: '100',
                  labelText: 'Max*',
                  controller: max,
                )
              ),
            ],
          ),
          const SizedBox(height: 25,),
          WorkspaceTextField(
            hintText: '°C', 
            labelText: 'Additional Text', 
            controller: additionalText,
          ),
          const SizedBox(height: 25,),
          SaveButton(
            workspaceList: workspaceList,
            name: name,
            topic: topic,
            index: index,
            min: min,
            max: max,
            additionalText: additionalText
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
  final TextEditingController min;
  final TextEditingController max;
  final TextEditingController additionalText;
  final String index;


  const SaveButton({
    super.key, required this.name, required this.topic, required this.workspaceList, required this.index, required this.min, required this.max, required this.additionalText,
  });

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> widgetInfo = {
      'Name': '',
      'Topic': '',
      'Min': '',
      'Max': '',
      'AdditionalText': '',
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
              if (topic.value.text.isNotEmpty && min.value.text.isNotEmpty && max.value.text.isNotEmpty && additionalText.value.text.isNotEmpty) {
                widgetInfo['Name'] = name.text;
                widgetInfo['Topic'] = topic.text;
                widgetInfo['Min'] = min.text;
                widgetInfo['Max'] = max.text;
                widgetInfo['AdditionalText'] = additionalText.text;
                widgetInfo['Widget'] = CircularProgressBarOfWorkspace(inWorkspace: true, topic: topic.text, min: min.text, max: max.text, text: name.text, additionalText: additionalText.text);

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