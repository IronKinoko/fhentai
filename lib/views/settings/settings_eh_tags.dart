import 'package:fhentai/common/global.dart';
import 'package:fhentai/generated/i18n.dart';
import 'package:fhentai/widget/eh_webview.dart';
import 'package:flutter/material.dart';

class SettingsEhTags extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(I18n.of(context).EHEhentai_Tags),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              Global.dio.get(Global.prefs.getString(PREFS_DOMAIN) + '/mytags');
              Navigator.pop(context);
            },
          )
        ],
      ),
      body: SafeArea(
        child: Container(
          child: EhWebview(Global.prefs.getString(PREFS_DOMAIN) + '/mytags'),
        ),
      ),
    );
  }
}
