import 'package:flutter/material.dart';
import 'package:mqtt_tracker/models/workspace_model.dart';
import 'package:mqtt_tracker/mqtt_manager.dart';
import 'package:mqtt_tracker/pages/widgets_for_workspace/widget.dart';

class SliderOfWorkspace extends ElemOfWorkspaceWithState {
  String min;
  String max;
  final String? text;
  final Map<String, dynamic> currentWorkspace;

  SliderOfWorkspace({super.key, super.inWorkspace, super.topic, required this.min, required this.max, this.text, required this.currentWorkspace});

  @override
  State<SliderOfWorkspace> createState() => _SliderOfWorkspaceState();
}

class _SliderOfWorkspaceState extends State<SliderOfWorkspace> {

  late double _valueOfSlider;

  @override
  void initState() {
    super.initState();
    _valueOfSlider = (double.tryParse(widget.min)! + double.tryParse(widget.max)!) / 2;
  }
  @override
  Widget build(BuildContext context) {
    final double? min = double.tryParse(widget.min);
    final double? max = double.tryParse(widget.max);
    
    final mqttManager = MqttManager(
      server: widget.currentWorkspace['Server'],
      username: widget.currentWorkspace['User'], 
      password: widget.currentWorkspace['Password'], 
      port: int.parse(widget.currentWorkspace['Port']),
      clientId: 'slider/${widget.text}/${widget.currentWorkspace['Widgets'].length}',
    );

    if (widget.inWorkspace != false) mqttManager.connect();


    return Column(
      children: [
        if (widget.text != null)
          Text(
            widget.text!,
            style: const TextStyle(
              color: Color.fromRGBO(208, 188, 255, 1),
              fontWeight: FontWeight.w500,
              fontSize: 22,
            ),
          ),
        SizedBox(
          width: widget.inWorkspace! ? double.infinity : 156,
          child: SliderTheme(
            data: SliderTheme.of(context).copyWith(
              showValueIndicator: ShowValueIndicator.always,
              trackHeight: 12,
              activeTrackColor: const Color.fromRGBO(208, 188, 255, 1),
              inactiveTrackColor: const Color.fromRGBO(79, 55, 139, 1),
              thumbColor: const Color.fromRGBO(208, 188, 255, 1),
              thumbShape: const AppSliderShape(thumbRadius: 10),
            ),
            child: Slider(
              min: min!,
              max: max!,
              value: _valueOfSlider,
              label: _valueOfSlider.toStringAsFixed(1),
              onChanged: (value) {
                setState(() {
                  _valueOfSlider = value;
                  mqttManager.publishMessage(widget.topic!, value.toStringAsFixed(1));  
                });
              },      
            ),
          ),
        ),
      ],
    );
  }
}

class SliderWidgetForm extends StatelessWidget {
  final WorkspaceModel workspaceList;
  final String index;
  final Map<String, dynamic> currentWorkspace;

  const SliderWidgetForm({super.key, required this.workspaceList, required this.index, required this.currentWorkspace});


  @override
  Widget build(BuildContext context) {
  final TextEditingController name = TextEditingController();
  final TextEditingController topic = TextEditingController();
  final TextEditingController min = TextEditingController();
  final TextEditingController max = TextEditingController();


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
          SaveButton(
            workspaceList: workspaceList,
            name: name,
            topic: topic,
            index: index,
            min: min,
            max: max,
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
  final TextEditingController min;
  final TextEditingController max;
  final String index;
  final Map<String, dynamic> currentWorkspace;


  const SaveButton({
    super.key, required this.name, required this.topic, required this.workspaceList, required this.index, required this.min, required this.max, required this.currentWorkspace,
  });

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> widgetInfo = {
      'Name': '',
      'Topic': '',
      'Min': '',
      'Max': '',
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
              if (topic.value.text.isNotEmpty && min.value.text.isNotEmpty && max.value.text.isNotEmpty) {
                widgetInfo['Name'] = name.text;
                widgetInfo['Topic'] = topic.text;
                widgetInfo['Min'] = min.text;
                widgetInfo['Max'] = max.text;
                widgetInfo['Widget'] = SliderOfWorkspace(inWorkspace: true, topic: topic.text, min: min.text, max: max.text, text: name.text, currentWorkspace: currentWorkspace);

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

class AppSliderShape extends SliderComponentShape {
    final double thumbRadius;

    const AppSliderShape({required this.thumbRadius});

    @override
    Size getPreferredSize(bool isEnabled, bool isDiscrete) {
        return Size.fromRadius(thumbRadius);
    }

    @override
    void paint(
      PaintingContext context,
      Offset center, {
      required Animation<double> activationAnimation,
      required Animation<double> enableAnimation,
      required bool isDiscrete,
      required TextPainter labelPainter,
      required RenderBox parentBox,
      required SliderThemeData sliderTheme,
      required TextDirection textDirection,
      required double value,
      required double textScaleFactor,
      required Size sizeWithOverflow,
  }) {
    final Canvas canvas = context.canvas;

    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = const Color.fromRGBO(208, 188, 255, 1);

    // draw icon with text painter
    const iconData = Icons.drag_handle;
    final TextPainter textPainter = TextPainter(textDirection: TextDirection.rtl);
    textPainter.text = TextSpan(
        text: String.fromCharCode(iconData.codePoint),
        style: TextStyle(
          fontSize: thumbRadius * 2,
          fontFamily: iconData.fontFamily,
          color: sliderTheme.thumbColor,
        ));
    textPainter.layout();

    const cornerRadius = 4.0;

    // draw the background shape here..
    canvas.drawRRect(
      RRect.fromRectXY(
          Rect.fromCenter(center: center, width: 4, height: 44), cornerRadius, cornerRadius),
      paint,
    );
  }
}
