import 'package:flutter/material.dart';
import '../../components/RenameBox.dart';

class SettingBtn extends StatefulWidget {
  final bool small;
  SettingBtn({this.small});

  @override
  _SettingBtnState createState() => _SettingBtnState();
}

class _SettingBtnState extends State<SettingBtn> {
  Future popDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (_) {
        return RenameBox();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.small ? 30 : 45,
      width: widget.small ? 30 : 45,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        color: Colors.grey[400],
      ),
      child: FlatButton(
        padding: EdgeInsets.all(0),
        child: Icon(
          Icons.settings,
          size: widget.small ? 18 : 24,
        ),
        onPressed: () {
          popDialog(context).then((_) {});
        },
      ),
    );
  }
}
