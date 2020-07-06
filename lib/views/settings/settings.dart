import 'package:fhentai/generated/i18n.dart';
import 'package:fhentai/views/about/about.dart';
import 'package:fhentai/views/settings/settings_advanced.dart';
import 'package:fhentai/views/settings/settings_eh.dart';
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
                leading: Icon(Icons.explicit),
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
                onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => SettingsAdvanced(),
                )),
              ),
              ListTile(
                leading: Icon(Icons.info),
                title: Text(I18n.of(context).About),
                trailing: Icon(Icons.arrow_right),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AboutView(),
                      ));
                },
              )
            ],
          ),
        ));
  }
}
