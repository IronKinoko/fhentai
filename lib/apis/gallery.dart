import 'package:dio/dio.dart';
import 'package:fhentai/common/global.dart';
import 'package:fhentai/model/gallery_detail_model.dart';
import 'package:fhentai/model/gallery_model.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:fhentai/views/gallery.dart';
import './parser/gallery_parser.dart';

Future<ResponseGalerry> galleryList({int page, String fSearch = ''}) async {
  try {
    Response res = await Global.dio
        .get(Uri.encodeFull('/?inline_set=dm_l&page=$page&f_search=$fSearch'));

    return parseGalleryList(res.data, GalleryMode.FrontPage);
  } catch (e) {
    throw Exception(e);
  }
}

Future<ResponseGalerry> watchedGalleryList(
    {int page, String fSearch = ''}) async {
  try {
    Response res = await Global.dio.get(Uri.encodeFull(
        '/watched?inline_set=dm_l&page=$page&f_search=$fSearch'));

    return parseGalleryList(res.data, GalleryMode.Watched);
  } catch (e) {
    throw Exception(e);
  }
}

Future<ResponseGalerry> popularGalleryList(
    {int page, String fSearch = ''}) async {
  try {
    Response res = await Global.dio.get(Uri.encodeFull(
        '/popular?inline_set=dm_l&page=$page&f_search=$fSearch'));

    return parseGalleryList(res.data, GalleryMode.Popular);
  } catch (e) {
    throw Exception(e);
  }
}

Future<GalleryDetailPageState> galleryDetail(String gid, String token) async {
  try {
    List<dynamic> res = await Future.wait([
      Global.dio.get('/g/$gid/$token?inline_set=ts_l'),
      Global.dio.get('/gallerytorrents.php?gid=$gid&t=$token'),
      _gdata([
        [gid, token]
      ]),
    ]);
    final String html = res[0].data;
    final String torrentHtml = res[1].data;
    final Info baseInfo = res[2][0];

    List<Torrent> torrentList = parseTorrentList(torrentHtml);
    List<Page> pageList = parseDetailPageList(html);
    List<Tag> tagList = parseDetailPageTagList(html);
    List<Comment> commentList = parseDetailPageCommentList(html);
    OtherInfo otherInfo = parseDetailPageOtherInfo(html);

    baseInfo.ratingCount = otherInfo.ratingCount;
    baseInfo.favcount = otherInfo.favcount;
    baseInfo.favoritelink = otherInfo.favoritelink;
    baseInfo.language = otherInfo.language;

    baseInfo.torrents.forEach((torrent) {
      Torrent target =
          torrentList.firstWhere((element) => element.hash == torrent.hash);
      torrent.downloads = target.downloads;
      torrent.uploader = target.uploader;
      torrent.url = target.url;
    });

    GalleryDetailPageState state = GalleryDetailPageState(
        info: baseInfo, pages: pageList, comments: commentList, tags: tagList);
    // Clipboard.setData(ClipboardData(text: state.toRawJson()));
    return state;
  } catch (e) {
    print(e);
    throw Exception('load Error');
  }
}

Future<List<Info>> _gdata(List<List<String>> gidlist) async {
  if (gidlist.length == 0) return [];
  final List<Future<Response<String>>> taskList = [];
  _chunk(array: gidlist, size: 25)
      .forEach((gidlist) => taskList.add(Global.dio.post(
            '/api.php',
            data: {
              "method": 'gdata',
              "gidlist": gidlist,
            },
          )));

  final List<Info> res = (await Future.wait(taskList)).map((res) {
    GdataRes data = GdataRes.fromRawJson(res.data);
    data.gmetadata.forEach((o) {
      if (o.error != null)
        throw Exception('[404]Key missing, or incorrect key provided.');
      o.titleJpn = o.titleJpn != '' ? o.titleJpn : o.title;
      o.url = '${Global.prefs.getString('domain')}/g/${o.gid}/${o.token}';
      o.path = '/${o.gid}/${o.token}';
      o.posted = DateFormat('yyyy-MM-dd HH:mm').format(
          DateTime.fromMillisecondsSinceEpoch(int.parse(o.posted) * 1000));
      o.torrents.forEach((torrent) {
        torrent.added = DateFormat('yyyy-MM-dd HH:mm').format(
            DateTime.fromMillisecondsSinceEpoch(
                int.parse(torrent.added) * 1000));
      });
    });
    return data.gmetadata;
  }).reduce((prev, next) => [...prev, ...next]);

  return res;
}

List _chunk({@required List array, @required int size}) {
  List result = [];
  if (array.isEmpty || size <= 0) {
    return result;
  }
  int first = 0;
  int last = size;
  int totalLoop = array.length % size == 0
      ? array.length ~/ size
      : array.length ~/ size + 1;
  for (int i = 0; i < totalLoop; i++) {
    if (last > array.length) {
      result.add(array.sublist(first, array.length));
    } else {
      result.add(array.sublist(first, last));
    }
    first = last;
    last = last + size;
  }
  return result;
}
