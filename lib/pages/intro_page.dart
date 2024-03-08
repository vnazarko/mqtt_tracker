import 'package:flutter/material.dart';
import 'package:mqtt_tracker/models/workspace_model.dart';
import 'package:provider/provider.dart';

class IntroPage extends StatelessWidget {
  const IntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<WorkspaceModel>(
      builder:(context, value, child) => SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.black,
            title: const Text(
              'MQTT Tracker',
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
            child: Center(
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (value.workspaceList.isEmpty) 
                    const Center(child: AddWorkspaceButton()),
                  if (value.workspaceList.isNotEmpty)
                    SingleChildScrollView(
                      child: Column(children: [
                        Container(
                          padding: const EdgeInsets.only(top: 7, right: 7, left: 7),
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(16, 0, 36, 1),
                            borderRadius: BorderRadius.circular(16)
                          ),
                          child: Column(children: [
                            for (Map<String, String> elem in value.workspaceList!.toList()) 
                              Column(
                                children: [
                                  WorkspaceElement(header: elem['Header'], description: elem['Description']),
                                  const SizedBox(height: 7,)
                                ],
                              ),
                          ]),
                        ),
                        const SizedBox(height: 14),
                        const AddWorkspaceButton()
                      ]),
                    )

                ]
              ),
            )
          ),
        ),
      )
    );
  }
}

class WorkspaceElement extends StatelessWidget {

  const WorkspaceElement({
    required this.header, 
    required this.description, 
  }) ;

  final String? header;
  final String? description;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 316,
      height: 136,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(34, 12, 51, 1),
        borderRadius: BorderRadius.circular(12)
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                header!,
                style: const TextStyle(
                  color: Color.fromRGBO(208, 188, 255, 1),
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                )
              ),
              const SizedBox(height: 9,),
              Text(
                description!,
                style: const TextStyle(
                  color: Color.fromRGBO(208, 188, 255, 1),
                  fontSize: 12.0,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.left,
              )
            ],
          ),
          Container(
            width: 50,
            decoration: BoxDecoration(
              color: const Color.fromRGBO(22, 4, 39, 1),
              borderRadius: BorderRadius.circular(500)
            ),
            child: const Padding(
              padding: EdgeInsets.all(2.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  WorkspaceButton(icon: Icons.edit_outlined),
                  WorkspaceButton(icon: Icons.delete_outline),
                ]
              ),
            ),
          )
        ],
      )
    );
  }
}

class WorkspaceButton extends StatelessWidget {
  final IconData icon;

  const WorkspaceButton({
    super.key,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      alignment: Alignment.center,
      onPressed: null, 
      icon: Icon(
        icon,
        color: const Color.fromRGBO(208, 188, 255, 1),
        // size: 20,
      ),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(const Color.fromRGBO(34, 12, 51, 1))
      )
    );
  }
}

class AddWorkspaceButton extends StatelessWidget {
  const AddWorkspaceButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 230.0,
      height: 50.0,
      child: OutlinedButton(
        style: ButtonStyle(
          maximumSize: MaterialStateProperty.all(const Size(230.0, 50.0)),
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
          Navigator.pushNamed(context, '/add-workspace');
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
    );
  }
}