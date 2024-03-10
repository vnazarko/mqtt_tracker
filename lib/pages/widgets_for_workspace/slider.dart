import 'package:flutter/material.dart';
import 'package:mqtt_tracker/pages/widgets_for_workspace/widget.dart';

class SliderOfWorkspace extends ElemOfWorkspaceWithState {
  final double min;
  final double max;

  SliderOfWorkspace({super.key, super.inWorkspace, super.topic, required this.min, required this.max});

  @override
  State<SliderOfWorkspace> createState() => _SliderOfWorkspaceState();
}

class _SliderOfWorkspaceState extends State<SliderOfWorkspace> {
  double _valueOfSlider = 0;

  @override
  Widget build(BuildContext context) {
    void initState() {
      super.initState();
      _valueOfSlider = widget.min / widget.max;
    }
    
    return SizedBox(
      width: widget.inWorkspace! ? double.infinity : 156,
      child: SliderTheme(
        data: SliderTheme.of(context).copyWith(
          showValueIndicator: ShowValueIndicator.always,
          trackHeight: 12,
          activeTrackColor: const Color.fromRGBO(208, 188, 255, 1),
          inactiveTrackColor: const Color.fromRGBO(79, 55, 139, 1),
          thumbColor: const Color.fromRGBO(208, 188, 255, 1),
          thumbShape: const AppSliderShape(thumbRadius: 10),
        ),
        child: Slider(
          min: widget.min,
          max: widget.max,
          value: _valueOfSlider,
          label: '${_valueOfSlider.round()}',
          onChanged: (value) {
            setState(() {
              _valueOfSlider = value;
              print(_valueOfSlider);
            });
          },

        ),
      ),
    );
  }
}


class AppSliderShape extends SliderComponentShape {
    final double thumbRadius;

    const AppSliderShape({required this.thumbRadius});

    @override
    Size getPreferredSize(bool isEnabled, bool isDiscrete) {
        return Size.fromRadius(thumbRadius);
    }

    @override
    void paint(
      PaintingContext context,
      Offset center, {
      required Animation<double> activationAnimation,
      required Animation<double> enableAnimation,
      required bool isDiscrete,
      required TextPainter labelPainter,
      required RenderBox parentBox,
      required SliderThemeData sliderTheme,
      required TextDirection textDirection,
      required double value,
      required double textScaleFactor,
      required Size sizeWithOverflow,
  }) {
    final Canvas canvas = context.canvas;

    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = const Color.fromRGBO(208, 188, 255, 1);

    // draw icon with text painter
    const iconData = Icons.drag_handle;
    final TextPainter textPainter = TextPainter(textDirection: TextDirection.rtl);
    textPainter.text = TextSpan(
        text: String.fromCharCode(iconData.codePoint),
        style: TextStyle(
          fontSize: thumbRadius * 2,
          fontFamily: iconData.fontFamily,
          color: sliderTheme.thumbColor,
        ));
    textPainter.layout();

    const cornerRadius = 4.0;

    // draw the background shape here..
    canvas.drawRRect(
      RRect.fromRectXY(
          Rect.fromCenter(center: center, width: 4, height: 44), cornerRadius, cornerRadius),
      paint,
    );
  }
}
