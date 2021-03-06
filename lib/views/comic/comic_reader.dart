import 'package:flutter/material.dart' hide Page;

import 'comic_list_horizontal.dart';

class ComicReader extends StatefulWidget {
  final String gid;
  const ComicReader({Key key, this.gid}) : super(key: key);

  @override
  _ComicReaderState createState() => _ComicReaderState();
}

class _ComicReaderState extends State<ComicReader> {
  @override
  Widget build(BuildContext context) {
    // return ComicList(gid: widget.gid);
    return HorizontalComicList(gid: widget.gid);
  }
}
