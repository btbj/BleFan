import 'package:scoped_model/scoped_model.dart';
import './fan_model.dart';
import './ble_model.dart';
// import './ble_fan_connect_model.dart';

class MainModel extends Model with FanModel, BleModel {
}