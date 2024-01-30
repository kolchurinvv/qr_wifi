import 'package:flutter/material.dart';

import '../settings/settings_view.dart';
import 'package:qr_flutter/qr_flutter.dart';

class SSIDFormView extends StatefulWidget {
  static const routeName = '/';

  const SSIDFormView({super.key});

  @override
  State<StatefulWidget> createState() => _SSIDFormViewState();
}

class _SSIDFormViewState extends State<SSIDFormView> {
  String _ssid = '';
  String _password = '';
  String _encryption = 'WPA2'; // Default value
  String? _qrData; // Holds the data for the QR code

  void _generateQRCode() {
    setState(() {
      _qrData = 'WIFI:T:$_encryption;S:$_ssid;P:$_password;;';
    });
  }

  Widget _buildQRCode() {
    if (_qrData != null) {
      return QrImageView(
        data: _qrData!,
        version: QrVersions.auto,
        size: 200.0,
      );
    } else {
      return const SizedBox(); // Returning an empty SizedBox instead of Container
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wifi QR Generator'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Navigate to the settings page. If the user leaves and returns
              // to the app after it has been killed while running in the
              // background, the navigation stack is restored.
              Navigator.restorablePushNamed(context, SettingsView.routeName);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // SSID TextField
            TextField(
              decoration: const InputDecoration(
                labelText: 'SSID',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _ssid = value;
                });
              },
            ),
            const SizedBox(height: 8.0), // Spacer
            // Password TextField
            TextField(
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _password = value;
                });
              },
            ),
            const SizedBox(height: 8.0), // Spacer
            // Dropdown Menu
            DropdownButton<String>(
              value: _encryption,
              icon: const Icon(Icons.arrow_downward),
              elevation: 16,
              onChanged: (String? newValue) {
                setState(() {
                  _encryption = newValue!;
                });
              },
              items: <String>['WEP', 'WPA', 'WPA2']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            ElevatedButton(
              onPressed: _generateQRCode,
              child: const Text('Generate QR Code'),
            ),
            if (_qrData != null) _buildQRCode(),
            // ... [Any additional widgets]
          ],
        ),
      ),
    );
  }
}
