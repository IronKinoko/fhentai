import 'package:fhentai/widget/load_image.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class ComicItem extends StatelessWidget {
  final String url;

  const ComicItem({Key key, this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return url == null
        ? Container(
            height: 600,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : Hero(
            tag: Uuid().v4(),
            child: Material(
              child: LoadImage(url),
            ),
          );
  }
}
