import 'package:cached_network_image/cached_network_image.dart';
import 'package:fhentai/common/global.dart';
import 'package:fhentai/model/gallery_model.dart';
import 'package:fhentai/widget/index.dart';
import 'package:flutter/material.dart';

class GalleryCard extends StatelessWidget {
  final GalleryInfo record;

  const GalleryCard(
    this.record, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: () {},
        child: Container(
          child: Row(
            children: <Widget>[
              CachedNetworkImage(
                httpHeaders: {'Cookie': Global.currentCookieStr},
                imageUrl: record.thumb,
                placeholder: (context, url) => Container(
                  width: 100,
                  height: 150,
                  child: Center(child: CircularProgressIndicator()),
                ),
                errorWidget: (context, url, error) => Icon(Icons.error),
                width: 100,
                height: 150,
                fit: BoxFit.cover,
              ),
              Expanded(
                child: Container(
                  height: 150,
                  padding: EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        record.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text(record.uploader),
                      Spacer(),
                      Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Rating(record.rating),
                              Spacer(),
                              Row(
                                children: <Widget>[
                                  Text('${record.filecount}P')
                                ],
                              )
                            ],
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Row(
                            children: <Widget>[
                              ColorCategory(record.category),
                              Spacer(),
                              Text('${record.time}')
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
    );
  }
}
