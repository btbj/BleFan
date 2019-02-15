import 'package:flutter/material.dart';
import '../widgets/tab_buttons/QuitBtn.dart';
import '../widgets/tab_buttons/ContactBtn.dart';
import '../widgets/tab_buttons/DocumentBtn.dart';
import '../widgets/tab_buttons/WaterBtn.dart';

import '../../../utils/DeviceSize.dart';

class TabBarBox extends StatefulWidget {
  @override
  _TabBarBoxState createState() => _TabBarBoxState();
}

class _TabBarBoxState extends State<TabBarBox> {
  Widget _divider({bool small = false}) {
    return Container(
      color: Colors.grey,
      height: small ? 40 : 55,
      width: 2,
    );
  }

  @override
  Widget build(BuildContext context) {
    final DeviceSize dSize = DeviceSize(context);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          QuitBtn(small: dSize.isSmall()),
          _divider(small: dSize.isSmall()),
          ContactBtn(small: dSize.isSmall()),
          _divider(small: dSize.isSmall()),
          DocumentBtn(small: dSize.isSmall()),
          _divider(small: dSize.isSmall()),
          WaterBtn(small: dSize.isSmall()),
        ],
      ),
    );
  }
}
