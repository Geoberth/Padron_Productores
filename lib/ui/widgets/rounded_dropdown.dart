import 'package:meta/meta.dart';
import 'package:flutter/material.dart';

class RoundedDropdown extends StatelessWidget {

  final String labelText;
  final Widget child;
  final EdgeInsetsGeometry margin;

  RoundedDropdown({ @required this.labelText, @required this.child, this.margin = const EdgeInsets.symmetric(vertical: 15.0) });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: margin,
      width: size.width,
      child: InputDecorator(
        decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: labelText,
            contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
        ),
        child: child
      )
    );
  }
}