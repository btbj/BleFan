import 'package:flutter/material.dart';

class AlertBox extends StatelessWidget {
  final String title;
  final String message;

  AlertBox({this.title = 'Alert', this.message});

  Widget _buildButtonGroup(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 15.0),
            child: FlatButton(
              child: Text('Confirm'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMessageBox() {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.all(15.0),
      child: Text(
        message,
        style: TextStyle(
          fontSize: 16,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text(title),
      children: <Widget>[
        _buildMessageBox(),
        _buildButtonGroup(context),
      ],
    );
  }
}

void popAlert({BuildContext context, String message, String title = 'Alert'}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) {
      return AlertBox(
        message: 'please check bluetooth state',
        title: title,
      );
    },
  );
}
