import 'dart:io';
import 'package:flutter/material.dart';

class QuitBtn extends StatelessWidget {
  final bool small;
  QuitBtn({this.small});

  void showAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => new AlertDialog(
            title: new Text("Info"),
            content: new Text("Confirm to exit?"),
            actions: <Widget>[
              new FlatButton(
                child: new Text("CANCEL"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              new FlatButton(
                child: new Text("EXIT"),
                textColor: Colors.red,
                onPressed: () {
                  Navigator.of(context).pop();
                  exit(0);
                },
              )
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: small ? 40 : 55,
        child: FlatButton(
          child: Image.asset(
            'assets/images/icons/quit.png',
            width: small ? 35 : 45,
          ),
          onPressed: () {
            showAlertDialog(context);
          },
        ),
      ),
    );
  }
}
