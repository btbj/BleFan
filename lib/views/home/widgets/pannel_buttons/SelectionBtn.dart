import 'dart:async';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../components/DeviceList.dart';
import '../../../../scoped-models/main_model.dart';

class SelectionBtn extends StatefulWidget {
  final bool small;
  SelectionBtn({this.small});

  @override
  _SelectionBtnState createState() => _SelectionBtnState();
}

class _SelectionBtnState extends State<SelectionBtn> {
  Timer _stopScanTimer;
  MainModel _model;

  @override
  void initState() {
    print('init state');
    super.initState();
    _model = ScopedModel.of<MainModel>(context);
    _model.bleQuickScan();
    _stopScanTimer = Timer(Duration(seconds: 3), checkQuickScanResult);
  }

  Widget _buildDeviceName(MainModel model) {
    String _deviceState = model.deviceState;
    if (model.connectedDevice != null) {
      _deviceState = model.connectedDevice.name == ''
          ? 'No Name'
          : model.connectedDevice.name;
    }
    return Text(_deviceState);
  }

  Future popDialog(BuildContext context) {
    _stopScanTimer.cancel();
    return showDialog(
      context: context,
      builder: (_) {
        return DeviceList();
      },
    );
  }

  void checkQuickScanResult() {
    _model.bleStartScan();
    popDialog(context).then((_) {
      print('out');
      _model.bleStopScan();
    });
  }

  Widget _buildFlatBtn() {
    return ScopedModelDescendant(
      builder: (BuildContext context, Widget child, MainModel model) {
        return FlatButton(
          padding: EdgeInsets.symmetric(vertical: 0, horizontal: 25.0),
          child: _buildDeviceName(model),
          onPressed: () {
            model.bleStartScan();
            popDialog(context).then((_) {
              print('out');
              model.bleStopScan();
            });
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.small ? 30 : 45,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        color: Colors.grey[400],
      ),
      child: _buildFlatBtn(),
    );
  }
}
