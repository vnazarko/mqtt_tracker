import 'package:flutter/material.dart';
import 'package:mqtt_tracker/models/workspace_model.dart';
import 'package:mqtt_tracker/mqtt_manager.dart';
import 'package:mqtt_tracker/pages/widgets_for_workspace/button.dart';
import 'package:mqtt_tracker/pages/widgets_for_workspace/circular_progress_bar.dart';
import 'package:mqtt_tracker/pages/widgets_for_workspace/slider.dart';
import 'package:mqtt_tracker/pages/widgets_for_workspace/switch.dart';
import 'package:mqtt_tracker/pages/widgets_for_workspace/text.dart';
import 'package:provider/provider.dart';

class WorkspacePage extends StatefulWidget {
  const WorkspacePage({super.key});

  @override
  State<WorkspacePage> createState() => _WorkspacePageState();
}

class _WorkspacePageState extends State<WorkspacePage> {
  bool isClicked = false;
  @override
  Widget build(BuildContext context) {

    final provider = Provider.of<WorkspaceModel>(context);

    final String workspaceId = ModalRoute.of(context)!.settings.arguments as String;  
    Map<String, dynamic> currentWorkspace = {};

    for (final workspace in provider.workspaceList.toList()) {
      if (workspace['Id'] == workspaceId) {
        currentWorkspace = workspace; 
        break;
      }
    }

    void pushToEditWorkspacePage(BuildContext context, String id) {
      Navigator.pushNamed(context, '/edit-workspace', arguments: id);
    }

    final mqttManager = MqttManager(
      server: currentWorkspace['Server'],
      username: currentWorkspace['User'], 
      password: currentWorkspace['Password'], 
      port: int.parse(currentWorkspace['Port']),
      clientId: 'client/${currentWorkspace['Header']}',
    );
    print(currentWorkspace['Widgets']);


    mqttManager.connect();
    
    @override
    void initState() {
      super.initState();
      provider.clearInfoOfTopic();
    }

    @override
    void dispose() {
      provider.clearInfoOfTopic();
      mqttManager.disconnect();
      super.dispose();
    }

    // mqttManager.publishMessage('/temp2', '123');
    return Consumer<WorkspaceModel>(
      builder: (context, value, child) => Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.black,
          title: Text(
            currentWorkspace['Header']!,
            style: const TextStyle(
              color: Color.fromRGBO(208, 188, 255, 1),
              fontWeight: FontWeight.w600,
            ),
          ),
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
          padding: const EdgeInsets.all(15),
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [ 
              Container(
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(27, 10, 49, 1),
                  borderRadius: BorderRadius.circular(16)
                ),
                width: double.infinity,
                child: Workspace(widgets: currentWorkspace['Widgets'], currentWorkspace: currentWorkspace, mqttManager: mqttManager,),
              ),
              AnimatedPositioned(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                bottom: isClicked ? MediaQuery.of(context).size.height / 1.48 : 10,
                child: Container(
                  width: 100,
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(22, 4, 39, 1),
                    borderRadius: BorderRadius.circular(500)
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(2),
                    child: Row(
                      children: [
                        WorkspaceButton(
                          icon: Icons.add, 
                          action: () { 
                            setState(() {
                                isClicked = !isClicked;
                            });
                          }
                        ),
                        WorkspaceButton(icon: Icons.settings_outlined, action: () => pushToEditWorkspacePage(context, currentWorkspace['Id']!)),
                      ]
                    ),
                  ),
                )
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                height: isClicked ? MediaQuery.of(context).size.height / 1.5 : 0.0,
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(22, 4, 39, 1),
                    borderRadius: BorderRadius.circular(16)
                  ),
                  child: ListOfWidgets(index: currentWorkspace['Id'], workspaceList: context.read<WorkspaceModel>(), currentWorkspace: currentWorkspace, mqttManager: mqttManager,),
                )
              )
            ]
          ),
        )
      ),
    );
  }
}

class Workspace extends StatelessWidget {
  final List widgets;
  final Map<String, dynamic> currentWorkspace;
  final MqttManager mqttManager;

  Workspace({
    super.key, required this.widgets, required this.currentWorkspace, required this.mqttManager,
  });

  int index = 0;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<WorkspaceModel>(context);
    
