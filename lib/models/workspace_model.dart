import 'package:flutter/material.dart';

class WorkspaceModel extends ChangeNotifier {
  final List<Map<String, dynamic>> _workspaceList = [];

  List<Map<String, dynamic>> get workspaceList => _workspaceList;

  void addWorkspace(Map<String, dynamic> workspace) {
    _workspaceList.add(workspace);
    notifyListeners();
  } 
  void editWorkspace(Map<String, dynamic> workspace, String index) {
    _workspaceList.removeAt(int.parse(index));
    _workspaceList.insert(int.parse(index), workspace);
    notifyListeners();
  }
  void deleteWorkspace(String index) {
    _workspaceList.removeWhere((workspace) => workspace['Id'] == index);
    notifyListeners();
  }
  void addWidget(Map widget, String index) {
    _workspaceList[int.tryParse(index)!]['Widgets'].add(widget);
  }
}