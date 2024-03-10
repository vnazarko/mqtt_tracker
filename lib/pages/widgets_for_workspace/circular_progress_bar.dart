import 'package:flutter/material.dart';
import 'package:mqtt_tracker/pages/widgets_for_workspace/widget.dart';
import 'package:http/http.dart' as http;

class CircularProgressBarOfWorkspace extends ElemOfWorkspaceWithState {
  final String? additionalText;

  CircularProgressBarOfWorkspace({super.key, super.inWorkspace, super.topic, this.additionalText});

  @override
  State<CircularProgressBarOfWorkspace> createState() => _CircularProgressBarOfWorkspaceState();
}

class _CircularProgressBarOfWorkspaceState extends State<CircularProgressBarOfWorkspace> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  double progressValue = 0.0;

  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    
    _animation = Tween(begin: 0.0, end: progressValue).animate(_animationController)
      ..addListener(() {
        setState(() {
          progressValue = _animation.value;
        });
      });

    fetchData();
  }

  void fetchData() async {
    // var response = await http.get('YOUR_API_ENDPOINT');
    // var data = jsonDecode(response.body);
    // double progress = data['progress'];
    double progress = 0.1;
    
    _animationController.reset();
    _animation = Tween(begin: progressValue, end: progress).animate(_animationController);
    _animationController.forward();
  }
  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: 1.5,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 12),
            child: CircularProgressIndicator(
              value: progressValue,
              valueColor: const AlwaysStoppedAnimation(Color.fromRGBO(208, 188, 255, 1)),
              backgroundColor: const Color.fromRGBO(79, 55, 139, 1),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(left: 12),
              child: Text(
                widget.inWorkspace! ? '${widget.additionalText} 123' : '47°C',
                style: const TextStyle(
                  fontSize: 12,
                  color: Color.fromRGBO(208, 188, 255, 1)
                ),
              ),
            ) 
          )
        ],
      ),
    );
  }
}