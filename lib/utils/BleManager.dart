import 'dart:async';
import 'package:flutter_blue/flutter_blue.dart';

class BleManager {
  // 单例模式
  factory BleManager() => _getInstance();
  static BleManager get instance => _getInstance();
  static BleManager _instance;
  BleManager._internal() {
    // 初始化
  }
  static BleManager _getInstance() {
    if (_instance == null) {
      _instance = new BleManager._internal();
    }
    return _instance;
  }

  // 参数
  final String targetUUIDString = '0000ffe1-0000-1000-8000-00805f9b34fb';
  BluetoothDevice connectedDevice;
  BluetoothCharacteristic targetChar;
  String deviceName = '';

  StreamSubscription<ScanResult> _scanSubscription;
  StreamSubscription<BluetoothDeviceState> _deviceConnection;
  StreamSubscription<List<int>> _notificationListener;

  StreamSubscription<ScanResult> startScan() {
    print('start ble scan');

    _scanSubscription = FlutterBlue.instance.scan().listen((ScanResult sr) {});
    return _scanSubscription;
  }

  Future stopScan() async {
    if (_scanSubscription == null) return;

    print('stop ble scan');
    await _scanSubscription.cancel();
    return;
  }

  StreamSubscription<BluetoothDeviceState> connectDevice(
      ScanResult targetResult) {
    this.stopScan();

    _deviceConnection =
        FlutterBlue.instance.connect(targetResult.device).listen((_) {});

    return _deviceConnection;
  }

  Future disconnectDevice() async {
    if (_deviceConnection == null) {
      return;
    }
    this.connectedDevice = null;
    this.deviceName = '';
    await _deviceConnection.cancel();
    return;
  }

  Future scanServices() async {
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
          await this.toggleNotification();
        }
      }
    }
    return;
  }

  Future toggleNotification() async {
    await this.connectedDevice.setNotifyValue(this.targetChar, true);
    return;
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
