import 'package:flutter/material.dart';

class ErrorSnackbar extends SnackBar {
  @override
  Widget build(BuildContext context) {
    return SnackBar(
      content: Row(
        children: <Widget>[
          Icon(Icons.error),
          SizedBox(width: 10),
          Text("An error occured, please try again later.")
        ],
      ),
      duration: Duration(
        milliseconds: 1000,
      ),
      
    );
  }
}