    Stream<Map<String, String>> getInfoFromTopics() async* {
      while (true) {
        await Future.delayed(const Duration(seconds: 1));
        List<String> topics = [];

        for (final widget in widgets) {
          if (widget['Type'] == 'Text' || widget['Type'] == 'Gauge') {
            topics.add(widget['Topic']);
            mqttManager.subscribe(topics);
            mqttManager.handleMessage(mqttManager.client);
              
            provider.addInfoOfTopic({'Topic': mqttManager.getReceivedText()['Topic']!.toString(), 'Text': mqttManager.getReceivedText()['Text']!.toString() });
          }
        }
        print(provider.infoOfTopic);
        yield mqttManager.getReceivedText(); // Получаем и отправляем новое значение в поток
      } 
    }

    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: ListView(
        children: [
          for (final widget in widgets) 
          StreamBuilder(
            stream: getInfoFromTopics(),
            builder: (context, snapshot) => Column(
              children: [
                if (widget['Type'] == 'Button') ButtonWidget(
                  widgetText: widget['Name'], 
                  topic: widget['Topic'], 
                  mqttManager: mqttManager, 
                  inWorkspace: true, 
                  key: Key('client/${index++}/${widgets.length.toString()}')
                ),

                if (widget['Type'] == 'Text') TextOfWorkspace(
                  text: widget['Name'], 
                  topic: widget['Topic'], 
                  inWorkspace: true, 
                  // infoFromTopic: snapshot.data != null && snapshot.data!['Topic'] == widget['Topic'] ? snapshot.data!['Text'] : 'null',
                  key: Key('client/${index++}/${widgets.length.toString()}')
                ),

                if (widget['Type'] == 'Slider') SliderOfWorkspace(
                  text: widget['Name'], 
                  min: widget['Min'], 
                  max: widget['Max'], 
                  topic: widget['Topic'],
                  // mqttManager: mqttManager, 
                  mqttManager: mqttManager,
                  inWorkspace: true, key: Key('client/${index++}/${widgets.length.toString()}')
                ),

                if (widget['Type'] == 'Switch') SwitchOfWorkspace(
                  text: widget['Name'], 
                  topic: widget['Topic'], 
                  currentWorkspace: currentWorkspace, 
                  inWorkspace: true, 
                  key: Key('client/${index++}/${widgets.length.toString()}')
                ),

                if (widget['Type'] == 'Gauge') CircularProgressBarOfWorkspace(
                  text: widget['Name'], 
                  topic: widget['Topic'], 
                  min: widget['Min'], 
                  max: widget['Max'], 
                  additionalText: widget['AdditionalText'], 
                  mqttManager: mqttManager, 
                  inWorkspace: true, 
                  key: Key('client/${index++}/${widgets.length.toString()}')
                ),

                const SizedBox(height: 20,)
              ],
            ),
          ),
        ]
      )
    );
  }
}

class ListOfWidgets extends StatelessWidget {
  final String index;
  final WorkspaceModel workspaceList; 
  final Map<String, dynamic> currentWorkspace;
  final MqttManager mqttManager;

  const ListOfWidgets({super.key, required this.index, required this.workspaceList, required this.currentWorkspace, required this.mqttManager});


  @override
  Widget build(BuildContext context) {
    
    final widgets = [
      WidgetForWorkspace(
        text: 'Button', 
        widget: ButtonWidget(
          inWorkspace: false,
          widgetText: 'Button',
          mqttManager: mqttManager,
        ), 
        form: ButtonWidgetForm(index: index, workspaceList: workspaceList, currentWorkspace: currentWorkspace,),
        index: index,

      ),
      const SizedBox(height: 12,),
      WidgetForWorkspace(
        text: 'Text', 
        widget: TextOfWorkspace(
          inWorkspace: false,
        ), 
        form: TextWidgetForm(index: index, workspaceList: workspaceList, currentWorkspace: currentWorkspace),
        index: index,
      ),
      // const SizedBox(height: 12,),
      // WidgetForWorkspace(
      //   text: 'Slider', 
      //   widget: SliderOfWorkspace(
      //     inWorkspace: false,
      //     min: '0',
      //     max: '20',
      //     mqttManager: mqttManager,
      //   ),
      //   form: SliderWidgetForm(
      //     index: index, 
      //     workspaceList: workspaceList,
      //     currentWorkspace: currentWorkspace,
      //   ),
      //   index: index,
      // ),
      const SizedBox(height: 12,),
      WidgetForWorkspace(
        text: 'Switch', 
        widget: SwitchOfWorkspace(
          inWorkspace: false,
          text: 'Text',
          currentWorkspace: currentWorkspace,
        ),
        form: SwitchWidgetForm(
          index: index,
          workspaceList: workspaceList,
          currentWorkspace: currentWorkspace,
        ),
        index: index,
      ),
      const SizedBox(height: 12,),
      WidgetForWorkspace(
        text: 'Gauge', 
        widget: CircularProgressBarOfWorkspace(
          inWorkspace: false,
          mqttManager: mqttManager,
        ),
        form: CircularProgressBarWidgetForm(
          index: index,
          workspaceList: workspaceList,
          currentWorkspace: currentWorkspace,
        ),
        index: index,
      ),
    ];

    return Expanded(
      child: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          for (final widget in widgets) 
            widget
        ],
      )
    );
  }
}

class WidgetForWorkspace extends StatelessWidget {
  final String text;
  final Widget widget;
  final Widget form;
  final String index;

  const WidgetForWorkspace({super.key, required this.text, required this.widget, required this.form, required this.index});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () { 
        Navigator.pushNamed(context, '/edit-widget', arguments: {'form': form, 'widget': widget, 'text': text, 'id': index});
      },
      child: Container(
        height: 80,
        decoration: BoxDecoration(
          color: const Color.fromRGBO(34, 12, 51, 1),
          borderRadius: BorderRadius.circular(14)
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              widget,
              Text(
                text,
                style: const TextStyle(
                  color: Color.fromRGBO(208, 188, 255, 1),
                  fontWeight: FontWeight.w500,
                  fontSize: 22
                )
              ),
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
      ),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(const Color.fromRGBO(34, 12, 51, 1))
      )
    );
  }
}