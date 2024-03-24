# mqtt_tracker

**This documentation is intended for those who want to add their own widgets. If you're not planning to modify my project yet, you can simply download the APK and leave :).**

Creating a widget:

1. Create a file (preferably in `lib/pages/widgets_for_workspace`).
2. Create a class with the widget's name and inherit from `ElemOfWorkspace` or `ElemOfWorkspaceWithState` depending on whether you need to modify the widget's state.

    ```dart
    import 'package:mqtt_tracker/pages/widgets_for_workspace/widget.dart';
    
    class ButtonWidget extends ElemOfWorkspace {
    ```
    
3. To make our widget look nice in the selection list, we need to set the `inWorkspace` property to `false` in the `ListOfWidgets` class in the `workspace_page.dart` file.
4. To communicate with MQTT, we need to create an instance of the `MqttManager` class. Once the instance is created, you can connect to the server using the `connect()` method. The `clientId` field must be unique, so you can use the widget's name, which is entered in the field during creation, and the ordinal number.

    ```dart
    final mqttManager = MqttManager(
      server: currentWorkspace['Server'],
      username: currentWorkspace['User'], 
      password: currentWorkspace['Password'], 
      port: int.parse(currentWorkspace['Port']),
      clientId: 'button/$text/${currentWorkspace['Widgets'].length}',
    );
    if (inWorkspace != false) mqttManager.connect(); // To prevent the widget from connecting when it shouldn't
    ```
    
5. Next, you write the widget you need.
6. If you need to read a value from a topic, you need to create a data stream that requests data from the MQTT topic.

    ```dart
    Stream<String> mqttDataStream() async* {
      while (true) {
        await Future.delayed(const Duration(milliseconds: 100));
        yield mqttManager.getReceivedText(); // Get and send new value to the stream
      }
    }
    StreamBuilder<String>(
      stream: mqttDataStream(), // Specify the data stream
      builder: (context, snapshot) => Text(
        !inWorkspace! ? 'Received Text' : snapshot.data != null ? snapshot.data! : 'null' // Show the value from the topic
      )
    )
    ```
    
7. If you need to write a value to a topic, use the `publishMessage(topic, value)` method.

    ```dart
    mqttManager.publishMessage(topic!, '1');
    ```

We have created the widget, now we need to create a form for displaying it on the page.

1. In the same file where you created the widget, create a class for the form.
2. Create the necessary fields using the `WorkspaceTextField` class.

    ```dart
    class WorkspaceTextField extends StatelessWidget {
      final String? hintText; 
      final String? labelText;
      final TextEditingController controller;
    
      const WorkspaceTextField({
        Key? key,
        required String this.hintText,
        required String this.labelText, 
        required this.controller,
      }) : super(key: key);
    
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
    ```
    
3. Now you need to create a `SaveButton` class to save the widget to the common list using the `workspaceList.addWidget(widgetInfo, index)` method, where `workspaceList` is the common list of widgets passed, `widgetInfo` is a Map collection that takes values from the text fields created earlier, and `index` is the index.

Now we need to add the widget to the `widgets` list of the `ListOfWidgets` class in the `workspace_page.dart` file, using the `WidgetForWorkspace` widget as a wrapper.

Then, to display it in the workspace, add the widget to the `Workspace` class in the `workspace_page.dart` file, like this:

```dart
if (widget['Type'] == 'Button') ButtonWidget(widgetText: widget['Name'], topic: widget['Topic'], currentWorkspace: currentWorkspace, inWorkspace: true,),
// Set the type value according to your needs
```