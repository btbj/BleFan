import 'package:flutter/material.dart';

class ContactBtn extends StatelessWidget {
  final bool small;
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
          onPressed: () {
            print('contact');
          },
        ),
      ),
    );
  }
}
