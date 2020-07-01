import 'package:cached_network_image/cached_network_image.dart';
import 'package:fhentai/common/global.dart';
import 'package:fhentai/cus_icons.dart';
import 'package:fhentai/generated/i18n.dart';
import 'package:fhentai/model/gallery_model.dart';
import 'package:fhentai/widget/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GalleryDetail extends StatefulWidget {
  GalleryDetail(this.record);

  final GalleryInfo record;

  @override
  _GalleryDetailState createState() => _GalleryDetailState();
}

class _GalleryDetailState extends State<GalleryDetail> {
  GlobalKey<ScaffoldState> _scaffold = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffold,
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              _Header(widget: widget),
// button List
              Padding(
                padding: const EdgeInsets.all(0),
                child: Row(
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.arrow_back),
                      color: Theme.of(context).colorScheme.primary,
                      tooltip:
                          MaterialLocalizations.of(context).backButtonTooltip,
                      onPressed: () => Navigator.pop(context),
                    ),
                    IconButton(
                      icon: Icon(Icons.cloud_download),
                      color: Theme.of(context).colorScheme.primary,
                      tooltip: I18n.of(context).Download,
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: Icon(CusIcons.utorrent),
                      color: Theme.of(context).colorScheme.primary,
                      tooltip: 'Torrent' + I18n.of(context).Download,
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: Icon(Icons.favorite),
                      color: Theme.of(context).colorScheme.primary,
                      tooltip: 'Torrent' + I18n.of(context).Download,
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: Icon(Icons.content_copy),
                      color: Theme.of(context).colorScheme.primary,
                      tooltip: I18n.of(context).Copy,
                      onPressed: () {
                        Clipboard.setData(ClipboardData(
                            text:
                                '${Global.prefs.getString('domain')}/g/${widget.record.gid}/${widget.record.token}'));
                        _scaffold.currentState.removeCurrentSnackBar();
                        _scaffold.currentState.showSnackBar(SnackBar(
                          content: Text(I18n.of(context).Copyied),
                          duration: Duration(seconds: 1),
                        ));
                      },
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: FlatButton(
                          child: Text(I18n.of(context).Read),
                          color: Theme.of(context).colorScheme.primary,
                          textColor: Theme.of(context).colorScheme.onPrimary,
                          onPressed: () {},
                        ),
                      ),
                    )
                  ],
                ),
              )
              // TODO List
            ],
          ),
        ));
  }
}

class _Header extends StatelessWidget {
  final double width = 130;

  const _Header({
    Key key,
    @required this.widget,
  }) : super(key: key);

  final GalleryDetail widget;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.primary,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Hero(
                  tag: widget.record.gid,
                  child: Material(
                    child: CachedNetworkImage(
                      imageUrl: widget.record.thumb,
                      width: width,
                      // height: width * 1.4,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  height: width * 1.4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        widget.record.title,
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.headline6.copyWith(
                            color: Theme.of(context).colorScheme.onPrimary),
                      ),
                      SizedBox(height: 8),
                      Text(
                        widget.record.uploader,
                        style: Theme.of(context).textTheme.subtitle1.copyWith(
                            color: Theme.of(context).colorScheme.onPrimary),
                      ),
                      Spacer(),
                      ColorCategory(widget.record.category)
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
