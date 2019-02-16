import 'dart:async';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_blue/flutter_blue.dart';

import '../../components/DeviceList.dart';
import '../../../../scoped-models/main_model.dart';
import '../../../../utils/StoreHelper.dart';

class SelectionBtn extends StatefulWidget {
  final bool small;
  SelectionBtn({this.small});

  @override
  _SelectionBtnState createState() => _SelectionBtnState();
}

class _SelectionBtnState extends State<SelectionBtn> {
  Timer _stopScanAndPopDialogTimer;
  MainModel _model;
  final DeviceStore sharedStore = DeviceStore();

  @override
  void initState() {
    print('init state');
    super.initState();
    _model = ScopedModel.of<MainModel>(context);
    _model.bleStartScan();
    _stopScanAndPopDialogTimer =
        Timer(Duration(seconds: 3), checkQuickScanResult);
  }

  Widget _buildDeviceName() {
    String _deviceState = 'No Device';
    if (_model.scanning) _deviceState = 'Scanning';
    if (_model.connectedDevice != null) {
      _deviceState = _model.connectedDevice.name == ''
          ? 'No Name'
          : _model.connectedDevice.name;
    }
    return Text(_deviceState);
  }

  Future popDialog(BuildContext context) {
    _stopScanAndPopDialogTimer.cancel();
    return showDialog(
      context: context,
      builder: (_) {
        return DeviceList();
      },
    );
  }

  void checkQuickScanResult() async {
    print('check scan result');
    _model.bleStopScan();
    final Map<String, dynamic> storedDevices =
        await sharedStore.getSavedDevices();
    print(storedDevices);
    List<ScanResult> matchedList = [];
    for (ScanResult scanResult in _model.scanResultList) {
      final String id = scanResult.device.id.toString();

      if (storedDevices.containsKey(id)) {
        matchedList.add(scanResult);
      }
    }
    if (matchedList.length == 1) {
      print('match one');
      connectDevice(matchedList[0]);
    } else if (matchedList.length > 1) {
      popDialog(context).then((_) {});
    }
  }

  void connectDevice(ScanResult scanResult) async {
    print('connect device: ${scanResult.device.name}');
    // model.bleConnectDevice(scanResult);
    _model.bleConnectDevice(scanResult).onData((s) async {
      if (s == BluetoothDeviceState.connected) {
        print('connected');
        _model.connectedDevice = scanResult.device;
        await _model.bleScanServices();
        _model.setNotificationCallback(_model.setNewState);
        checkDeviceCurrentState();
        await sharedStore.saveDevice(_model.connectedDevice.id.toString());
      }
    });
  }

  void checkDeviceCurrentState() {
    final List<int> code = _model.getCheckCode();
    _model.sendCode(code);
  }

  Widget _buildFlatBtn() {
    return ScopedModelDescendant(
      builder: (BuildContext context, Widget child, MainModel model) {
        return FlatButton(
          padding: EdgeInsets.symmetric(vertical: 0, horizontal: 25.0),
          child: _buildDeviceName(),
          onPressed: () {
            popDialog(context).then((_) {});
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
