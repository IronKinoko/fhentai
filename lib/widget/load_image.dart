import 'dart:typed_data';

import 'package:fhentai/common/global.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:flutter_advanced_networkimage/transition.dart';

class LoadImage extends StatelessWidget {
  final String url;
  final double width;
  final double height;
  final LoadingWidgetBuilder loadingWidgetBuilder;
  final Widget loadingWidget;
  const LoadImage(
    this.url, {
    Key key,
    this.width,
    this.height,
    this.loadingWidgetBuilder,
    this.loadingWidget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TransitionToImage(
      image: AdvancedNetworkImage(
        url,
        header: {'Cookie': Global.currentCookieStr},
        retryLimit: 20,
        retryDuration: Duration(milliseconds: 300),
        cacheRule: CacheRule(maxAge: const Duration(days: 1)),
        useDiskCache: true,
        printError: true,
        timeoutDuration: Duration(seconds: 20),
      ),
      fit: BoxFit.fitWidth,
      loadingWidgetBuilder: loadingWidgetBuilder,
      loadingWidget: loadingWidget ?? Container(),
      width: width,
      height: height,
    );
  }
}
