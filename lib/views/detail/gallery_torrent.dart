import 'package:fhentai/cus_icons.dart';
import 'package:fhentai/generated/i18n.dart';
import 'package:fhentai/model/gallery_detail_model.dart';
import 'package:filesize/filesize.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GalleryTorrentList extends StatefulWidget {
  GalleryTorrentList(this.torrents);

  final List<Torrent> torrents;

  @override
  _GalleryTorrentListState createState() => _GalleryTorrentListState();
}

class _GalleryTorrentListState extends State<GalleryTorrentList> {
  GlobalKey<ScaffoldState> scaffold = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffold,
      appBar: AppBar(
        title: Text('Torrent'),
      ),
      body: Container(
        child: ListView.builder(
          itemCount: widget.torrents.length,
          itemBuilder: (context, index) {
            final torrent = widget.torrents[index];
            return ListTile(
              leading: Icon(
                CusIcons.utorrent,
                color: Theme.of(context).colorScheme.primary,
              ),
              title: Text(torrent.name),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('${I18n.of(context).GTorrentAdded}: ${torrent.added}'),
                  Text('${I18n.of(context).Download}: ${torrent.downloads}'),
                  Text(
                      '${I18n.of(context).GTorrentTsize}: ${filesize(torrent.tsize)}'),
                  Text(
                      '${I18n.of(context).GTorrentSize}: ${filesize(torrent.fsize)}'),
                ],
              ),
              onTap: () {
                Clipboard.setData(ClipboardData(text: torrent.url));
                scaffold.currentState.removeCurrentSnackBar();
                scaffold.currentState.showSnackBar(SnackBar(
                  content: Text(I18n.of(context).Copyied + ' ' + torrent.name),
                ));
              },
            );
          },
        ),
      ),
    );
  }
}
