import 'dart:math';

import 'package:fhentai/model/gallery_detail_model.dart';
import 'package:fhentai/views/comic/comic_item.dart';
import 'package:flutter/material.dart' hide Page;
import 'package:flutter_widgets/flutter_widgets.dart';
import 'package:provider/provider.dart';

import 'comic_statusbar.dart';

class ComicList extends StatefulWidget {
  final String gid;

  const ComicList({Key key, this.gid}) : super(key: key);

  @override
  _ComicListState createState() => _ComicListState();
}

class _ComicListState extends State<ComicList> {
  ItemScrollController _itemScrollController = ItemScrollController();
  ItemPositionsListener itemPositionsListener = ItemPositionsListener.create();
  bool _showMenu = false;
  int initpage = 0;
  @override
  void initState() {
    super.initState();
    itemPositionsListener.itemPositions.addListener(_valueChanged);
    GalleryDetailPageState store =
        context.read<GalleryDetailModel>().get(widget.gid);
    initpage = store.readerState.currentIndex;
  }

  @override
  void dispose() {
    itemPositionsListener.itemPositions.removeListener(_valueChanged);
    super.dispose();
  }

  void _valueChanged() {
    Iterable<ItemPosition> value = itemPositionsListener.itemPositions.value;

    if (value.isNotEmpty) {
      int min = value
          .where((ItemPosition position) => position.itemTrailingEdge > 0)
          .reduce((ItemPosition min, ItemPosition position) =>
              position.itemTrailingEdge < min.itemTrailingEdge ? position : min)
          .index;
      if (min ==
          Provider.of<GalleryDetailModel>(context, listen: false)
              .get(widget.gid)
              .readerState
              .currentIndex) return;
      Provider.of<GalleryDetailModel>(context, listen: false)
          .setCurrentIndex(widget.gid, min);
    }
  }

  @override
  Widget build(BuildContext context) {
    GalleryDetailPageState store =
        context.watch<GalleryDetailModel>().get(widget.gid);
    return Scaffold(
      body: Container(
        color: Colors.black,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: <Widget>[
            Positioned.fill(
              child: ScrollablePositionedList.builder(
                padding: MediaQuery.of(context).padding,
                initialScrollIndex: initpage,
                itemScrollController: _itemScrollController,
                itemCount: min(store.info.filecount, store.pages.length),
                itemPositionsListener: itemPositionsListener,
                itemBuilder: (context, index) {
                  Page page = store.pages[index];
                  if (store.pages.length == index &&
                      index < store.info.filecount &&
                      store.readerState.loading) {
                    return Container(
                      height: 200,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                  return GestureDetector(
                    onTapUp: (details) {
                      setState(() {
                        _showMenu = !_showMenu;
                      });
                    },
                    child: ComicItem(page: page, index: index),
                  );
                },
              ),
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
      ),
    );
  }
}
