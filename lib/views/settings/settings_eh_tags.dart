import 'dart:async';

import 'package:fhentai/common/global.dart';
import 'package:fhentai/generated/i18n.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class SettingsEhTags extends StatelessWidget {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    _controller.future.then((controller) {
      Map<String, String> headers = {'Cookie': Global.currentCookieStr};
      controller.loadUrl(Global.prefs.getString('domain') + '/mytags',
          headers: headers);
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(I18n.of(context).EHEhentai_Tags),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              Global.dio.get(Global.prefs.getString('domain') + '/mytags');
            },
          )
        ],
      ),
      body: SafeArea(
        child: Container(
          child: WebView(
            onWebViewCreated: (WebViewController webViewController) {
              _controller.complete(webViewController);
            },
            onPageFinished: (url) {
              _controller.future.then((controller) {
                Global.currentCookie.forEach((e) => controller.evaluateJavascript(
                    'document.cookie="${e.name}=${e.value}; path=${e.path};"'));
              });
            },
            javascriptMode: JavascriptMode.unrestricted,
          ),
        ),
      ),
    );
  }
}
