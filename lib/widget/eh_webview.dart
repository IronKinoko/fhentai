import 'package:fhentai/common/global.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class EhWebview extends StatefulWidget {
  EhWebview(this.url, {Key key}) : super(key: key);

  final String url;

  @override
  EhWebviewState createState() => EhWebviewState();
}

class EhWebviewState extends State<EhWebview> {
  WebViewController controller;
  bool _loading = true;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        WebView(
          onWebViewCreated: (WebViewController webViewController) {
            controller = webViewController;
            Map<String, String> headers = {
              'Cookie': Global.currentCookieStr,
            };
            controller.loadUrl(widget.url, headers: headers);
            setState(() {});
          },
          onPageFinished: (url) {
            Global.currentCookie.forEach((e) => controller.evaluateJavascript(
                'document.cookie="${e.name}=${e.value}; path=${e.path};"'));
            setState(() {
              _loading = false;
            });
          },
          javascriptMode: JavascriptMode.unrestricted,
        ),
        Positioned(
          child: Container(
            child: _loading ? LinearProgressIndicator() : null,
          ),
        ),
      ],
    );
  }
}
