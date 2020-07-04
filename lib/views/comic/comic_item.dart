import 'package:fhentai/widget/LoadImage.dart';
import 'package:flutter/material.dart';

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
            tag: url,
            child: Material(
              child: LoadImage(url),
            ),
          );
  }
}
