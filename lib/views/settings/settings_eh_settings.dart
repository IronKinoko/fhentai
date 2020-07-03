import 'package:fhentai/common/global.dart';
import 'package:fhentai/generated/i18n.dart';
import 'package:fhentai/widget/eh_webview.dart';
import 'package:flutter/material.dart';

class SettingsEhSettings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(I18n.of(context).EHEhentai_Setting),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              Global.dio.get(Global.prefs.getString('domain') + '/uconfig.php');
              Navigator.pop(context);
            },
          )
        ],
      ),
      body: SafeArea(
        child: Container(
          child: EhWebview(Global.prefs.getString('domain') + '/uconfig.php'),
        ),
      ),
    );
  }
}
