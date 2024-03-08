import 'package:flutter/material.dart';

class WorkspaceModel extends ChangeNotifier {
  List<Map<String, String>> _workspaceList = [];

  List<Map<String, String>> get workspaceList => _workspaceList;

  void addWorkspace(Map<String, String> workspace) {
    _workspaceList!.add(workspace);
    notifyListeners();
  } 
}