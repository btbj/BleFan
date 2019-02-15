import 'package:flutter/material.dart';
import '../widgets/pannel_buttons/SettingBtn.dart';
import '../widgets/pannel_buttons/SelectionBtn.dart';
import '../widgets/pannel_buttons/PowerBtn.dart';
import '../widgets/pannel_buttons/CoolBtn.dart';
import '../widgets/pannel_buttons/SwingBtn.dart';
import '../widgets/pannel_buttons/FanLevelBtn.dart';
import '../widgets/pannel_buttons/OffTimerBtn.dart';
import '../../../utils/DeviceSize.dart';

class ControlPanel extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ControlPanelState();
  }
}

class _ControlPanelState extends State<ControlPanel> {

  Widget _buildHeadRow() {
    final DeviceSize dSize = DeviceSize(context);
    return Container(
      margin: EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          SelectionBtn(small: dSize.isSmall()),
          SizedBox(width: 8.0),
          SettingBtn(small: dSize.isSmall()),
        ],
      ),
    );
  }

  Widget _buildLabelRow(String label) {
    final DeviceSize dSize = DeviceSize(context);
    final bool isSmall = dSize.isSmall();
    return Container(
      height: isSmall ? 30 : 50,
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(width: 1.0, color: Colors.grey[400]),
          right: BorderSide(width: 1.0, color: Colors.grey[400]),
        ),
        color: Colors.grey[300],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(label, style: TextStyle(fontSize: isSmall ? 10 : 14),),
        ],
      ),
    );
  }

  Widget _buildPowerRow() {
    final DeviceSize dSize = DeviceSize(context);
    final bool isSmall = dSize.isSmall();
    return Row(
      children: [
        PowerBtn(small: isSmall),
        CoolBtn(small: isSmall),
        SwingBtn(small: isSmall),
      ],
    );
  }

  Widget _buildFanLevelRow() {
    final DeviceSize dSize = DeviceSize(context);
    final bool isSmall = dSize.isSmall();
    return Row(
      children: [
        FanLevelBtn(level: 3, small: isSmall),
        FanLevelBtn(level: 2, small: isSmall),
        FanLevelBtn(level: 1, small: isSmall),
      ],
    );
  }

  Widget _buildOffTimerBox() {
    final DeviceSize dSize = DeviceSize(context);
    final bool isSmall = dSize.isSmall();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Row(
          children: [
            OffTimerBtn(hours: 1, small: isSmall),
            OffTimerBtn(hours: 2, small: isSmall),
            OffTimerBtn(hours: 3, small: isSmall),
            OffTimerBtn(hours: 4, small: isSmall),
          ],
        ),
        Row(
          children: [
            OffTimerBtn(hours: 5, small: isSmall),
            OffTimerBtn(hours: 6, small: isSmall),
            OffTimerBtn(hours: 7, small: isSmall),
            OffTimerBtn(hours: 8, small: isSmall),
          ],
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: <Widget>[
          _buildHeadRow(),
          _buildPowerRow(),
          _buildLabelRow('FAN'),
          _buildFanLevelRow(),
          _buildLabelRow('OFF TIMER'),
          _buildOffTimerBox(),
        ],
      ),
    );
  }
}
