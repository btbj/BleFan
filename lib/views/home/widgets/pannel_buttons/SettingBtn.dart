import 'package:flutter/material.dart';

class SettingBtn extends StatelessWidget {
  final bool small;
  SettingBtn({this.small});


  @override
  Widget build(BuildContext context) {
    return Container(
      height: small ? 30 : 45,
      width: small ? 30 : 45,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        color: Colors.grey[400],
      ),
      child: FlatButton(
        padding: EdgeInsets.all(0),
        child: Icon(
          Icons.settings,
          size: small ? 18 : 24,
        ),
        onPressed: () {
          print('setting');
        },
      ),
    );
  }
}
