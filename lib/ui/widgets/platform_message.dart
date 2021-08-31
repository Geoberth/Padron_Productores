import 'dart:io';
import 'package:meta/meta.dart';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class PlatformMessage extends StatelessWidget {

  final String title;
  final String content;
  final TextStyle contentStyle;
  final Function okPressed;
  final String okLabel;
  final Function cancelPressed;
  final String cancelLabel;

  PlatformMessage({
    @required this.title, 
    @required this.content, 
    @required this.okPressed, 
    this.okLabel = "De acuerdo",
    this.cancelLabel = "Cancelar",
    this.cancelPressed,
    this.contentStyle = const TextStyle(fontSize: 12.0)
  });

  @override
  Widget build(BuildContext context) {
    return Platform.isAndroid ? _buildAndroid(context) : _buildIos(context);
  }

  Widget _buildAndroid(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content, style: contentStyle),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6.0)
      ),
      actions: <Widget>[
        (cancelPressed != null) ?
        FlatButton(
          onPressed: cancelPressed,
          child: Text(cancelLabel),
        ) : Container(),
        FlatButton(
          onPressed: okPressed,
          child: Text(okLabel, style: TextStyle(fontWeight: FontWeight.bold)),
        )
      ],
    );
  }

  Widget _buildIos(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(title),
      content: Text(content, style: contentStyle),
      actions: <Widget>[
        (cancelPressed != null) ?
        CupertinoDialogAction(
          onPressed: cancelPressed,
          child: Text(cancelLabel)
        ) : Container(),
        CupertinoDialogAction(
          isDefaultAction: true,
          onPressed: okPressed,
          child: Text(okLabel),
        )
      ],
    );
  }

}