import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

// import '../../../../scoped-models/fan_state.dart';
import '../../../../scoped-models/main_model.dart';

class FanLevelBtn extends StatelessWidget {
  final int level;
  final bool small;

  FanLevelBtn({this.level, this.small});

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        final String _imagePath =
            model.fanstate.level == level && model.fanstate.power
                ? 'assets/images/icons/fan${level}_on.png'
                : 'assets/images/icons/fan${level}_off.png';
        return Expanded(
          child: Container(
            height: small ? 60 : 85,
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(width: 1.0, color: Colors.grey[400]),
                bottom: BorderSide(width: 1.0, color: Colors.grey[400]),
                left: level != 2
                    ? BorderSide(width: 1.0, color: Colors.grey[400])
                    : BorderSide.none,
                right: level != 2
                    ? BorderSide(width: 1.0, color: Colors.grey[400])
                    : BorderSide.none,
              ),
            ),
            child: FlatButton(
              child: Image.asset(
                _imagePath,
                height: small ? 20 : 30,
              ),
              onPressed: () async {
                if (model.connectedDevice != null) {
                  model.fanstate.setLevel(level);
                  final List<int> code = model.getSetCode();
                  await model.sendCode(code);
                }
              },
            ),
          ),
        );
      },
    );
  }
}
