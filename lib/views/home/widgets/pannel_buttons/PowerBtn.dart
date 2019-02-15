import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

// import '../../../../scoped-models/fan_state.dart';
import '../../../../scoped-models/main_model.dart';

class PowerBtn extends StatelessWidget {
  final bool small;

  PowerBtn({this.small = false});

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        final String _imagePath = model.state.power
            ? 'assets/images/icons/power_on.png'
            : 'assets/images/icons/power_off.png';
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
              onPressed: model.togglePower,
            ),
          ),
        );
      },
    );
  }
}
