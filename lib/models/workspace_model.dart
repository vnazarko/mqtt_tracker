import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WorkspaceModel extends ChangeNotifier {
  List<Map<String, dynamic>> _workspaceList = [];

  List<Map<String, dynamic>> get workspaceList => _workspaceList;
  void setWorkspaceList(List<Map<String, dynamic>>? list) => _workspaceList = list!;

  void addWorkspace(Map<String, dynamic> workspace) {
    _workspaceList.add(workspace);
    saveListOfWorkspaces('workspaces', _workspaceList);

    notifyListeners();
  } 
  void editWorkspace(Map<String, dynamic> workspace, String index) {
    _workspaceList.removeAt(int.parse(index));
    _workspaceList.insert(int.parse(index), workspace);
    saveListOfWorkspaces('workspaces', _workspaceList);

    notifyListeners();
  }
  void deleteWorkspace(String index) {
    _workspaceList.removeWhere((workspace) => workspace['Id'] == index);
    saveListOfWorkspaces('workspaces', _workspaceList);

    notifyListeners();
  }
  void addWidget(Map widget, String index) {
    _workspaceList[int.tryParse(index)!]['Widgets'].add(widget);
    saveListOfWorkspaces('workspaces', _workspaceList);
  }

  // Запись в локальное хранилище
  Future<void> saveListOfWorkspaces(String key, List<Map<String, dynamic>> listOfWorkspaces) async {
    final prefs = await SharedPreferences.getInstance();

    // Кодируем весь список словарей в строку JSON
    String jsonString = jsonEncode(listOfWorkspaces);
    await prefs.setString(key, jsonString);
  }
  // Чтение из локального хранилища
  Future<List<Map<String, dynamic>>?> loadListOfWorkspaces(String key) async {
    final prefs = await SharedPreferences.getInstance();

    String? jsonString = prefs.getString(key);
    if (jsonString == null) return null;

    List<dynamic> jsonList = jsonDecode(jsonString);
    // Преобразуем каждый элемент в Map<String, dynamic>
    List<Map<String, dynamic>> listOfWorkspaces = jsonList
        .map((item) => Map<String, dynamic>.from(item))
        .toList();

    return listOfWorkspaces;
  }

}