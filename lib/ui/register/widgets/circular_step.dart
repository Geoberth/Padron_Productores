import 'package:meta/meta.dart';
import 'package:flutter/material.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

class CircularStep extends StatelessWidget {
  final int currentStep;

  CircularStep({@required this.currentStep});

  @override
  Widget build(BuildContext context) {
    return SleekCircularSlider(
      appearance: CircularSliderAppearance(
        customColors: CustomSliderColors(
          dotColor: Colors.transparent
        ),
        customWidths: CustomSliderWidths(progressBarWidth: 4),
        size: 50.0,
        infoProperties: InfoProperties(
          bottomLabelText: "PASO",
          modifier: (double value) {
            return '${value.toInt()}';
          }
        ),
        startAngle: 180,
        angleRange: 360
      ),
      min: 0,
      max: 5,
      initialValue: _getStep(currentStep),
    );
  }

  double _getStep(currentStep) {
    switch(currentStep) {
      case 0:
        return 1.0;
      case 1:
        return 2.0;
      case 2:
        return 3.0;
      case 3:
        return 4.0;
      case 4:
        return 5.0;
      default:
        return 1.0;
    }
  }

}