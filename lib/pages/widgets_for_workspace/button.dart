import 'package:flutter/material.dart';
import 'package:mqtt_tracker/pages/widgets_for_workspace/widget.dart';

class ButtonWidget extends ElemOfWorkspace {
  final String widgetText;
  ButtonWidget({super.key, required this.widgetText, super.inWorkspace, super.topic});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: inWorkspace! ? 150 : 130,
      height: 60,
      child: ElevatedButton(
        onPressed: null,
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(const Color.fromRGBO(208, 188, 255, 1)),
        ),
        child: Text(
          widgetText,
          style: TextStyle(
            color: const Color.fromRGBO(27, 10, 49, 1),
            fontWeight: FontWeight.w500,
            fontSize: inWorkspace! ? 22 : 18,
          ),
        ),
      )
    );
  }
}

class ButtonWidgetForm extends StatelessWidget {
  const ButtonWidgetForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}