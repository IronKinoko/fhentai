import 'package:fhentai/model/gallery_detail_model.dart';
import 'package:fhentai/views/comic/comic_list.dart';
import 'package:flutter/material.dart' hide Page;

class ComicReader extends StatefulWidget {
  final String gid;
  const ComicReader({Key key, this.gid}) : super(key: key);

  @override
  _ComicReaderState createState() => _ComicReaderState();
}

class _ComicReaderState extends State<ComicReader> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Comic'),
      ),
      body: Container(
        child: Stack(
          children: <Widget>[
            ComicList(gid: widget.gid),
          ],
        ),
      ),
    );
  }
}
