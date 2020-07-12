import 'dart:math';

import 'package:fhentai/common/DB.dart';
import 'package:fhentai/model/db_model.dart';
import 'package:fhentai/model/gallery_detail_model.dart';
import 'package:fhentai/model/gallery_favorites_model.dart';
import 'package:fhentai/model/gallery_model.dart';
import 'package:fhentai/views/gallery.dart';
import 'package:html/dom.dart' hide Comment;
import 'package:html/parser.dart';
import 'package:intl/intl.dart';

ResponseGalerry parseGalleryList(String html,
    [GalleryMode mode = GalleryMode.FrontPage]) {
  var document = HtmlParser(html, encoding: 'utf-8').parse();
  final List<GalleryInfo> res = [];
  int total = 0;
  if (html.contains('No hits found')) {
    return ResponseGalerry(res, total);
  }
  if (mode == GalleryMode.FrontPage || mode == GalleryMode.Favorites)
    total = int.parse(
        document.querySelector('p.ip').text.replaceAll(RegExp(r'[^0-9]'), ''));
  if (mode == GalleryMode.Watched)
    total = int.parse(document
        .querySelectorAll('p.ip')[1]
        .text
        .replaceAll(RegExp(r'[^0-9]'), ''));
  document.querySelectorAll('.itg > tbody > tr').skip(1).forEach((tr) {
    try {
      var title = tr.querySelector('.glink').text;
      var category = tr.querySelector('.cn').text;
      var time = DateFormat('yyyy-MM-dd HH:mm').format(
          DateTime.parse(tr.querySelector('[id^=posted_]').text + 'Z')
              .toLocal());
      var rating = _parseRating(tr.querySelector('.ir').attributes['style']);

      var url = tr.querySelector('.glink').parent.attributes['href'];
      var uploader =
          mode == GalleryMode.Favorites ? '' : tr.querySelector('.gl4c a').text;
      var filecount = int.parse(RegExp(r':\d\d(\d+) pages')
          .firstMatch(tr.querySelector('.glthumb').text)
          .group(1));
      var gid = _parseUrl(url)[0];
      var token = _parseUrl(url)[1];
      var thumb = tr.querySelector('.glthumb img').attributes['data-src'] ??
          tr.querySelector('.glthumb img').attributes['src'];
      res.add(GalleryInfo(
        gid: gid,
        token: token,
        time: time,
        title: title,
        category: category,
        rating: rating,
        uploader: uploader,
        filecount: filecount,
        thumb: thumb,
      ));
    } catch (e) {
      print(e);
    }
  });
  if (mode == GalleryMode.Popular) total = res.length;
  return ResponseGalerry(res, total);
}

double _parseRating(String style) {
  var rating = 5.0;
  var re = RegExp(r'(\-?\d+)px (\-?\d+)px');
  re.allMatches(style).forEach((res) {
    var left = double.parse(res.group(1));
    var top = double.parse(res.group(2));
    rating += (left / 16);
    rating += (top == -21) ? -0.5 : 0;
  });
  return rating;
}

List<String> _parseUrl(String url) {
  var res = url.split('/').where((element) => element.isNotEmpty).toList();
  var gid = res[res.length - 2];
  var token = res[res.length - 1];
  return [gid, token];
}

List<Page> parseDetailPageList(String html) {
  var document = HtmlParser(html, encoding: 'utf-8').parse();

  /// get style background url
  RegExp re = RegExp(r'width:(.*)px;.*height:(.*)px;.*url\((.*)\) -(.*?)px');

  final gdts =
      document.getElementById('gdt').querySelectorAll('div[class^="gdt"]');
  int i = 0;
  int k = 0;
  final List<Page> list = gdts.map((gdt) {
    final aEl = gdt.querySelector('a');
    final imgEl = gdt.querySelector('img');
    String thumb = imgEl.attributes['src'];
    if (gdt.className == 'gdtm') {
      final page = Page.fromSprites(url: aEl.attributes['href']);
      final divEl = gdt.querySelector('div');
      String style = divEl.attributes['style'];
      RegExpMatch res = re.firstMatch(style);
      page.spriteWidth = double.parse(res.group(1));
      page.spriteHeight = double.parse(res.group(2)) - 1;
      page.thumb = res.group(3);
      page.alignIndex = i % 20;
      page.aligntotal = min(gdts.length - k * 20, 20);
      i++;
      if (i % 20 == 0) k++;
      return page;
    }
    return Page(url: aEl.attributes['href'], thumb: thumb);
  }).toList();

  return list;
}

List<Comment> parseDetailPageCommentList(String html) {
  Document document = HtmlParser(html, encoding: 'utf-8').parse();

  final divs = document.querySelectorAll('#cdiv .c1');

  if (divs.length == 0) return [];

  return divs.map((c1) {
    final c3 = c1.querySelector('.c3'); // time + name
    final c5 = c1.querySelector('.c5 [id^=comment]'); //  score
    final c6 = c1.querySelector('.c6'); // comment

    RegExp re = RegExp(r'Posted on (.*?)by:(.*)');
    var res = re.firstMatch(c3.text);

    var time = _formatUTCtoLocal(res.group(1).trim());
    var userName = res.group(2).trim();
    var score = c5?.text ?? '';
    var comment = c6?.innerHtml;
    return Comment(
        time: time, userName: userName, score: score, comment: comment);
  }).toList();
}

