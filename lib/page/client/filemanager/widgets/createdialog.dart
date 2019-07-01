import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';

class CreateDialog extends StatelessWidget {
  final TextEditingController controller;
  final String title;
  final Function onSubmitted;

  const CreateDialog({
    @required this.controller,
    @required this.title,
    @required this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? new CupertinoAlertDialog(
            title: Text(title),
            content: Container(
              child: TextField(
                controller: controller,
                autofocus: true,
                maxLines: 1,
                autocorrect: false,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done,
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text("Create"),
                onPressed: () {
                  Navigator.of(context).pop();
                  onSubmitted();
                },
              )
            ],
          )
        : new AlertDialog(
            title: Text(title),
            content: Container(
              child: TextField(
                controller: controller,
                autofocus: true,
                maxLines: 1,
                autocorrect: false,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done,
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text("Create"),
                onPressed: () {
                  Navigator.of(context).pop();
                  onSubmitted();
                },
              )
            ],
          );
  }
}
