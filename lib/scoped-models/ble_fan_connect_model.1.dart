import 'dart:async';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_blue/flutter_blue.dart';
import '../utils/BleCode.dart';
import '../models/FanState.dart';

mixin BleFanConnectModel on Model {
  FanState _fanstate = FanState();
  final String targetUUIDString = '0000ffe1-0000-1000-8000-00805f9b34fb';
  BluetoothDevice connectedDevice;
  BluetoothCharacteristic targetChar;

  final BleCode _adapter = BleCode();
  final BleState _bleState = BleState();
}

mixin FanModel on BleFanConnectModel {

  FanState get state => _fanstate;

  void togglePower() async {
    if (connectedDevice == null) return;
    _fanstate.togglePower();
    sendCode(_fanstate);
  }

  void toggleCool() {
    if (connectedDevice == null) return;
    _fanstate.toggleCool();
    if (_fanstate.power) {
      sendCode(_fanstate);
    }
  }

  void toggleSwing() {
    if (connectedDevice == null) return;
    _fanstate.toggleSwing();
    if (_fanstate.power) {
      sendCode(_fanstate);
    }
  }

  void setLevel(int level) {
    if (connectedDevice == null) return;
    _fanstate.setLevel(level);
    if (_fanstate.power) {
      sendCode(_fanstate);
    }
  }

  void setOffTimer(int hours) {
    if (connectedDevice == null) return;
    _fanstate.setOffTimer(hours);
    if (_fanstate.power) {
      sendCode(_fanstate);
    }
  }

  void sendCode(FanState state) async {
    final code = this._adapter.getFanStateCode(state);
    await this.connectedDevice.writeCharacteristic(this.targetChar, code);
  }

  Future checkState() async {
    print('check');
    final checkCode = this._adapter.getCheckStateCode();
    await this.connectedDevice.writeCharacteristic(this.targetChar, checkCode);
    return;
  }
}

mixin BleModel on BleFanConnectModel {
  final FlutterBlue _flutterBlue = FlutterBlue.instance;
  final List<ScanResult> _scanResult = [];

  String get deviceState => this._bleState.deviceState;
  bool get scanning => this._bleState.scanning;
  
  StreamSubscription<ScanResult> _scanSubscription;
  StreamSubscription<BluetoothDeviceState> _deviceConnection;

  List<ScanResult> get bleScanResult => this._scanResult;
  StreamSubscription<BluetoothDeviceState> get deviceConnection => this._deviceConnection;

  void bleStartScan() {
    this._bleState.scanning = true;
    print('start ble scan');
    _scanResult.clear();
    notifyListeners();

    _scanSubscription = _flutterBlue.scan().listen((ScanResult scanResult) {
      final int index = _scanResult
          .indexWhere((item) => item.device.id == scanResult.device.id);
      if (index == -1) {
          _scanResult.add(scanResult);
      } else {
          _scanResult[index] = scanResult;
      }
      notifyListeners();
    });
  }

  void bleStopScan() {
    this._bleState.scanning = false;
    if (_scanSubscription == null) {
      return;
    }
    print('stop ble scan');
    _scanSubscription.cancel();
    notifyListeners();
  }

  StreamSubscription<BluetoothDeviceState> bleConnectDevice(ScanResult targetResult) {
    this.bleStopScan();
    final Stream<BluetoothDeviceState> stream = _flutterBlue.connect(targetResult.device);

    _deviceConnection = stream.listen((s) async* {
      this._bleState.updateDeviceState(s);
      notifyListeners();
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
    this._bleState.updateDeviceState(null);
    notifyListeners();
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
    notifyListeners();
    return;
  }

  void setNotification() async {
    await this.connectedDevice.setNotifyValue(this.targetChar, true);
    this.connectedDevice.onValueChanged(this.targetChar).listen((value) {
      print('value changed! $value');
      this._fanstate = this._adapter.analyseCode(value);
      notifyListeners();
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
