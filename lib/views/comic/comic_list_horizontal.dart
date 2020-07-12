import 'dart:math';

import 'package:fhentai/model/comic_settings_model.dart';
import 'package:fhentai/model/gallery_detail_model.dart';
import 'package:fhentai/views/comic/comic_item.dart';
import 'package:fhentai/views/comic/comic_statusbar.dart';
import 'package:flutter/material.dart' hide Page;
import 'package:photo_view/photo_view_gallery.dart';
import 'package:provider/provider.dart';

class HorizontalComicList extends StatefulWidget {
  final String gid;

  const HorizontalComicList({Key key, this.gid}) : super(key: key);

  @override
  _HorizontalComicListState createState() => _HorizontalComicListState();
}

class _HorizontalComicListState extends State<HorizontalComicList> {
  PageController pageController;
  @override
  void initState() {
    super.initState();
    GalleryDetailPageState store =
        context.read<GalleryDetailModel>().get(widget.gid);
    pageController = PageController(
        initialPage: store.readerState.currentIndex, viewportFraction: 0.999);
    loadMoreImage(store.readerState.currentIndex);
  }

  void loadMoreImage(int index) {
    GalleryDetailPageState store =
        context.read<GalleryDetailModel>().get(widget.gid);
    print([index, store.info.filecount - index - 1]);
    List.generate(
      min(
        3,
        min(store.pages.length - 1 - index, store.info.filecount - index - 1),
      ),
      (preloadOffset) {
        context.read<GalleryDetailModel>().getRemoteHighQualityImageUrl(
            store.pages[index + preloadOffset], index + preloadOffset);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    GalleryDetailPageState store =
        context.watch<GalleryDetailModel>().get(widget.gid);
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: <Widget>[
          PhotoViewGallery.builder(
            builder: (BuildContext context, int index) {
              Page page = store.pages[index];
              return PhotoViewGalleryPageOptions.customChild(
                  child: GestureDetector(
                onTapUp: (details) {},
                child: ComicItem(page: page, index: index),
              ));
            },
            pageController: pageController,

            reverse:
                context.watch<ComicSettingsModel>().comicSettings.direction ==
                    ComicDirection.HorizontalReverse,
            itemCount: min(store.info.filecount, store.pages.length),
            loadingBuilder: (context, progress) => Center(
              child: Container(
                width: 20.0,
                height: 20.0,
                child: CircularProgressIndicator(),
              ),
            ),
            // pageController: widget.pageController,
            onPageChanged: (index) {
              Provider.of<GalleryDetailModel>(context, listen: false)
                  .setCurrentIndex(widget.gid, index);
              loadMoreImage(index);
            },
          ),
          Positioned(
              right: 0,
              bottom: 16,
              child: SafeArea(
                child: ComicStatusBar(
                  index: store.readerState.currentIndex,
                  total: store.info.filecount,
                ),
              )),
        ],
      ),
    );
  }
}
