import 'dart:async';
import 'dart:math';

import 'package:fhentai/common/global.dart';
import 'package:fhentai/model/gallery_detail_model.dart';
import 'package:fhentai/widget/load_image.dart';
import 'package:flutter/material.dart' hide Page;
import 'package:provider/provider.dart';
import 'dart:ui' as ui;

class ComicItem extends StatelessWidget {
  final Page page;
  final int index;
  const ComicItem({Key key, this.page, this.index}) : super(key: key);

  Widget _buildSpritesLoading(BuildContext context, [double progress]) {
    return Container(
        height: MediaQuery.of(context).size.height * 0.55,
        child: Stack(
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
        ));
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
    return FutureBuilder<BigImageInfo>(
        future: context
            .watch<GalleryDetailModel>()
            .getRemoteHighQualityImageUrl(page, index),
        builder: (context, snapshot) {
          BigImageInfo bigImageInfo = snapshot.data;
          return bigImageInfo?.imageurl == null
              ? _buildLoading(context)
              : CustomComicImageLoader(bigImageInfo, index);
        });
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
    canvas.drawImageRect(
        image,
        Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()),
        Offset(0, 0) & size,
        Paint());
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
