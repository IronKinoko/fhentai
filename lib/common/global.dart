import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart' as DioCookieManager;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Global {
  static SharedPreferences _prefs;
  static const String _exUri = 'https://exhentai.org';
  static const String _ehUri = 'https://e-hentai.org';
  static Dio _dio;
  static CookieJar _cookieJar;
  static SharedPreferences get prefs => _prefs;
  static Dio get dio => _dio;
  static String get exUri => _exUri;
  static String get ehUri => _ehUri;
  static PersistCookieJar get cookieJar => _cookieJar;
  static String get currentCookieStr =>
      Global.currentCookie.map((e) => '${e.name}=${e.value}; ').join('');

  static List<Cookie> get currentCookie =>
      _cookieJar.loadForRequest(Uri.parse(Global.prefs.getString('domain')));

  static bool get isSignin => Global.prefs.getBool('isSignin');
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    _cookieJar = new PersistCookieJar(dir: tempPath + '/.cookies/');

    _dio = Dio(BaseOptions(
      headers: {
        'user-agent':
            'Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/70.0.3538.102 Safari/537.36',
      },
    ))
      ..interceptors.add(InterceptorsWrapper(
        onRequest: (RequestOptions options) {
          options = options.merge(baseUrl: Global.prefs.getString('domain'));
          return options;
        },
      ))
      ..interceptors.add(LogInterceptor(responseBody: false))
      ..interceptors.add(DioCookieManager.CookieManager(_cookieJar));

    if (_prefs.getString('domain') == null) {
      await _prefs.setString('domain', _ehUri);
    }
  }
}
