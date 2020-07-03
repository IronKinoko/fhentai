import 'package:fhentai/common/global.dart';
import 'package:fhentai/generated/i18n.dart';
import 'package:fhentai/model/gallery_detail_model.dart';
import 'package:fhentai/views/login.dart';
import 'package:fhentai/views/settings/settings_eh_settings.dart';
import 'package:fhentai/views/settings/settings_eh_tags.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class SettingsEh extends StatefulWidget {
  @override
  _SettingsEhState createState() => _SettingsEhState();
}

class _SettingsEhState extends State<SettingsEh> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('EH'),
      ),
      body: Container(
        child: ListView(
          children: <Widget>[
            ListTile(
              title: Text(
                I18n.of(context).EHUser,
                style: Theme.of(context).textTheme.subtitle1,
              ),
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text(I18n.of(context).EHLogout),
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                            title: Text(I18n.of(context).EHLogout),
                            content: Text(I18n.of(context).EHLogoutContent),
                            actions: <Widget>[
                              FlatButton(
                                child: Text(MaterialLocalizations.of(context)
                                    .cancelButtonLabel),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              FlatButton(
                                child: Text(
                                  I18n.of(context).EHLogout,
                                  style: TextStyle(color: Colors.red),
                                ),
                                onPressed: () {
                                  Global.cookieJar.deleteAll();
                                  Global.prefs.remove('isSignin');
                                  Global.prefs.remove('nickName');
                                  Global.prefs.remove('email');
                                  Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(
                                        builder: (context) => Login(),
                                      ),
                                      (route) => false);
                                },
                              )
                            ]));
              },
            ),
            ListTile(
              leading: Icon(Icons.account_circle),
              title: Text(I18n.of(context).EHUser_Cookie),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text(I18n.of(context).EHUser_Cookie),
                    content: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            I18n.of(context).EHKEEP_IT_SAFE,
                            style: TextStyle(
                                color: Colors.red[600],
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 16),
                          ...Global.currentCookie.map((cookie) => Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4),
                                child: Text(
                                  '${cookie.name}: ${cookie.value}',
                                ),
                              ))
                        ]),
                    actions: <Widget>[
                      FlatButton(
                        child: Text(I18n.of(context).Copy),
                        onPressed: () {
                          Navigator.pop(context);
                          Clipboard.setData(ClipboardData(
                              text: Global.currentCookie
                                  .map((cookie) =>
                                      '${cookie.name}: ${cookie.value}')
                                  .join('\n')));
                        },
                      )
                    ],
                  ),
                );
              },
            ),
            ListTile(
              title: Text(
                I18n.of(context).Setting,
                style: Theme.of(context).textTheme.subtitle1,
              ),
            ),
            ListTile(
              leading: Icon(Icons.explicit),
              title: Text(I18n.of(context).EHEhentai_Switch),
              subtitle: Text(Global.prefs.getString('domain') == Global.ehUri
                  ? 'e-hentai.org'
                  : 'exhentai.org'),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    String _domain = Global.prefs.getString('domain');

                    return AlertDialog(
                      title: Text(I18n.of(context).EHEhentai_Switch),
                      contentPadding: EdgeInsets.symmetric(vertical: 16),
                      content: StatefulBuilder(
                        builder: (context, setState) => Container(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              RadioListTile(
                                title: Text('E-hentai'),
                                groupValue: _domain,
                                onChanged: (String value) {
                                  setState(() {
                                    _domain = value;
                                  });
                                },
                                value: Global.ehUri,
                              ),
                              RadioListTile(
                                title: Text('Exhentai'),
                                groupValue: _domain,
                                onChanged: Global.isSignin
                                    ? (String value) {
                                        setState(() {
                                          _domain = value;
                                        });
                                      }
                                    : null,
                                value: Global.exUri,
                                secondary: Global.isSignin
                                    ? null
                                    : FlatButton(
                                        child: Text(I18n.of(context).Sign_In),
                                        textTheme: ButtonTextTheme.primary,
                                        onPressed: () {
                                          Navigator.of(context)
                                              .push(MaterialPageRoute(
                                            builder: (context) => Login(),
                                          ));
                                        },
                                      ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      actions: <Widget>[
                        FlatButton(
                          child: Text(MaterialLocalizations.of(context)
                              .cancelButtonLabel),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        FlatButton(
                          child: Text(
                              MaterialLocalizations.of(context).okButtonLabel),
                          onPressed: () {
                            Navigator.pop(context);
                            Global.prefs.setString('domain', _domain);
                            Provider.of<GalleryDetailModel>(context,
                                    listen: false)
                                .clear();
                            setState(() {});
                          },
                        )
                      ],
                    );
                  },
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text(I18n.of(context).EHEhentai_Setting),
              trailing: Icon(Icons.arrow_right),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => SettingsEhSettings(),
                ));
              },
            ),
            ListTile(
              leading: Icon(Icons.label),
              title: Text(I18n.of(context).EHEhentai_Tags),
              trailing: Icon(Icons.arrow_right),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => SettingsEhTags(),
                ));
              },
            ),
          ],
        ),
      ),
    );
  }
}
