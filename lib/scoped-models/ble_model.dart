import 'dart:async';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_blue/flutter_blue.dart';

// import '../utils/BleCode.dart';
// import '../models/FanState.dart';

mixin BleModel on Model {
  final String targetUUIDString = '0000ffe1-0000-1000-8000-00805f9b34fb';
  final FlutterBlue _flutterBlue = FlutterBlue.instance;
  BluetoothDevice connectedDevice;
  BluetoothCharacteristic targetChar;

  bool _scanning = false;
  bool get scanning => this._scanning;
  StreamSubscription<ScanResult> _scanSubscription;
  StreamSubscription<ScanResult> get scanSubscription => this._scanSubscription;
  final List<ScanResult> _scanResultList = [];
  List<ScanResult> get scanResultList => this._scanResultList;

  StreamSubscription<BluetoothDeviceState> _deviceConnection;
  StreamSubscription<BluetoothDeviceState> get deviceConnection =>
      this._deviceConnection;
  StreamSubscription<List<int>> _notificationListener;

  void bleStartScan() {
    print('start ble scan');
    _scanning = true;
    _scanResultList.clear();
    notifyListeners();

    _scanSubscription = _flutterBlue.scan().listen((ScanResult sr) {
      final int index =
          _scanResultList.indexWhere((item) => item.device.id == sr.device.id);
      if (index == -1) {
        _scanResultList.add(sr);
      } else {
        _scanResultList[index] = sr;
      }
      print(this._scanResultList);
      notifyListeners();
    });
  }

  void bleStopScan() {
    if (_scanSubscription == null) return;

    print('stop ble scan');
    _scanSubscription.cancel();
    _scanning = false;
    notifyListeners();
  }

  StreamSubscription<BluetoothDeviceState> bleConnectDevice(
      ScanResult targetResult) {
    this.bleStopScan();
    final Stream<BluetoothDeviceState> stream =
        _flutterBlue.connect(targetResult.device);

    _deviceConnection = stream.listen((s) async* {
      yield s;
    });

    return _deviceConnection;
  }

  Future bleDisconnectDevice() async {
    if (_deviceConnection == null) {
      return;
    }
    this.connectedDevice = null;
    await _deviceConnection.cancel();
    notifyListeners();
    return;
  }

  Future bleScanServices() async {
    if (this.connectedDevice == null) return;
    List<BluetoothService> services =
        await this.connectedDevice.discoverServices();

    for (BluetoothService service in services) {
      print('service uuid: ${service.uuid}');
      List<BluetoothCharacteristic> chars = service.characteristics;
      for (BluetoothCharacteristic char in chars) {
        print('char uuid: ${char.uuid}');
        if (char.uuid.toString() == this.targetUUIDString) {
          this.targetChar = char;
          this.toggleNotification();
        }
      }
    }
    notifyListeners();
    return;
  }

  void toggleNotification() async {
    await this.connectedDevice.setNotifyValue(this.targetChar, true);
    // this.connectedDevice.onValueChanged(this.targetChar).listen((value) {
    //   print('value changed! $value');
    //   this._fanstate = this._adapter.analyseCode(value);
    //   notifyListeners();
    // });
  }

  void setNotificationCallback(Function callback) {
    if (_notificationListener != null) {
      _notificationListener.cancel();
    }
    _notificationListener = this.connectedDevice.onValueChanged(this.targetChar).listen((value) {
      callback(value);
    });
  }

  Future sendCode(List<int> code) async {
    if (this.targetChar == null) return;

    await this.connectedDevice.writeCharacteristic(this.targetChar, code);
    return;
  }
}
