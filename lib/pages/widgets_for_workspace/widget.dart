import 'package:flutter/material.dart';

abstract class ElemOfWorkspace extends StatelessWidget {
  bool? inWorkspace = true;
  final String? topic;

  ElemOfWorkspace({super.key, this.topic, this.inWorkspace});


  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

abstract class ElemOfWorkspaceWithState extends StatefulWidget {
  bool? inWorkspace = true;
  final String? topic;

  ElemOfWorkspaceWithState({super.key, this.topic, this.inWorkspace});

  @override
  State<ElemOfWorkspaceWithState> createState() => _ElemOfWorkspaceWithStateState();
}

class _ElemOfWorkspaceWithStateState extends State<ElemOfWorkspaceWithState> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}