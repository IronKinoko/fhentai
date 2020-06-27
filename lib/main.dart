import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'model/gallery_model.dart';
import 'common/global.dart';
import 'generated/i18n.dart';
import 'views/gallery.dart';
import 'views/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Global().init();
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (ctx) => GalleryModel())],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GeneratedLocalizationsDelegate i18n = I18n.delegate;
  var _materialLocale;
  bool _loadEnd = false;
  @override
  void initState() {
    super.initState();
    I18n.onLocaleChanged = onLocaleChange;
    loadConfig();
  }

  void loadConfig() async {
    String value = Global.prefs.getString('i18n');

    setState(() {
      if (value == 'zh-CN') {
        _materialLocale = Locale('zh', 'CN');
        I18n.locale = Locale('zh', 'CN');
      } else if (value == 'en-US') {
        _materialLocale = Locale('en', 'US');
        I18n.locale = Locale('en', 'US');
      }
      _loadEnd = true;
    });
  }

  void onLocaleChange(Locale locale) async {
    Global.prefs.setString('i18n', locale.toLanguageTag());
    setState(() {
      I18n.locale = locale;
      _materialLocale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fhentai',
      localizationsDelegates: [
        i18n,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: i18n.supportedLocales,
      localeResolutionCallback: i18n.resolution(),
      debugShowCheckedModeBanner: false,
      // locale: _materialLocale,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        snackBarTheme: SnackBarThemeData(
          elevation: 8,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          behavior: SnackBarBehavior.floating,
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Container(
        child: _loadEnd
            ? Global.isSignin == null ? Login() : Gallery()
            : Center(
                child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CircularProgressIndicator(),
                ],
              )),
        color: Colors.white,
      ),
    );
  }
}
