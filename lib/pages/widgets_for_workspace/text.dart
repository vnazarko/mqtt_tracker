import 'package:flutter/material.dart';
import 'package:mqtt_tracker/pages/widgets_for_workspace/widget.dart';

class TextOfWorkspace extends ElemOfWorkspace {
  TextOfWorkspace({super.key, super.inWorkspace, super.topic});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 165,
      height: 55,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(500),
          border: Border.all(
            color: const Color.fromRGBO(79, 55, 139, 1),
            width: 7
          )
        ),
        child: Center(
          child: Text(
            !inWorkspace! ? 'Received text' : null as String, 
            style: TextStyle(
              color: const Color.fromRGBO(208, 188, 255, 1),
              fontWeight: FontWeight.w500,
              fontSize: inWorkspace! ? 22 : 18,
            ),
          ),
        ),
      )
    );
  }
}