import 'dart:ui';

import 'package:fhentai/common/global.dart';
import 'package:fhentai/model/gallery_detail_model.dart';
import 'package:flutter/material.dart' hide Page;
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:flutter_advanced_networkimage/transition.dart';

class LoadSpritesImage extends StatelessWidget {
  final Page page;
  final double width;
  final double height;
  const LoadSpritesImage(
    this.page, {
    Key key,
    this.width,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TransitionToImage(
      image: AdvancedNetworkImage(
        page.thumb,
        header: {'Cookie': Global.currentCookieStr},
        retryLimit: 20,
        retryDuration: Duration(milliseconds: 300),
        cacheRule: CacheRule(maxAge: const Duration(days: 1)),
        useDiskCache: true,
        printError: true,
        timeoutDuration: Duration(seconds: 20),
      ),
      fit: BoxFit.fitHeight,
      alignment: FractionalOffset.fromOffsetAndSize(
          Offset(page.alignIndex.toDouble(), 0),
          Size(page.aligntotal.toDouble() - 1, 1)),
      loadingWidget: Container(
        width: width,
        height: height,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
