import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart' as DioCookieManager;
import 'package:fhentai/model/comic_settings_model.dart';
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

  static List<Cookie> get currentCookie => _cookieJar
      .loadForRequest(Uri.parse(Global.prefs.getString(PREFS_DOMAIN)));

  static bool get isSignin => Global.prefs.getBool(PREFS_ISSIGNIN);
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
          options =
              options.merge(baseUrl: Global.prefs.getString(PREFS_DOMAIN));
          return options;
        },
      ))
      ..interceptors.add(LogInterceptor(responseBody: false))
      ..interceptors.add(DioCookieManager.CookieManager(_cookieJar));

    /// 初始化访问 e-hentai.org
    if (_prefs.getString(PREFS_DOMAIN) == null) {
      await _prefs.setString(PREFS_DOMAIN, _ehUri);
    }

    /// 初始化 50 条历史记录容量
    if (_prefs.getInt(PREFS_HISTORIES_MAX_LENGTH) == null) {
      await _prefs.setInt(PREFS_HISTORIES_MAX_LENGTH, 50);
    }

    /// 防止 e-hentai.org 警告⚠️
    if (!currentCookieStr.contains('nw=1')) {
      Cookie cookie = Cookie('nw', '1')
        ..domain = _prefs.getString(PREFS_DOMAIN) == _exUri
            ? 'exhentai.org'
            : 'e-hentai.org'
        ..expires = DateTime.now().add(Duration(days: 180))
        ..path = '/'
        ..httpOnly = false;

      _cookieJar.saveFromResponse(
          Uri.parse(_prefs.getString(PREFS_DOMAIN)), [cookie]);
    }

    /// 初始化漫画设置
    if (_prefs.getString(PREFS_COMIC_SETTINGS) == null) {
      await _prefs.setString(PREFS_COMIC_SETTINGS, ComicSettings().toRawJson());
    }
  }
}

/// prefs key
const String PREFS_I18N = 'i18n';
const String PREFS_HISTORIES = 'histories';
const String PREFS_HISTORIES_MAX_LENGTH = 'histories_max_length';
const String PREFS_DOMAIN = 'domain';
const String PREFS_ISSIGNIN = 'isSignin';
const String PREFS_NICKNAME = 'nickName';
const String PREFS_EMAIL = 'email';
const String PREFS_HIS_EMAIL = 'his_email';
const String PREFS_HIS_PASSWORD = 'his_password';
const String PREFS_COMIC_SETTINGS = 'comic_settings';
const String PREFS_SUGGESTIONS = 'suggestions';
