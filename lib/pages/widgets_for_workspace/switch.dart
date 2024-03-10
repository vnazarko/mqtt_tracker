import 'package:flutter/material.dart';
import 'package:mqtt_tracker/pages/widgets_for_workspace/widget.dart';

class SwitchOfWorkspace extends ElemOfWorkspaceWithState {
  SwitchOfWorkspace({super.key, super.topic, super.inWorkspace});

  @override
  State<SwitchOfWorkspace> createState() => _SwitchOfWorkspaceState();
}

class _SwitchOfWorkspaceState extends State<SwitchOfWorkspace> {
  bool isActive = false;

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: isActive,
      activeColor: const Color.fromRGBO(56, 30, 114, 1),
      activeTrackColor: const Color.fromRGBO(208, 188, 255, 1),
      inactiveThumbColor: const Color.fromRGBO(147, 143, 153, 1),
      inactiveTrackColor: const Color.fromRGBO(54, 52, 59, 1),
      onChanged: (bool value) {
        setState(() {
          isActive = value;
        });
      },
    );
  }
}