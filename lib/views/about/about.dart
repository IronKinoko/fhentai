import 'package:fhentai/generated/i18n.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutView extends StatefulWidget {
  @override
  _AboutViewState createState() => _AboutViewState();
}

class _AboutViewState extends State<AboutView> {
  final String sourceUrl = 'https://github.com/IronKinoko/fhentai';
  final String authorUrl = 'https://github.com/IronKinoko';

  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
  );

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      _packageInfo = await PackageInfo.fromPlatform();
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(I18n.of(context).About),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text('FHentai'),
            subtitle: Text(I18n.of(context).AboutFHentaiDesc),
          ),
          ListTile(
            title: Text(I18n.of(context).AboutAuthor),
            subtitle: Text('IronKinoko <kinoko.main@gmail.com>'),
            trailing: IconButton(
              icon: Icon(Icons.open_in_new),
              onPressed: () => launch(authorUrl),
            ),
          ),
          ListTile(
            title: Text(I18n.of(context).AboutSource),
            subtitle: Text(sourceUrl),
            trailing: IconButton(
              icon: Icon(Icons.open_in_new),
              onPressed: () => launch(sourceUrl),
            ),
          ),
          ListTile(
            title: Text(I18n.of(context).AboutLicense),
            subtitle: Text('MIT'),
          ),
          ListTile(
            title: Text(I18n.of(context).AboutVersion),
            subtitle: Text(_packageInfo.version),
          )
        ],
      ),
    );
  }
}
