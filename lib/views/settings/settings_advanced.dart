import 'package:fhentai/common/global.dart';
import 'package:fhentai/generated/i18n.dart';
import 'package:fhentai/model/gallery_model.dart';
import 'package:flutter/material.dart';

class SettingsAdvanced extends StatefulWidget {
  @override
  _SettingsAdvancedState createState() => _SettingsAdvancedState();
}

class _SettingsAdvancedState extends State<SettingsAdvanced> {
  /// language dialog
  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        String _value = Global.prefs.getString(PREFS_I18N);

        return AlertDialog(
          title: Text(I18n.of(context).Language),
          contentPadding: EdgeInsets.symmetric(vertical: 16),
          content: StatefulBuilder(
            builder: (context, setState) => Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  RadioListTile(
                    groupValue: _value,
                    value: null,
                    title: Text(I18n.of(context).FollowSystem),
                    onChanged: (String value) => setState(() => _value = value),
                  ),
                  RadioListTile(
                    groupValue: _value,
                    value: 'en-US',
                    title: Text('English'),
                    onChanged: (String value) => setState(() => _value = value),
                  ),
                  RadioListTile(
                    groupValue: _value,
                    value: 'zh-CN',
                    title: Text('简体中文'),
                    onChanged: (String value) => setState(() => _value = value),
                  )
                ],
              ),
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
              onPressed: () => Navigator.pop(context),
            ),
            FlatButton(
              child: Text(MaterialLocalizations.of(context).okButtonLabel),
              onPressed: () {
                if (_value == 'zh-CN') {
                  I18n.onLocaleChanged(Locale('zh', 'CN'));
                } else if (_value == 'en-US') {
                  I18n.onLocaleChanged(Locale('en', 'US'));
                } else if (_value == null) {
                  I18n.onLocaleChanged(null);
                }
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  String _currentLanguage(BuildContext context) {
    String v = Global.prefs.getString(PREFS_I18N);
    if (v == 'zh-CN') return '简体中文';
    if (v == 'en-US') return 'English';
    return I18n.of(context).FollowSystem;
  }

  void _inputHistoriesMaxLength(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          String _value =
              Global.prefs.getInt(PREFS_HISTORIES_MAX_LENGTH).toString();
          return AlertDialog(
              content: TextField(
            autofocus: true,
            controller: TextEditingController(text: _value),
            onSubmitted: (value) async {
              await Global.prefs
                  .setInt(PREFS_HISTORIES_MAX_LENGTH, int.parse(value));
              Navigator.pop(context);
              ResponseGalerry.getFromHistories().clear();
              setState(() {});
            },
          ));
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(I18n.of(context).Advanced),
      ),
      body: Container(
        child: ListView(
          children: <Widget>[
            ListTile(
              title: Text(I18n.of(context).Language),
              subtitle: Text(_currentLanguage(context)),
              leading: Icon(Icons.translate),
              onTap: () => _showLanguageDialog(context),
            ),
            ListTile(
              title: Text(I18n.of(context).HistoriesMaxLength),
              subtitle: Text(
                  Global.prefs.getInt(PREFS_HISTORIES_MAX_LENGTH).toString()),
              leading: Icon(Icons.history),
              onTap: () => _inputHistoriesMaxLength(context),
            )
          ],
        ),
      ),
    );
  }
}
