import 'package:fhentai/common/global.dart';
import 'package:fhentai/generated/i18n.dart';
import 'package:fhentai/views/gallery.dart';
import 'package:fhentai/views/login.dart';
import 'package:fhentai/views/settings/settings.dart';
import 'package:flutter/material.dart';

class MenuDraw extends StatelessWidget {
  final String current;

  const MenuDraw({Key key, this.current}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            padding: EdgeInsets.zero,
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                image: DecorationImage(
                    image: AssetImage(
                      'images/panda.png',
                    ),
                    fit: BoxFit.cover)),
            child: Stack(
              children: <Widget>[
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          Global.prefs.getString(PREFS_NICKNAME) ??
                              I18n.of(context).Sign_InVisitor,
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        if (Global.prefs.getString(PREFS_EMAIL) != null)
                          Text(Global.prefs.getString(PREFS_EMAIL),
                              style: TextStyle(color: Colors.white))
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          if (Global.prefs.getString(PREFS_EMAIL) == null)
            FlatButton(
              textTheme: ButtonTextTheme.primary,
              child: Text(I18n.of(context).Sign_In),
              onPressed: () =>
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => Login(),
              )),
            ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text(I18n.of(context).Front_Page),
            onTap: () {
              Navigator.of(context).pop();
              if (I18n.of(context).Front_Page == current) return;
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => Gallery(
                  mode: GalleryMode.FrontPage,
                ),
              ));
            },
          ),
          ListTile(
            leading: Icon(Icons.subscriptions),
            title: Text(I18n.of(context).Watched),
            onTap: () {
              Navigator.of(context).pop();
              if (I18n.of(context).Watched == current) return;
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => Gallery(
                  mode: GalleryMode.Watched,
                ),
              ));
            },
          ),
          ListTile(
            leading: Icon(Icons.whatshot),
            title: Text(I18n.of(context).Popular),
            onTap: () {
              Navigator.of(context).pop();
              if (I18n.of(context).Popular == current) return;
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => Gallery(
                  mode: GalleryMode.Popular,
                ),
              ));
            },
          ),
          ListTile(
            leading: Icon(Icons.favorite),
            title: Text(I18n.of(context).Favorites),
            onTap: () {
              Navigator.of(context).pop();
              if (I18n.of(context).Favorites == current) return;
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => Gallery(),
              ));
            },
          ),
          ListTile(
            leading: Icon(Icons.history),
            title: Text(I18n.of(context).Histories),
            onTap: () {
              Navigator.of(context).pop();
              if (I18n.of(context).Histories == current) return;
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => Gallery(mode: GalleryMode.Histories),
              ));
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text(I18n.of(context).Setting),
            onTap: () {
              Navigator.of(context).pop();
              if (I18n.of(context).Setting == current) return;
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => Settings(),
              ));
            },
          ),
        ],
      ),
    );
  }
}
