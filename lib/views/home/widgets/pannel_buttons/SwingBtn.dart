import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

// import '../../../../scoped-models/fan_state.dart';
import '../../../../scoped-models/main_model.dart';

class SwingBtn extends StatelessWidget {
  final bool small;

  SwingBtn({this.small = false});

  @override
  Widget build(BuildContext context) {

    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        final String _imagePath = model.fanstate.swing && model.fanstate.power
            ? 'assets/images/icons/swing_on.png'
            : 'assets/images/icons/swing_off.png';
        return Expanded(
          child: Container(
            height: small ? 60 : 85,
            decoration:
                BoxDecoration(border: Border.all(color: Colors.grey[400])),
            child: FlatButton(
              child: Image.asset(
                _imagePath,
                height: small ? 35 : 50,
              ),
              onPressed: () async {
                if (model.connected) {
                  model.fanstate.toggleSwing();
                  model.sendNewState();
                }
              },
            ),
          ),
        );
      },
    );
  }
}
