import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_blue/flutter_blue.dart';

class DeviceStore {
  final String key = 'devices';


  Future<Map<String, dynamic>> getSavedDevices() async {
    final prefs = await SharedPreferences.getInstance();

    String savedString = (prefs.getString(key) ?? '{}');
    // print(savedString);
    final savedDevices = jsonDecode(savedString);
    // print(savedDevices);
    return savedDevices;
  }

  Future saveDevice(BluetoothDevice device) async {
    final savedDevices = await getSavedDevices();
    if (savedDevices.containsKey(device.id.toString())) return;

    savedDevices[device.id.toString()] = {
      'id': device.id.toString(),
      'name': device.name == '' ? 'BLE Fan' : device.name
    };
    final prefs = await SharedPreferences.getInstance();
    final newDataString = jsonEncode(savedDevices);
    prefs.setString(key, newDataString);
    return;
  }

  Future changeDeviceName(BluetoothDevice device, String newName) async {
    final savedDevices = await getSavedDevices();
    if (!savedDevices.containsKey(device.id.toString())) return;

    savedDevices[device.id.toString()]['name'] = newName;
    final prefs = await SharedPreferences.getInstance();
    final newDataString = jsonEncode(savedDevices);
    prefs.setString(key, newDataString);
    return;
  }
}
