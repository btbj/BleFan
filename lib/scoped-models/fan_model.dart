// import 'dart:async';
import 'package:scoped_model/scoped_model.dart';

import '../models/FanState.dart';
import '../utils/BleCode.dart';
import '../utils/BleManager.dart';

mixin FanModel on Model {
  FanState fanstate = FanState();
  final BleCode _adapter = BleCode();
  final BleManager _bleManager = BleManager();

  bool get connected { return this._bleManager.connectedDevice != null;}

  List<int> getSetCode() {
    return this._adapter.getFanStateCode(fanstate);
  }

  List<int> getCheckCode() {
    return this._adapter.getCheckStateCode();
  }

  void setNewState(List<int> value) {
    this.fanstate = this._adapter.analyseCode(value);
    notifyListeners();
  }

  void sendNewState() async {
    if (this._bleManager.connectedDevice == null) return;

    await this._bleManager.sendCode(this.getSetCode());
  }

  void resetFanstate() {
    this.fanstate.reset();
    notifyListeners();
  }
}