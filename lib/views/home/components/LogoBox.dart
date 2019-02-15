import 'package:flutter/material.dart';
import '../../../utils/DeviceSize.dart';

class LogoBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final DeviceSize dSize = DeviceSize(context);

    return Container(
      child: Image.asset(
        'assets/images/logo/logo.png',
        width: dSize.isSmall() ? 120.0 : 150.0,
      ),
    );
  }
}
