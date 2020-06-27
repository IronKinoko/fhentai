import 'package:dio/dio.dart';
import 'package:fhentai/apis/parser/login_parser.dart';
import 'package:fhentai/common/global.dart';

Future<String> login(String userName, String passWord) async {
  try {
    print([userName, passWord]);
    Response res = await Global.dio
        .request('https://forums.e-hentai.org/index.php?act=Login&CODE=01',
            options: RequestOptions(
              data: {
                "UserName": userName,
                "PassWord": passWord,
                "referer": 'https://forums.e-hentai.org/index.php',
                "b": '',
                "bt": '',
                "CookieDate": "1",
              },
              method: 'POST',
              contentType: Headers.formUrlEncodedContentType,
            ));
    return parseLogin(res.data);
  } catch (e) {
    throw (e);
  }
}
