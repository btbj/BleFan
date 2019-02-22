import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

// import '../../../../scoped-models/fan_state.dart';
import '../../../../scoped-models/main_model.dart';

class OffTimerBtn extends StatelessWidget {
  final int hours;
  final bool small;

  OffTimerBtn({this.hours, this.small});

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        final String unit = hours > 1 ? 'hrs.' : 'hr.';

        final Border dynamicBorder = Border(
          top: [1, 2, 3, 4].indexOf(hours) > -1
              ? BorderSide(width: 1, color: Colors.grey[400])
              : BorderSide.none,
          left: [1, 5].indexOf(hours) > -1
              ? BorderSide(width: 1, color: Colors.grey[400])
              : BorderSide.none,
          right: hours < 8
              ? BorderSide(width: 1, color: Colors.grey[400])
              : BorderSide.none,
          bottom: hours < 8
              ? BorderSide(width: 1, color: Colors.grey[400])
              : BorderSide.none,
        );

        return Expanded(
          child: Container(
            height: small ? 40 : 55,
            decoration: BoxDecoration(border: dynamicBorder),
            child: hours < 8
                ? FlatButton(
                    child: Text(
                      '$hours$unit',
                      style: TextStyle(
                          color: model.fanstate.offTimer == hours && model.fanstate.power
                              ? Color.fromARGB(255, 52, 152, 219)
                              : Colors.grey),
                    ),
                    onPressed: () async {
                      if (model.connected) {
                        model.fanstate.setOffTimer(hours);
                        model.sendNewState();
                      }
                    },
                  )
                : Container(),
          ),
        );
      },
    );
  }
}
