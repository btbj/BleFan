import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../../../../scoped-models/main_model.dart';

class WaterBtn extends StatefulWidget {
  final bool small;
  WaterBtn({this.small});

  @override
  _WaterBtnState createState() => _WaterBtnState();
}

class _WaterBtnState extends State<WaterBtn> {
  Widget _buildWaterIconImage() {
    return ScopedModelDescendant(
      builder: (BuildContext context, Widget child, MainModel model) {
        return Image.asset(
          model.fanstate.hasWater
              ? 'assets/images/icons/temp_on.png'
              : 'assets/images/icons/temp_off.png',
          height: widget.small ? 25 : 30,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: widget.small ? 40 : 55,
        child: FlatButton(
          child: _buildWaterIconImage(),
          onPressed: () {},
        ),
      ),
    );
  }
}
