import 'package:flutter/material.dart';
import '../../../../utils/StoreHelper.dart';

class DocumentBtn extends StatelessWidget {
  final bool small;
  final DeviceStore sharedStore = DeviceStore();
  DocumentBtn({this.small});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: small ? 40 : 55,
        child: FlatButton(
          child: Image.asset(
            'assets/images/icons/document.png',
            height: small ? 25 : 30,
          ),
          onPressed: () {
            print('document');
            sharedStore.saveDevice('test');
          },
        ),
      ),
    );
  }
}
