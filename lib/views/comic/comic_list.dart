import 'package:fhentai/model/gallery_detail_model.dart';
import 'package:fhentai/views/comic/comic_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widgets/flutter_widgets.dart';
import 'package:provider/provider.dart';

class ComicList extends StatelessWidget {
  final String gid;

  const ComicList({Key key, this.gid}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final store = context.select<GalleryDetailModel, GalleryDetailPageState>(
        (model) => model.get(gid));
    return ScrollablePositionedList.builder(
      itemCount: int.parse(store.info.filecount),
      itemBuilder: (context, index) {
        final url = store.pages[index].thumb;
        return ComicItem(
          url: url,
        );
      },
    );
  }
}