List<Tag> parseDetailPageTagList(String html) {
  Document document = HtmlParser(html, encoding: 'utf-8').parse();

  final trs = document.querySelectorAll('#taglist tr');

  if (trs.length == 0) return [];
  return translated(trs.map((tr) {
    // parse tag Category
    var namespace = tr.children[0].innerHtml
        .substring(0, tr.children[0].innerHtml.length - 1);
    var frontMatters = tr.children[1].children.map((div) {
      final name = div.text;
      final keyword = namespace + ':' + name;
      final dash = div.className == 'gtl';
      return FrontMatter(name: name, keyword: keyword, dash: dash);
    }).toList();
    return Tag(frontMatters: frontMatters, namespace: namespace);
  }).toList());
}

OtherInfo parseDetailPageOtherInfo(String html) {
  Document document = HtmlParser(html, encoding: 'utf-8').parse();

  final String ratingCount = document.getElementById('rating_count').text;

  String favoritelink = document.getElementById('favoritelink').text;
  if (favoritelink.contains('Add to Favorites')) favoritelink = null;

  final String favcount = document
      .getElementById('favcount')
      .text
      .replaceAll(RegExp(r'[^0-9]'), '');

  String language = '';
  document.querySelectorAll('#gdd table tr').forEach((tr) {
    String text = tr.text;
    if (text.contains('Language')) {
      language = text.split(':')[1].trim();
    }
  });
  return OtherInfo(
    ratingCount: ratingCount,
    favcount: favcount,
    favoritelink: favoritelink,
    language: language,
  );
}

BigImageInfo parseBigImg(String html) {
  Document document = HtmlParser(html, encoding: 'utf-8').parse();
  BigImageInfo bigImageInfo = BigImageInfo();
  RegExp reWidth = RegExp(r'width:\s?(\d+)px');
  RegExp reHeight = RegExp(r'height:\s?(\d+)px');
  bigImageInfo.imageurl = document.getElementById('img').attributes['src'];
  bigImageInfo.width = double.parse(reWidth
      .firstMatch(document.getElementById('img').attributes['style'])
      .group(1));
  bigImageInfo.height = double.parse(reHeight
      .firstMatch(document.getElementById('img').attributes['style'])
      .group(1));
  return bigImageInfo;
}

List<Torrent> parseTorrentList(String html) {
  Document document = HtmlParser(html, encoding: 'utf-8').parse();

  final tables = document.querySelectorAll('table');
  if (tables.length == 0) return [];
  final list = tables
      .map((table) {
        try {
          final trs = table.querySelectorAll('tr');
          final tr0tds = trs[0].querySelectorAll('td');
          final info = Torrent();
          tr0tds.forEach((td) {
            final str = td.text;
            if (str != null && str.isNotEmpty) {
              final key = _getKV(str)[0];
              final value = _getKV(str)[1];
              if (key.toLowerCase() == 'downloads') info.downloads = value;
            }
          });
          final tr1td0 = trs[1].querySelector('td');
          final value = _getKV(tr1td0.text)[1];
          info.uploader = value;
          final a = trs[2].querySelector('a');
          info.url = a.attributes['href'];
          info.name = a.text;
          info.hash = a.attributes['href'].split('/').last.split('.').first;
          return info;
        } catch (e) {
          return null;
        }
      })
      .where((v) => v != null)
      .toList();
  return list;
}

List<String> _getKV(String str) {
  return str.replaceAll(':', '=').split('=').map((v) => v.trim()).toList();
}

/// `time = '02 July 2020, 07:21 UTC'`
String _formatUTCtoLocal(String time) {
  Map monthMap = {
    'January': '1',
    'February': '2',
    'March': '3',
    'April': '4',
    'May': '5',
    'June': '6',
    'July': '7',
    'August': '8',
    'September': '9',
    'October': '10',
    'November': '11',
    'December': '12',
  };

  List<String> times = time
      .replaceAll(RegExp(r'[:,]'), ' ')
      .split(' ')
      .where((element) => element.isNotEmpty)
      .toList();
  times[1] = monthMap[times[1]];
  times.removeLast();

  List<int> utcTime = times.map((element) {
    return int.parse(element);
  }).toList();

  return DateFormat('yyyy-MM-dd HH:mm').format(
      DateTime.utc(utcTime[2], utcTime[1], utcTime[0], utcTime[3], utcTime[4])
          .toLocal());
}

List<Tag> translated(List<Tag> tagList) {
  tagList.forEach((row) {
    DatumElement namespace =
        DB.db.data.firstWhere((element) => element.namespace == row.namespace);

    row.frontMatters.forEach((o) {
      DatumValue tag = namespace.data[o.name];
      o.nameChs = tag?.name ?? o.name;
      o.intro = tag?.intro ?? '';
    });

    row.namespaceChs = namespace.frontMatters.name;
    row.description = namespace.frontMatters.description;
  });
  return tagList;
}

List<FavoritesInfo> parseFavoritesSettingInfo(String html) {
  Document document = HtmlParser(html, encoding: 'utf-8').parse();

  List<Element> lists = document.querySelectorAll('.nosel [class=fp]');

  int total = int.parse(
      document.querySelector('p.ip').text.replaceAll(RegExp(r'[^0-9]'), ''));
  int i = 0;
  List<FavoritesInfo> res = lists.map((favNode) {
    int count = int.parse(favNode.children[0].text);
    String favName = favNode.children[2].text;
    return FavoritesInfo(
        count: count, favIndex: (i++).toString(), favName: favName);
  }).toList();

  res.insert(0, FavoritesInfo(count: total, favName: 'All', favIndex: 'all'));
  return res;
}
