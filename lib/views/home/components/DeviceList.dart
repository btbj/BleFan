import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_blue/flutter_blue.dart';

import '../../../scoped-models/main_model.dart';
import '../../../utils/StoreHelper.dart';
import '../../../utils/BleManager.dart';

class DeviceList extends StatefulWidget {
  @override
  _DeviceListState createState() => _DeviceListState();
}

class _DeviceListState extends State<DeviceList> {
  MainModel _model;
  final BleManager bleManager = BleManager();
  final DeviceStore sharedStore = DeviceStore();
  Map<String, dynamic> storedDevice;

  final List<ScanResult> _scanResultList = [];
  bool _isScanning = false;

  @override
  void initState() {
    print('initstate devicelist');
    super.initState();
    _model = ScopedModel.of<MainModel>(context);
    disconnectDevice();
    startScan();
  }

  void stopScan() async {
    await bleManager.stopScan();
    setState(() {
      _isScanning = false;
    });
  }

  void startScan() async {
    setState(() {
      _isScanning = true;
    });
    storedDevice = await sharedStore.getSavedDevices();
    bleManager.startScan().onData((ScanResult scanResult) {
      final int index = _scanResultList
          .indexWhere((item) => item.device.id == scanResult.device.id);
      if (index == -1) {
        _scanResultList.add(scanResult);
      } else {
        _scanResultList[index] = scanResult;
      }
      setState(() {});
    });
  }

  void disconnectDevice() {
    print('disconnect device');
    if (bleManager.connectedDevice != null) {
      bleManager.disconnectDevice();
      _model.resetFanstate();
    }
  }

  void connectDevice(ScanResult scanResult) async {
    print('connect device: ${scanResult.device.name}');
    bleManager.connectDevice(scanResult).onData((s) async {
      if (s == BluetoothDeviceState.connected) {
        print('connected');
        bleManager.connectedDevice = scanResult.device;
        await bleManager.scanServices();
        bleManager.setNotificationCallback(_model.setNewState);
        checkDeviceCurrentState();
        bleManager.deviceName = getDeviceName(scanResult.device);
        await sharedStore.saveDevice(bleManager.connectedDevice);
        Navigator.pop(context);
      }
    });
  }

  void checkDeviceCurrentState() {
    final List<int> code = _model.getCheckCode();
    bleManager.sendCode(code);
  }

  void _refreshScanResultList() {
    print('refresh');

    if (_isScanning) {
      stopScan();
    } else {
      setState(() {
        _scanResultList.clear();
      });
      startScan();
    }
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
              _isScanning ? Icons.cancel : Icons.refresh,
              size: 24,
            ),
            onPressed: _refreshScanResultList,
          ),
        )
      ],
    );
  }

  String getDeviceName(BluetoothDevice device) {
    String result = 'unknow device';
    if (device.name != '') {
      result = device.name;
    }
    if (storedDevice.containsKey(device.id.toString())) {
      // print('stored');
      result = storedDevice[device.id.toString()]['name'];
    }
    return result;
  }

  List<Widget> _buildDeviceListTiles() {
    List<Widget> _listTailArray = [];
    for (ScanResult scanResult in _scanResultList) {
      final String _deviceName = getDeviceName(scanResult.device);
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
    if (_isScanning) {
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
    return SimpleDialog(
      title: _buildTitleRow(),
      children: _buildDeviceListTiles(),
    );
  }

  @override
  void dispose() {
    print('dispose');
    _isScanning = false;
    bleManager.stopScan();
    super.dispose();
  }
}
