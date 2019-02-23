import 'package:flutter/material.dart';

import '../../../utils/BleManager.dart';
import '../../../utils/StoreHelper.dart';

class RenameBox extends StatefulWidget {
  @override
  _RenameBoxState createState() => _RenameBoxState();
}

class _RenameBoxState extends State<RenameBox> {
  final BleManager _bleManager = BleManager();
  final DeviceStore sharedStore = DeviceStore();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController renameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    renameController.text = _bleManager.deviceName;
  }

  void closeDialog() {
    Navigator.pop(context);
  }

  void changeName() async {
    if (!_formKey.currentState.validate()) return;
    print(renameController.text);

    _bleManager.deviceName = renameController.text;
    await sharedStore.changeDeviceName(_bleManager.connectedDevice, _bleManager.deviceName);
    closeDialog();
  }

  Widget _buildInputBox() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 25.0),
      child: Form(
        key: _formKey,
        child: TextFormField(
          controller: renameController,
          decoration: InputDecoration(
            contentPadding:
                EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
            ),
          ),
          validator: (String value) {
            if (value.isEmpty || value.length < 4 || value.length > 10) {
              return 'device name should be 4-10';
            }
          },
        ),
      ),
    );
  }

  Widget _buildInputContent() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        _buildInputBox(),
        FlatButton(
          child: Text('Confirm'),
          onPressed: () {
            changeName();
          },
        )
      ],
    );
  }

  Widget _buildNoDeviceContent() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          padding: EdgeInsets.symmetric(vertical: 20.0),
          child: Text('please connect device'),
        ),
        FlatButton(
          child: Text('Confirm'),
          onPressed: closeDialog,
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool connected = _bleManager.connectedDevice == null;
    final Widget content = connected
        ? _buildNoDeviceContent()
        : _buildInputContent();

    return SimpleDialog(
      title: Text('Rename Box'),
      children: [
        content,
      ],
    );
  }
}
