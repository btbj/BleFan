import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_blue/flutter_blue.dart';

import '../../../scoped-models/main_model.dart';

class DeviceList extends StatelessWidget {
  Widget _buildTitleRow(MainModel model) {
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
              model.scanning ? Icons.cancel : Icons.refresh,
              size: 24,
            ),
            onPressed: () {
              print('refresh');
              if (model.scanning) {
                model.bleStopScan();
              } else {
                model.bleStartScan();
              }
            },
          ),
        )
      ],
    );
  }

  List<Widget> _buildDeviceListTiles(MainModel model, BuildContext context) {
    List<Widget> _listTailArray = [];
    for (ScanResult scanResult in model.bleScanResult) {
      final String _deviceName = scanResult.device.name != ''
          ? scanResult.device.name
          : 'unknow device';
      final int rssi = scanResult.rssi;
      Widget item = ListTile(
        leading: Icon(Icons.devices),
        title: Text(_deviceName),
        trailing: Text(rssi.toString()),
        onTap: () async {
          print('connect device: ${scanResult.device.name}');
          // model.bleConnectDevice(scanResult);
          model.bleConnectDevice(scanResult).onData((s) async {
            if (s == BluetoothDeviceState.connected) {
              print('connected');
              model.connectedDevice = scanResult.device;
              await model.bleScanServices();
              Navigator.pop(context);
            }
          });
        },
      );
      _listTailArray.add(item);
    }
    if (model.scanning) {
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
          title: _buildTitleRow(model),
          children: _buildDeviceListTiles(model, context),
        );
      },
    );
  }
}
