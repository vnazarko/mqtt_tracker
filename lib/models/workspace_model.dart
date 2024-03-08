import 'package:flutter/material.dart';

class WorkspaceModel extends ChangeNotifier {
  List<Map<String, String>> _workspaceList = [];

  List<Map<String, String>> get workspaceList => _workspaceList;

  void addWorkspace(Map<String, String> workspace) {
    _workspaceList.add(workspace);
    notifyListeners();
  } 
  void editWorkspace(Map<String, String> workspace, String index) {
    _workspaceList.removeAt(int.parse(index));
    _workspaceList.insert(int.parse(index), workspace);
    notifyListeners();
  }
}