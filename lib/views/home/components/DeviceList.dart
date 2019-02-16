import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_blue/flutter_blue.dart';

import '../../../scoped-models/main_model.dart';
import '../../../utils/StoreHelper.dart';

class DeviceList extends StatefulWidget {
  @override
  _DeviceListState createState() => _DeviceListState();
}

class _DeviceListState extends State<DeviceList> {
  MainModel _model;
  final DeviceStore sharedStore = DeviceStore();

  @override
  void initState() {
    print('initstate devicelist');
    super.initState();
    _model = ScopedModel.of<MainModel>(context);
    disconnectDevice();
    _model.bleStartScan();
  }

  void disconnectDevice() {
    if (_model.connectedDevice != null) {
      _model.bleDisconnectDevice();
      _model.resetFanstate();
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
        Navigator.pop(context);
      }
    });
  }

  void checkDeviceCurrentState() {
    final List<int> code = _model.getCheckCode();
    _model.sendCode(code);
  }

  Widget _buildTitleRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text('Device List'),
        SizedBox(
          height: 30,
          width: 30,
          child: IconButton(
            padding: EdgeInsets.all(0.0),
            icon: Icon(
              _model.scanning ? Icons.cancel : Icons.refresh,
              size: 24,
            ),
            onPressed: () {
              print('refresh');
              if (_model.scanning) {
                _model.bleStopScan();
              } else {
                _model.bleStartScan();
              }
            },
          ),
        )
      ],
    );
  }

  List<Widget> _buildDeviceListTiles() {
    List<Widget> _listTailArray = [];
    for (ScanResult scanResult in _model.scanResultList) {
      final String _deviceName = scanResult.device.name != ''
          ? scanResult.device.name
          : 'unknow device';
      final int rssi = scanResult.rssi;
      Widget item = ListTile(
        leading: Icon(Icons.devices),
        title: Text(_deviceName),
        trailing: Text(rssi.toString()),
        onTap: () {
          connectDevice(scanResult);
        },
      );
      _listTailArray.add(item);
    }
    if (_model.scanning) {
      Widget loadingListTail = Container(
        margin: EdgeInsets.symmetric(vertical: 5.0),
        child: Center(
          child: SizedBox(
            height: 15.0,
            width: 15.0,
            child: CircularProgressIndicator(),
          ),
        ),
      );
      _listTailArray.add(loadingListTail);
    }
    return _listTailArray;
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return SimpleDialog(
          title: _buildTitleRow(),
          children: _buildDeviceListTiles(),
        );
      },
    );
  }

  @override
  void dispose() {
    print('dispose');
    _model.bleStopScan();
    super.dispose();
  }
}
