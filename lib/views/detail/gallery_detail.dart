import 'dart:math';

import 'package:fhentai/common/global.dart';
import 'package:fhentai/cus_icons.dart';
import 'package:fhentai/generated/i18n.dart';
import 'package:fhentai/model/gallery_detail_model.dart';
import 'package:fhentai/model/gallery_model.dart';
import 'package:fhentai/views/comic/comic_reader.dart';
import 'package:fhentai/views/detail/gallery_torrent.dart';
import 'package:fhentai/views/search/search_result.dart';
import 'package:fhentai/widget/index.dart';
import 'package:fhentai/widget/load_image.dart';
import 'package:fhentai/widget/load_sprites_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

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
  bool _error = false;
  @override
  void initState() {
    super.initState();
    Future.microtask(() => _init());
  }

  Future<void> _init() async {
    try {
      GalleryDetailPageState res = await context
          .read<GalleryDetailModel>()
          .fetchGalleryDetail(widget.record.gid, widget.record.token);
      if (mounted)
        setState(() {
          /// 从评论中链接点进来的 修复未知的参数
          if (widget.record.title == 'unknow') {
            widget.record.patchFromJson(res.info.toJson());
          }

          if (widget.record.uploader == null ||
              widget.record.uploader.isEmpty) {
            widget.record.uploader = res.info.uploader;
          }

          /// 添加历史记录
          ResponseGalerry.getFromHistories().pushToHistories(widget.record);
          store = res;
        });
    } catch (e) {
      print(e);
      if (mounted)
        setState(() {
          _error = true;
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffold,
      appBar: AppBar(
        title: Text(
          widget.record.title,
          overflow: TextOverflow.fade,
        ),
      ),
      // extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        child: SafeArea(
          top: false,
          child: Column(
            children: <Widget>[
              _buildHeader(context),

              /// button list
              // _buildButtonList(context),

              _error
                  ? _buildErrorBox(context)
                  : store == null
                      ? _buildLoading()
                      : Column(
                          children: <Widget>[
                            _buildInfo(context),
                            Divider(height: 0.5),
                            _buildTags(context),
                            Divider(height: 0.5),
                            _buildComments(context),
                            Divider(height: 0.5),
                            _buildGrid(context),
                          ],
                        )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorBox(BuildContext context) {
    return Container(
      height: 300,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.error,
              size: 80,
              color: Theme.of(context).colorScheme.error,
            ),
            SizedBox(height: 8),
            Text(
              I18n.of(context).Error,
              style: Theme.of(context).textTheme.subtitle1,
            ),
            SizedBox(height: 8),
            FlatButton(
                textColor: Theme.of(context).colorScheme.onPrimary,
                color: Theme.of(context).colorScheme.primary,
                onPressed: () {
                  setState(() {
                    _error = false;
                    _init();
                  });
                },
                child: Text(
                  MaterialLocalizations.of(context)
                      .refreshIndicatorSemanticLabel,
                )),
          ],
        ),
      ),
    );
  }

  void showComic([int index]) {
    if (index != null)
      context
          .read<GalleryDetailModel>()
          .setCurrentIndex(widget.record.gid, index);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return ComicReader(
            gid: widget.record.gid,
          );
        },
      ),
    ).then((value) {
      setState(() {});
    });
  }

  Widget _buildInkWell(int index) {
    return Positioned.fill(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            showComic(index);
          },
        ),
      ),
    );
  }

  Widget _buildGrid(BuildContext context) {
    int i = 0;
    return Wrap(
      children: store.pages
          .sublist(0, min(widget.record.filecount, store.pages.length))
          .map((page) {
        int k = i++;

        if (page.sprites) {
          return FractionallySizedBox(
            widthFactor: 0.25,
            child: Container(
              padding: EdgeInsets.all(8),
              child: Stack(
                children: <Widget>[
                  Hero(
                    tag: page.uuid,
                    child: Material(child: LoadSpritesImage(page)),
                  ),
                  _buildInkWell(k)
                ],
              ),
            ),
          );
        }
        return FractionallySizedBox(
          widthFactor: 0.25,
          child: Container(
            padding: EdgeInsets.all(8),
            child: AspectRatio(
              aspectRatio: 21 / 29.7,
              child: Stack(
                children: [
                  Hero(
                    tag: page.uuid,
                    child: Material(child: LoadImage(page.thumb)),
                  ),
                  _buildInkWell(k)
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTags(BuildContext context) {
    bool isChinese =
        Localizations.localeOf(context).toLanguageTag().startsWith('zh');
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
              child: Text(isChinese ? tag.namespaceChs : tag.namespace),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: <Widget>[
                  ...tag.frontMatters.map((frontMatter) {
                    return TagChip(
                      label: Text(
                          isChinese ? frontMatter.nameChs : frontMatter.name),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SearchResult(
                                fSearch: frontMatter.keyword,
                              ),
                            ));
                      },
                      tooltip: frontMatter.intro != null &&
                              frontMatter.intro != '' &&
                              isChinese
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
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                I18n.of(context).GComments,
                style: Theme.of(context)
                    .textTheme
                    .headline6
                    .copyWith(fontSize: 18),
              ),
              IconButton(
                icon: Icon(Icons.chevron_right),
                color: Theme.of(context).colorScheme.primary,
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GalleryComments(store.comments),
                      ));
                },
              ),
            ],
          ),
        ),
        ...store.comments
            .sublist(0, min(2, store.comments.length))
            .map((comment) => GalleryCommentItem(
                  comment,
                  showAll: false,
                )),
      ],
    );
  }

  Widget _buildInfo(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8)
          .copyWith(bottom: 0),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                  flex: 6,
                  child: Row(
                    children: <Widget>[
                      Text(
                        store.info.rating,
                        style: TextStyle(
                            color: Colors.grey[600],
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                      Rating(
                        double.parse(store.info.rating),
                        color: Colors.grey[600],
                      )
                    ],
                  )),
              Expanded(
                  flex: 4,
                  child: Text(
                    '${store.info.filecount}P',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.grey[600],
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  )),
              Expanded(
                flex: 6,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      store.info.language,
                      style: TextStyle(
                          color: Colors.grey[600],
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    )
                  ],
                ),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                  flex: 6,
                  child: Row(
                    children: <Widget>[ColorCategory(store.info.category)],
                  )),
              Expanded(
                  flex: 4,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.favorite,
                        color: Colors.red[300],
                        size: 18,
                      ),
                      Text(store.info.favcount)
                    ],
                  )),
              Expanded(
                  flex: 6,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      IconButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  GalleryInfoTable(store.info)));
                        },
                        padding: EdgeInsets.zero,
                        color: Theme.of(context).colorScheme.primary,
                        icon: Icon(Icons.chevron_right),
                      )
                    ],
                  ))
            ],
          ),
        ],
      ),
    );
  }

  // ignore: unused_element
  Padding _buildButtonList(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: Row(
        children: <Widget>[
          BackButton(
            color: Theme.of(context).colorScheme.primary,
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
            tooltip: store != null && store.info.favoritelink != ''
                ? store.info.favoritelink
                : I18n.of(context).GFavoriteAdd,
            onPressed: store != null ? () {} : null,
          ),
          IconButton(
            icon: Icon(Icons.content_copy),
            color: Theme.of(context).colorScheme.primary,
            tooltip: I18n.of(context).Copy,
            onPressed: () {
              Clipboard.setData(ClipboardData(
                  text:
                      '${Global.prefs.getString(PREFS_DOMAIN)}/g/${widget.record.gid}/${widget.record.token}'));
              _scaffold.currentState.removeCurrentSnackBar();
              _scaffold.currentState.showSnackBar(SnackBar(
                content: Text(I18n.of(context).Copyied),
                duration: Duration(seconds: 1),
              ));
            },
          ),
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

  Widget _buildHeader(BuildContext context) {
    final double width = 120;
    return Container(
      // color: Theme.of(context).colorScheme.primary,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Container(
                  width: width,
                  height: width * 1.4,
                  child: widget.record.thumb.isNotEmpty
                      ? Hero(
                          tag: widget.record.uuid,
                          child: Material(
                            child: LoadImage(
                              widget.record.thumb,
                              width: width,
                              height: width * 1.4,
                            ),
                          ),
                        )
                      : null,
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
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context)
                            .textTheme
                            .headline6
                            .copyWith(fontSize: 18),
                      ),
                      SizedBox(height: 8),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SearchResult(
                                  fSearch: 'uploader:${widget.record.uploader}',
                                ),
                              ));
                        },
                        child: Text(
                          widget.record.uploader,
                          style: Theme.of(context).textTheme.caption,
                        ),
                      ),
                      Spacer(),
                      // ColorCategory(widget.record.category),
                      SizedBox(height: 8),
                      Row(
                        children: <Widget>[
                          FlatButton(
                            child: Text(
                              store != null
                                  ? I18n.of(context).Read
                                  : I18n.of(context).Loading + '...',
                            ),
                            color: Theme.of(context).colorScheme.primary,
                            textColor: Theme.of(context).colorScheme.onPrimary,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18)),
                            onPressed: store != null
                                ? () {
                                    showComic();
                                  }
                                : null,
                          ),
                          Spacer(),
                          IconButton(
                            onPressed: () {},
                            color: Theme.of(context).colorScheme.primary,
                            icon: Icon(Icons.more_vert),
                          )
                        ],
                      ),
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
