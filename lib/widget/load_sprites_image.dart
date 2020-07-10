import 'dart:async';
import 'dart:math';
import 'dart:ui' as ui;

import 'package:fhentai/common/global.dart';
import 'package:fhentai/model/gallery_detail_model.dart';
import 'package:fhentai/widget/load_image.dart';
import 'package:flutter/material.dart' hide Page;
import 'package:flutter_advanced_networkimage/provider.dart';

class LoadSpritesImage extends StatefulWidget {
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
  _LoadSpritesImageState createState() => _LoadSpritesImageState();
}

class _LoadSpritesImageState extends State<LoadSpritesImage> {
  Completer<ui.Image> completer = Completer();

  @override
  void initState() {
    super.initState();
    getImage(widget.page.thumb);
  }

  Future<void> getImage(String path) async {
    AdvancedNetworkImage(
      path,
      header: {'Cookie': Global.currentCookieStr},
      retryLimit: 20,
      retryDuration: Duration(milliseconds: 300),
      cacheRule: CacheRule(maxAge: const Duration(days: 1)),
      useDiskCache: true,
      printError: true,
      timeoutDuration: Duration(seconds: 20),
    )
        .resolve(ImageConfiguration())
        .addListener(ImageStreamListener((ImageInfo info, bool _) {
      completer.complete(info.image);
    }));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ui.Image>(
      future: completer.future,
      builder: (context, snapshot) {
        if (snapshot.data == null) {
          return Container(
            height: 150,
            // child: Center(
            //   child: CircularProgressIndicator(),
            // ),
          );
        }
        return Center(
          child: SizedBox(
            width: widget.page.spriteWidth,
            child: AspectRatio(
              aspectRatio: widget.page.spriteWidth / widget.page.spriteHeight,
              child: CustomPaint(
                size: Size(widget.page.spriteWidth, widget.page.spriteHeight),
                painter: SpritesIamgePainter(
                    image: snapshot.data, page: widget.page),
              ),
            ),
          ),
        );
      },
    );
  }
}

class SpritesIamgePainter extends CustomPainter {
  ui.Image image;
  Page page;
  SpritesIamgePainter({this.image, this.page});
  @override
  void paint(ui.Canvas canvas, ui.Size size) {
    canvas.drawImageRect(
        image,
        Offset(page.alignIndex * 100.0, 0) &
            Size(page.spriteWidth, page.spriteHeight),
        Offset(0, 0) &
            Size(
                min(size.width, page.spriteWidth),
                min(
                    min(size.width, page.spriteWidth) *
                        page.spriteHeight /
                        page.spriteWidth,
                    page.spriteHeight)),
        Paint());
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
