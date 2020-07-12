import 'dart:async';
import 'dart:ui' as ui;

import 'package:fhentai/common/global.dart';
import 'package:fhentai/model/gallery_detail_model.dart';
import 'package:flutter/material.dart' hide Page;
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:flutter_advanced_networkimage/transition.dart';
import 'package:provider/provider.dart';

class ComicItem extends StatelessWidget {
  final Page page;
  final int index;
  const ComicItem({Key key, this.page, this.index}) : super(key: key);

  Widget _buildSpritesLoading(BuildContext context, [double progress]) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        CircularProgressIndicator(
          value: progress,
        ),
        Text(
          '${index + 1}',
          style: Theme.of(context)
              .textTheme
              .headline6
              .copyWith(color: Colors.white),
        )
      ],
    );
  }

  Widget _buildLoading(BuildContext context) {
    // if (page.sprites) {
    return _buildSpritesLoading(context);
    // } else {
    //   return LoadImage(
    //     page.thumb,
    //     loadingWidget: _buildSpritesLoading(context),
    //   );
    // }
  }

  @override
  Widget build(BuildContext context) {
    final double aspectRatio = page.spriteWidth / page.spriteHeight;

    final double width = MediaQuery.of(context).size.width;
    final double height = width / aspectRatio;
    return Container(
      width: width,
      height: height,
      child: FutureBuilder<BigImageInfo>(
          future: context
              .watch<GalleryDetailModel>()
              .getRemoteHighQualityImageUrl(page, index),
          builder: (context, snapshot) {
            BigImageInfo bigImageInfo = snapshot.data;
            return bigImageInfo?.imageurl == null
                ? _buildLoading(context)
                : TransitionToImage(
                    image: AdvancedNetworkImage(
                      bigImageInfo.imageurl,
                      header: {'Cookie': Global.currentCookieStr},
                      retryLimit: 20,
                      retryDuration: Duration(milliseconds: 300),
                      cacheRule: CacheRule(maxAge: const Duration(days: 1)),
                      useDiskCache: true,
                      printError: true,
                      timeoutDuration: Duration(seconds: 20),
                    ),
                    // fit: BoxFit.none,
                    loadingWidget: _buildSpritesLoading(context),
                    width: width,
                    height: height,
                  );
            // : CustomComicImageLoader(bigImageInfo, index);
          }),
    );
  }
}

class CustomComicImageLoader extends StatefulWidget {
  final BigImageInfo bigImageInfo;
  final int index;
  CustomComicImageLoader(this.bigImageInfo, this.index);

  @override
  _CustomComicImageLoaderState createState() => _CustomComicImageLoaderState();
}

class _CustomComicImageLoaderState extends State<CustomComicImageLoader> {
  Completer<ui.Image> completer = Completer();
  double loadingProgress = 0;
  @override
  void initState() {
    super.initState();
    loadImg(widget.bigImageInfo.imageurl);
  }

  void loadImg(String path) {
    NetworkImage img =
        NetworkImage(path, headers: {'Cookie': Global.currentCookieStr});
    img.resolve(ImageConfiguration()).addListener(ImageStreamListener(
          (ImageInfo info, bool _) {
            completer.complete(info.image);
          },
          onChunk: (event) {
            setState(() {
              loadingProgress =
                  event.cumulativeBytesLoaded / event.expectedTotalBytes;
            });
          },
          onError: (exception, stackTrace) {
            completer.completeError(exception, stackTrace);
          },
        ));
  }

  @override
  Widget build(BuildContext context) {
    final double aspectRatio =
        widget.bigImageInfo.width / widget.bigImageInfo.height;

    final double width = MediaQuery.of(context).size.width;
    final double height = width / aspectRatio;

    return FutureBuilder<ui.Image>(
      future: completer.future,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Container(
              width: width,
              height: height,
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Text(
                    '${widget.index + 1} loading error',
                    style: Theme.of(context)
                        .textTheme
                        .headline6
                        .copyWith(color: Colors.white),
                  )
                ],
              ));
        }
        if (snapshot.data == null)
          return Container(
              width: width,
              height: height,
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  CircularProgressIndicator(
                    value: loadingProgress,
                  ),
                  Text(
                    '${widget.index + 1}',
                    style: Theme.of(context)
                        .textTheme
                        .headline6
                        .copyWith(color: Colors.white),
                  )
                ],
              ));
        return CustomPaint(
          size: Size(width, height),
          painter: CustomImagePainter(snapshot.data),
        );
      },
    );
  }
}

class CustomImagePainter extends CustomPainter {
  ui.Image image;
  CustomImagePainter(this.image);

  @override
  void paint(Canvas canvas, Size size) {
    Size imgSize = Size(image.width.toDouble(), image.height.toDouble());
    Rect dstRect = Rect.fromLTWH(0, 0, size.width, size.height);

    /// 根据适配模式，计算适合的缩放尺寸
    FittedSizes fittedSizes =
        applyBoxFit(BoxFit.fitWidth, imgSize, dstRect.size);

    /// 获得一个图片区域中，指定大小的，居中位置处的 Rect
    Rect inputRect =
        Alignment.center.inscribe(fittedSizes.source, Offset.zero & imgSize);

    /// 获得一个绘制区域内，指定大小的，居中位置处的 Rect
    Rect outputRect =
        Alignment.center.inscribe(fittedSizes.destination, dstRect);

    canvas.drawImageRect(image, inputRect, outputRect, Paint());
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
