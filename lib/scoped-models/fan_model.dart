// import 'dart:async';
import '../utils/BleCode.dart';
import 'package:scoped_model/scoped_model.dart';
import '../models/FanState.dart';

mixin FanModel on Model {
  FanState fanstate = FanState();
  final BleCode _adapter = BleCode();

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

  void resetFanstate() {
    this.fanstate.reset();
    notifyListeners();
  }
}