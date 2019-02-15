import 'package:flutter/material.dart';

class DeviceSize {
  final BuildContext context;
  
  DeviceSize(this.context);

  bool isSmall () {
    final double deviceHeight = MediaQuery.of(context).size.height;
    final double deviceWidth = MediaQuery.of(context).size.width;
    return deviceHeight < 600 || deviceWidth < 350;
  }

}