import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

// import '../../../../scoped-models/fan_state.dart';
import '../../../../scoped-models/main_model.dart';

class CoolBtn extends StatelessWidget {
  final bool small;

  CoolBtn({this.small = false});

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        final String _imagePath = model.fanstate.cool && model.fanstate.power
            ? 'assets/images/icons/cool_on.png'
            : 'assets/images/icons/cool_off.png';
        return Expanded(
          child: Container(
            height: small ? 60 : 85,
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(width: 1.0, color: Colors.grey[400]),
                bottom: BorderSide(width: 1.0, color: Colors.grey[400]),
              ),
            ),
            child: FlatButton(
              child: Image.asset(
                _imagePath,
                height: small ? 35 : 50,
              ),
              onPressed: () {
                if (model.connected) {
                  model.fanstate.toggleCool();
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
