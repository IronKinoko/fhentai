import 'package:animations/animations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fhentai/common/global.dart';
import 'package:fhentai/model/gallery_model.dart';
import 'package:fhentai/views/detail/gallery_detail.dart';
import 'package:fhentai/widget/index.dart';
import 'package:flutter/material.dart';

import 'load_image.dart';

class GalleryCard extends StatelessWidget {
  final GalleryInfo record;

  const GalleryCard(
    this.record, {
    Key key,
  }) : super(key: key);

  String _buildLanguageString(String title) {
    final chineseRe = RegExp(r'(\[Chinese\]|\[中国翻訳\])');

    if (chineseRe.hasMatch(title)) return 'ZH';
    return '';
  }

  @override
  Widget build(BuildContext context) {
    final double _height = 120;
    const double _weight = 90;

    return Card(
      elevation: 0,
      margin: EdgeInsets.symmetric(horizontal: 0, vertical: 4),
      child: Material(
        child: InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GalleryDetail(record),
                ));
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: <Widget>[
                Hero(
                  tag: record.uuid,
                  child: Material(
                    child: SizedBox(
                      width: _weight,
                      height: _height,
                      child: LoadImage(
                        record.thumb,
                        width: _weight,
                        height: _height,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    height: _height,
                    padding: EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          record.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 14),
                        ),
                        // SizedBox(
                        //   height: 8,
                        // ),
                        Text(
                          record.uploader,
                          style:
                              TextStyle(color: Color(0xff666666), fontSize: 14),
                        ),
                        Spacer(),
                        Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Rating(record.rating),
                                Spacer(),
                                Row(
                                  children: <Widget>[
                                    Text(
                                      _buildLanguageString(record.title),
                                      style: TextStyle(
                                          color: Color(0xff666666),
                                          fontSize: 14),
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      '${record.filecount}P',
                                      style: TextStyle(
                                          color: Color(0xff666666),
                                          fontSize: 14),
                                    )
                                  ],
                                )
                              ],
                            ),
                            // SizedBox(
                            //   height: 4,
                            // ),
                            Row(
                              children: <Widget>[
                                ColorCategory(record.category),
                                Spacer(),
                                Text(
                                  '${record.time}',
                                  style: TextStyle(
                                      color: Color(0xff666666), fontSize: 14),
                                )
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
