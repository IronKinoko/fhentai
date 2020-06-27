import 'package:fhentai/generated/i18n.dart';
import 'package:flutter/material.dart';

class SettingsAdvanced extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(I18n.of(context).Advanced),
      ),
      body: Container(),
    );
  }
}
