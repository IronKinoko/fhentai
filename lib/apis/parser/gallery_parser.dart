import 'package:fhentai/model/gallery_model.dart';
import 'package:html/parser.dart';

ResponseGalerry parseGalleryList(String html) {
  var document = HtmlParser(html, encoding: 'utf-8').parse();
  final List<GalleryInfo> res = [];
  int total = 0;
  if (html.contains('No hits found')) {
    return ResponseGalerry(res, total);
  }
  total = int.parse(
      document.querySelector('p.ip').text.replaceAll(RegExp(r'[^0-9]'), ''));
  document.querySelectorAll('.itg > tbody > tr').skip(1).forEach((tr) {
    try {
      var title = tr.querySelector('.glink').text;
      var category = tr.querySelector('.cn').text;
      var time = tr.querySelector('[id^=posted_]').text;
      var rating = parseRating(tr.querySelector('.ir').attributes['style']);
      var url = tr.querySelector('.glink').parent.attributes['href'];
      var uploader = tr.querySelector('.gl4c a').text;
      var filecount = int.parse(
          tr.querySelectorAll('.gl4c div')[1].text.replaceAll(' pages', ''));
      var gid = parseUrl(url)[0];
      var token = parseUrl(url)[1];
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
      // print(e);
    }
  });
  return ResponseGalerry(res, total);
}

double parseRating(String style) {
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

List<String> parseUrl(String url) {
  var res = url.split('/').where((element) => element.isNotEmpty).toList();
  var gid = res[res.length - 2];
  var token = res[res.length - 1];
  return [gid, token];
}
