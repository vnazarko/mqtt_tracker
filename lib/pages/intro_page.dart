import 'package:flutter/material.dart';
import 'package:mqtt_tracker/models/workspace_model.dart';
import 'package:provider/provider.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({super.key});

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<WorkspaceModel>(context);
    // final List<Map<String, dynamic>> workspaceList = provider.loadListOfWorkspaces('workspaces');
    provider.clearInfoOfTopic();

    return FutureBuilder(
      future: provider.loadListOfWorkspaces('workspaces'),
      builder: (context, snapshot) {

          final List<Map<String, dynamic>> workspaceList = snapshot.data ?? [];

          return Consumer<WorkspaceModel>(
            builder:(context, value, child) => Scaffold(
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
                    children: [
                      if (workspaceList.isEmpty)
                        const SizedBox(height: 20,),
                      if (workspaceList.isNotEmpty)
                        Expanded(
                          child: Container(
                            width: 330,
                            padding: const EdgeInsets.symmetric(horizontal: 7),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: const Color.fromRGBO(16, 0, 36, 1)
                            ),
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: value.workspaceList.length,
                              padding: const EdgeInsets.only(bottom: 7),
                              itemBuilder: (context, index) {
                                return WorkspaceElement(
                                  header: value.workspaceList[index]['Header'], 
                                  description: value.workspaceList[index]['Description'], 
                                  id: value.workspaceList[index]['Id'], 
                                  deleteMethod: () {
                                    final workspaceList = context.read<WorkspaceModel>();
                                    workspaceList.deleteWorkspace(value.workspaceList[index]['Id']!);
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 20,),
                        const AddWorkspaceButton(),
                        const SizedBox(height: 20,)
                    ],
                  ),
                )
              ),
            )
          );
        } 
    );
  }
}

class WorkspaceElement extends StatelessWidget {
  final String? header;
  final String? description;
  final String? id;
  final void Function() deleteMethod;

  const WorkspaceElement({super.key, 
    required this.header, 
    required this.description, 
    required this.id,
    required this.deleteMethod,
  }) ;


  void pushToEditWorkspacePage(BuildContext context, String id) {
    Navigator.pushNamed(context, '/edit-workspace', arguments: id);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, '/workspace', arguments: id);
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 7),
        child: Container(
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
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      WorkspaceButton(icon: Icons.settings_outlined, action: () => pushToEditWorkspacePage(context, id!)),
                      WorkspaceButton(icon: Icons.delete_outline, action: () => deleteMethod()),
                    ]
                  ),
                ),
              )
            ],
          )
        ),
      ),
    );
  }
}

class WorkspaceButton extends StatelessWidget {
  final IconData icon;
  final void Function() action;

  const WorkspaceButton({
    super.key,
    required this.icon,
    required this.action,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      alignment: Alignment.center,
      onPressed: action, 
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