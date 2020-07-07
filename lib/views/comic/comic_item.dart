import 'package:fhentai/model/gallery_detail_model.dart';
import 'package:fhentai/widget/load_image.dart';
import 'package:flutter/material.dart' hide Page;
import 'package:provider/provider.dart';

class ComicItem extends StatelessWidget {
  final Page page;
  final int index;
  const ComicItem({Key key, this.page, this.index}) : super(key: key);

  Widget _buildLoading(BuildContext context, [double progress]) {
    return Container(
        height: MediaQuery.of(context).size.height * 0.6,
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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: context
          .watch<GalleryDetailModel>()
          .getRemoteHighQualityImageUrl(page, index),
      builder: (context, snapshot) {
        return snapshot.data == null
            ? _buildLoading(context)
            : LoadImage(snapshot.data,
                loadingWidgetBuilder: (context, progress, ___) =>
                    _buildLoading(context, progress));
      },
    );
  }
}
