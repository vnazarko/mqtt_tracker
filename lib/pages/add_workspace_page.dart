import 'package:flutter/material.dart';
import 'package:mqtt_tracker/models/workspace_model.dart';
import 'package:mqtt_tracker/pages/intro_page.dart';
import 'package:provider/provider.dart';

class AddWorkspacePage extends StatelessWidget {
  AddWorkspacePage({super.key});

  final header = TextEditingController();
  final description = TextEditingController();
  final server = TextEditingController();
  final port = TextEditingController();
  final user = TextEditingController();
  final password = TextEditingController();

  Map<String, dynamic> workspaceInfo = {
    'Header': '',
    'Description': '',
    'Server': '',
    'Port': '',
    'User': '',
    'Password': '',
    'Id': '',
    'Widgets': [],
  };

  @override
  Widget build(BuildContext context) {
    return Consumer<WorkspaceModel>(
      builder: (context, value, child) => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: const Text(
            'Add Workspace',
            style: TextStyle(
              color: Color.fromRGBO(208, 188, 255, 1),
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: true,
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.black,
                Color.fromRGBO(20, 3, 55, 1),
              ],
              begin: FractionalOffset(0.0, 0.0),
              end: FractionalOffset(1.0, 1.0),
              tileMode: TileMode.mirror
            ),
          ),
          child: Align(
            alignment: Alignment.topCenter,
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 35.0),
              children: [
                const SizedBox(height: 20,),
                WorkspaceTextField(
                  labelText: 'Workspace Header',
                  hintText: 'Living Room',
                  controller: header,
                ),
                const SizedBox(height: 25,),
                WorkspaceTextField(
                  labelText: 'Workspace Description',
                  hintText: 'Sensors in the living room',
                  controller: description,
                ),
                const SizedBox(height: 25,),
                WorkspaceTextField(
                  labelText: 'MQTT Server',
                  hintText: 'mqtt.server.com',
                  controller: server,
                ),
                const SizedBox(height: 25,),
                WorkspaceTextField(
                  labelText: 'MQTT Port',
                  hintText: '12345',
                  controller: port,
                ),
                const SizedBox(height: 25,),
                WorkspaceTextField(
                  labelText: 'MQTT User',
                  hintText: 'user',
                  controller: user,
                ),
                const SizedBox(height: 25,),
                WorkspaceTextField(
                  labelText: 'MQTT Password',
                  hintText: '12345678',
                  controller: password,
                ),
                const SizedBox(height: 25,),
                Center(
                  child: SizedBox(
                    width: 230.0,
                    height: 50.0,
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
                        if (header.value.text.isEmpty == false && description.value.text.isEmpty == false && server.value.text.isEmpty == false && port.value.text.isEmpty == false && user.value.text.isEmpty == false && password.value.text.isEmpty == false) {
                          workspaceInfo['Header'] = header.text;
                          workspaceInfo['Description'] = description.text;
                          workspaceInfo['Server'] = server.text;
                          workspaceInfo['Port'] = port.text;
                          workspaceInfo['User'] = user.text;
                          workspaceInfo['Password'] = password.text;
                          workspaceInfo['Id'] = value.workspaceList.length.toString();
        
                          final workspaceList = context.read<WorkspaceModel>();
                          workspaceList.addWorkspace(workspaceInfo);
        
                          Navigator.pushNamed(context, '/home');

                          print(workspaceInfo);
                        } 
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(Icons.add, size: 28.0, color: Color.fromRGBO(208, 188, 255, 1),),
                          Text(
                            'Add Workspace', 
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
                )
              ],
            ),
          )
        ),
      ),
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