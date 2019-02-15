import 'dart:async';
import 'package:flutter_blue/flutter_blue.dart';

class BleManager {
  final String targetUUIDString = '0000ffe1-0000-1000-8000-00805f9b34fb';
  final FlutterBlue _flutterBlue = FlutterBlue.instance;
  final List<ScanResult> _scanResult = [];
  BleState _bleState = BleState();
  BluetoothCharacteristic targetChar;

  StreamSubscription<ScanResult> _scanSubscription;
  StreamSubscription<BluetoothDeviceState> _deviceConnection;

  BluetoothDevice connectedDevice;

  String get deviceState => this._bleState.deviceState;
  bool get scanning => this._bleState.scanning;

  List<ScanResult> get bleScanResult => this._scanResult;

  void bleStartScan() {
    this._bleState.scanning = true;
    print('start ble scan');
    _scanResult.clear();
    // notifyListeners();

    _scanSubscription = _flutterBlue.scan().listen((ScanResult scanResult) {
      final int index = _scanResult
          .indexWhere((item) => item.device.id == scanResult.device.id);
      if (index == -1) {
          _scanResult.add(scanResult);
      } else {
          _scanResult[index] = scanResult;
      }
      // notifyListeners();
    });
  }

  void bleStopScan() {
    this._bleState.scanning = false;
    if (_scanSubscription == null) {
      return;
    }
    print('stop ble scan');
    _scanSubscription.cancel();
    // notifyListeners();
  }

  Stream<BluetoothDeviceState> bleConnectDevice(ScanResult targetResult) {
    this.bleStopScan();
    final Stream<BluetoothDeviceState> stream = _flutterBlue.connect(targetResult.device).asBroadcastStream();

    _deviceConnection = stream.listen((s) async {
      this._bleState.updateDeviceState(s);
      // notifyListeners();
      if (s == BluetoothDeviceState.connected) {
        print('connected');
        this.connectedDevice = targetResult.device;
        await this.bleScanServices();
      }
    });

    return stream;
  }

  Future bleDisconnectDevice() async {
    if (_deviceConnection == null) {
      return;
    }
    this.connectedDevice = null;
    await _deviceConnection.cancel();
    this._bleState.updateDeviceState(null);
    // notifyListeners();
    return;
  }

  Future bleScanServices() async {
    if (this.connectedDevice == null) return;
    List<BluetoothService> services = await this.connectedDevice.discoverServices();

    for(BluetoothService service in services) {
      print('service uuid: ${service.uuid}');
      List<BluetoothCharacteristic> chars = service.characteristics;
      for (BluetoothCharacteristic char in chars) {
        print('char uuid: ${char.uuid}');
        if (char.uuid.toString() == this.targetUUIDString) {
          this.targetChar = char;
          this.setNotification();
        }
      }
    }
    // notifyListeners();
    return;
  }

  Stream<List<int>> setNotification() async* {
    await this.connectedDevice.setNotifyValue(this.targetChar, true);
    this.connectedDevice.onValueChanged(this.targetChar).listen((value) async* {
      print('value changed! $value');
      yield value;
      // this._fanstate = this._adapter.analyseCode(value);
      // notifyListeners();
    });
  }

  void bleQuickScan() {
    this._bleState.scanning = true;
    print('quick scan');
    _scanSubscription = _flutterBlue.scan().listen((ScanResult scanResult) {
      print(scanResult.device.name);
      final int index = _scanResult
          .indexWhere((item) => item.device.id == scanResult.device.id);
      if (index == -1) {
          _scanResult.add(scanResult);
          print(scanResult.device.name);
      } else {
          _scanResult[index] = scanResult;
      }
    });
    return;
  }
  
}

class BleState {
  bool scanning = false;

  String deviceState = 'No Device';

  void updateDeviceState(BluetoothDeviceState state) {
    this.deviceState = state == null ?  'No Device' : state.toString();
  }
}