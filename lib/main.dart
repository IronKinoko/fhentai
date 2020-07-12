import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'common/DB.dart';
import 'common/global.dart';
import 'generated/i18n.dart';
import 'model/comic_settings_model.dart';
import 'model/gallery_detail_model.dart';
import 'model/gallery_favorites_model.dart';
import 'model/gallery_model.dart';
import 'views/gallery.dart';
import 'views/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Global().init();
  await DB().init();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => GalleryModel()),
        ChangeNotifierProvider(create: (context) => GalleryDetailModel()),
        ChangeNotifierProvider(create: (context) => ComicSettingsModel()),
        ChangeNotifierProvider(create: (context) => FavoritesModel(context)),
      ],
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

  void loadConfig() {
    String value = Global.prefs.getString(PREFS_I18N);

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
    await Global.prefs.setString(PREFS_I18N, locale?.toLanguageTag());
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
        GlobalCupertinoLocalizations.delegate,
        DefaultCupertinoLocalizations.delegate
      ],
      supportedLocales: i18n.supportedLocales,
      localeResolutionCallback: i18n.resolution(),
      debugShowCheckedModeBanner: false,
      locale: _materialLocale,
      theme:
          ThemeData.from(colorScheme: ColorScheme.light(primary: Colors.blue))
              .copyWith(
        snackBarTheme: SnackBarThemeData(
          elevation: 8,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          behavior: SnackBarBehavior.floating,
        ),
        backgroundColor: Colors.grey[400],
        visualDensity: VisualDensity.adaptivePlatformDensity,
        appBarTheme: AppBarTheme(
            elevation: 1,
            color: Colors.white,
            textTheme: Theme.of(context).textTheme,
            brightness: Brightness.light,
            iconTheme: IconThemeData(color: Colors.black87)),
        // bottomAppBarColor: Colors.black,
      ),
      home: _loadEnd
          ? Global.isSignin == null ? Login() : Gallery()
          : Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
    );
  }
}
