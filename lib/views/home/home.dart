import 'package:flutter/material.dart';
import './components/LogoBox.dart';
import './components/ControlPanel.dart';
import './components/TabBarBox.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          alignment: Alignment.topCenter,
          margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 0.0),
          padding: EdgeInsets.only(top: 25.0),
          child: Flex(
            direction: Axis.vertical,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              LogoBox(),
              ControlPanel(),
              TabBarBox()
            ],
          ),
        ),
      ),
    );
  }
}
