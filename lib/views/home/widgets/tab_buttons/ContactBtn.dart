import 'package:flutter/material.dart';
import '../../../../utils/StoreHelper.dart';

class ContactBtn extends StatelessWidget {
  final bool small;
  final DeviceStore sharedStore = DeviceStore();
  ContactBtn({this.small});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: small ? 40 : 55,
        child: FlatButton(
          child: Image.asset(
            'assets/images/icons/contact.png',
            height: small ? 27 : 34,
          ),
          onPressed: () async {
            print('contact');
            final storedDevices = await sharedStore.getSavedDevices();
            final aaa = storedDevices.containsKey('test');
            print(aaa);
          },
        ),
      ),
    );
  }
}
