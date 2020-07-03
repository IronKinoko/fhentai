import 'dart:io';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:fhentai/common/global.dart';
import 'package:fhentai/cus_icons.dart';
import 'package:fhentai/generated/i18n.dart';
import 'package:fhentai/model/gallery_detail_model.dart';
import 'package:fhentai/model/gallery_model.dart';
import 'package:fhentai/views/detail/gallery_torrent.dart';
import 'package:fhentai/views/gallery.dart';
import 'package:fhentai/widget/index.dart';
import 'package:filesize/filesize.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:fhentai/apis/gallery.dart';

import 'gallery_comments.dart';
import 'gallery_info_table.dart';

class GalleryDetail extends StatefulWidget {
  GalleryDetail(this.record);

  final GalleryInfo record;

  @override
  _GalleryDetailState createState() => _GalleryDetailState();
}

class _GalleryDetailState extends State<GalleryDetail> {
  GlobalKey<ScaffoldState> _scaffold = GlobalKey<ScaffoldState>();
  GalleryDetailPageState store;
  @override
  void initState() {
    super.initState();
    _init();
  }

  _init() async {
    GalleryDetailPageState res =
        Provider.of<GalleryDetailModel>(context, listen: false)
            .get(widget.record.gid);
    if (res == null) {
      res = await galleryDetail(widget.record.gid, widget.record.token);
      if (!mounted) return;
      Provider.of<GalleryDetailModel>(context, listen: false)
          .add(widget.record.gid, res);
    }

    setState(() {
      store = res;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffold,
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: <Widget>[
                _Header(widget: widget),

                /// button list
                _buildButtonList(context),

                /// loading box
                store == null
                    ? _buildLoading()
                    : Column(
                        children: <Widget>[
                          _buildInfo(context),
                          Divider(height: 0.5),
                          Divider(height: 0.5),
                          _buildTags(context),
                          Divider(height: 0.5),
                          _buildComments(context),
                          Divider(height: 0.5),
                          _buildGrid(context),
                        ],
                      )
                // TODO List
              ],
            ),
          ),
        ));
  }

  Widget _buildGrid(BuildContext context) {
    return Wrap(
      children: store.pages.map((page) {
        return FractionallySizedBox(
          widthFactor: 0.25,
          child: Container(
            padding: EdgeInsets.all(8),
            child: AspectRatio(
              aspectRatio: 21 / 29.7,
              child: CachedNetworkImage(
                imageUrl: page.thumb,
                fit: BoxFit.fitWidth,
                httpHeaders: {'Cookie': Global.currentCookieStr},
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTags(BuildContext context) {
    if (store.tags.length == 0)
      return Container(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: Center(child: Text(I18n.of(context).GNo_Tags)),
      );
    return Table(
      columnWidths: {0: FixedColumnWidth(100), 1: FlexColumnWidth(1)},
      children: [
        ...store.tags.map((tag) {
          return TableRow(children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 13, 16, 8),
              child: Text(Global.prefs.getString('i18n') == 'zh-CN'
                  ? tag.namespaceChs
                  : tag.namespace),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: <Widget>[
                  ...tag.frontMatters.map((frontMatter) {
                    return TagChip(
                      label: Text(Global.prefs.getString('i18n') == 'zh-CN'
                          ? frontMatter.nameChs
                          : frontMatter.name),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Gallery(
                                fSearch: frontMatter.keyword,
                              ),
                            ));
                      },
                      tooltip: frontMatter.intro != null &&
                              frontMatter.intro != '' &&
                              Global.prefs.getString('i18n') == 'zh-CN'
                          ? frontMatter.intro
                          : null,
                    );
                  })
                ],
              ),
            )
          ]);
        })
      ],
    );
  }

  Widget _buildComments(BuildContext context) {
    if (store.comments.length == 0) {
      return Container(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: Center(child: Text(I18n.of(context).GNo_Comments)),
      );
    }

    return Column(
      children: <Widget>[
        ...store.comments
            .sublist(0, min(2, store.comments.length))
            .map((comment) => GalleryCommentItem(
                  comment,
                  showAll: false,
                )),
        Row(
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: FlatButton(
                  textTheme: ButtonTextTheme.primary,
                  child: Text(I18n.of(context).More),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GalleryComments(store.comments),
                        ));
                  },
                ),
              ),
            )
          ],
        )
      ],
    );
  }

  Widget _buildInfo(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(flex: 1, child: Text(store.info.language)),
              Expanded(
                  flex: 1,
                  child: Text(
                    store.info.filecount + 'P',
                    textAlign: TextAlign.center,
                  )),
              Expanded(
                  flex: 1,
                  child: Text(
                    filesize(store.info.filesize),
                    textAlign: TextAlign.end,
                  ))
            ],
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.favorite,
                      color: Colors.red,
                    ),
                    Text(store.info.favcount)
                  ],
                ),
              ),
              Expanded(
                  flex: 1,
                  child: Container(
                      child: Center(
                          child: Rating(double.parse(store.info.rating))))),
              Expanded(
                  flex: 1,
                  child: Text(
                    store.info.posted,
                    textAlign: TextAlign.right,
                  ))
            ],
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: FlatButton(
                  textTheme: ButtonTextTheme.primary,
                  child: Text(I18n.of(context).More),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => GalleryInfoTable(store.info)));
                  },
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Padding _buildButtonList(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: Row(
        children: <Widget>[
          IconButton(
            icon:
                Icon(Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back),
            color: Theme.of(context).colorScheme.primary,
            tooltip: MaterialLocalizations.of(context).backButtonTooltip,
            onPressed: () => Navigator.pop(context),
          ),
          IconButton(
            icon: Icon(Icons.cloud_download),
            color: Theme.of(context).colorScheme.primary,
            tooltip: I18n.of(context).Download,
            onPressed: store != null ? () {} : null,
          ),
          IconButton(
            icon: Icon(CusIcons.utorrent),
            color: Theme.of(context).colorScheme.primary,
            tooltip: 'Torrent' + I18n.of(context).Download,
            onPressed: store != null && store.info.torrents.length != 0
                ? () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          GalleryTorrentList(store.info.torrents),
                    ));
                  }
                : null,
          ),
          IconButton(
            icon: Icon(store != null && store.info.favoritelink != ''
                ? Icons.favorite
                : Icons.favorite_border),
            color: Theme.of(context).colorScheme.primary,
            tooltip: 'Torrent' + I18n.of(context).Download,
            onPressed: store != null ? () {} : null,
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
                child: Text(
                  store != null
                      ? I18n.of(context).Read
                      : I18n.of(context).Loading + '...',
                ),
                color: Theme.of(context).colorScheme.primary,
                textColor: Theme.of(context).colorScheme.onPrimary,
                onPressed: store != null ? () {} : null,
              ),
            ),
          )
        ],
      ),
    );
  }

  Container _buildLoading() {
    return Container(
      height: 200,
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
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
                    color: Theme.of(context).colorScheme.primary,
                    child: CachedNetworkImage(
                      imageUrl: widget.record.thumb,
                      width: width,
                      height: width * 1.4,
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

class TagChip extends StatelessWidget {
  final bool dash;
  final Widget label;
  final Function onPressed;
  final String tooltip;
  TagChip({this.label, this.dash, this.onPressed, this.tooltip});

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      label: label,
      onPressed: onPressed,
      tooltip: tooltip,
    );
  }
}
