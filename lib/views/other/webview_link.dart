import 'package:fhentai/widget/eh_webview.dart';
import 'package:flutter/material.dart';

class WebviewLink extends StatefulWidget {
  WebviewLink(this.url);
  final String url;

  @override
  _WebviewLinkState createState() => _WebviewLinkState();
}

class _WebviewLinkState extends State<WebviewLink> {
  GlobalKey<EhWebviewState> key = GlobalKey<EhWebviewState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.url),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              key.currentState.controller.reload();
            },
          )
        ],
      ),
      body: Container(
        child: EhWebview(
          widget.url,
          key: key,
        ),
      ),
    );
  }
}
