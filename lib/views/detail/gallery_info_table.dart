import 'package:fhentai/generated/i18n.dart';
import 'package:fhentai/model/gallery_detail_model.dart';
import 'package:fhentai/widget/index.dart';
import 'package:filesize/filesize.dart';
import 'package:flutter/material.dart';

class GalleryInfoTable extends StatelessWidget {
  final Info info;

  GalleryInfoTable(this.info);

  List<Map<String, dynamic>> _buildList(BuildContext context) {
    return [
      {"key": I18n.of(context).GGallery_InfoGid, "value": '${info.gid}'},
      {"key": I18n.of(context).GGallery_InfoToken, "value": info.token},
      {"key": I18n.of(context).GGallery_InfoTitle, "value": info.title},
      {"key": I18n.of(context).GGallery_InfoTitle_jpn, "value": info.titleJpn},
      {"key": I18n.of(context).GGallery_InfoCategory, "value": info.category},
      {"key": I18n.of(context).GGallery_InfoUrl, "value": info.url},
      {"key": I18n.of(context).GGallery_InfoThumb, "value": info.thumb},
      {"key": I18n.of(context).GGallery_InfoUploader, "value": info.uploader},
      {"key": I18n.of(context).GGallery_InfoPosted, "value": info.posted},
      {"key": I18n.of(context).GGallery_InfoFilecount, "value": info.filecount},
      {
        "key": I18n.of(context).GGallery_InfoFilesize,
        "value": filesize(info.filesize)
      },
      {"key": I18n.of(context).GGallery_InfoRating, "value": info.rating},
      {
        "key": I18n.of(context).GGallery_InfoRating_count,
        "value": info.ratingCount
      },
      {"key": I18n.of(context).GGallery_InfoFavcount, "value": info.favcount},
      {
        "key": I18n.of(context).GGallery_InfoFavoritelink,
        "value": info.favoritelink
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(I18n.of(context).GGallery_Info),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(0),
            child: Table(
              columnWidths: {0: FlexColumnWidth(1), 1: FlexColumnWidth(2)},
              defaultVerticalAlignment: TableCellVerticalAlignment.top,
              children: [
                TableRow(
                    decoration: BoxDecoration(
                        border: BorderDirectional(
                            bottom: BorderSide(color: Colors.grey[300]))),
                    children: [
                      Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: Text(I18n.of(context).GGallery_InfoKey)),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Text(I18n.of(context).GGallery_InfoValue),
                      ),
                    ]),
                ..._buildList(context).map((o) {
                  // final index = _buildList(context)
                  //     .indexWhere((v) => v['key'] == o['key']);
                  return TableRow(
                      decoration: BoxDecoration(
                        border: BorderDirectional(
                            bottom: BorderSide(color: Colors.grey[300])),
                      ),
                      children: [
                        Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            child: Text(o['key'])),
                        Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: (o['key'] ==
                                  I18n.of(context).GGallery_InfoCategory)
                              ? Row(
                                  children: <Widget>[ColorCategory(o['value'])],
                                )
                              : Text('${o['value']}'),
                        ),
                      ]);
                })
              ],
            ),
          ),
        ));
  }
}
