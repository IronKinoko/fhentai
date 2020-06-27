import 'package:fhentai/generated/i18n.dart';
import 'package:fhentai/views/settings/settings_eh.dart';
import 'package:fhentai/widget/index.dart';
import 'package:flutter/material.dart';

class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(I18n.of(context).Setting),
        ),
        body: Container(
          child: ListView(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.account_circle),
                title: Text('EH'),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => SettingsEh(),
                  ));
                },
                trailing: Icon(Icons.arrow_right),
              ),
              ListTile(
                leading: Icon(Icons.settings),
                title: Text(I18n.of(context).Advanced),
                trailing: Icon(Icons.arrow_right),
              ),
              ListTile(
                leading: Icon(Icons.info),
                title: Text(I18n.of(context).About),
                trailing: Icon(Icons.arrow_right),
              )
            ],
          ),
        ));
  }
}
