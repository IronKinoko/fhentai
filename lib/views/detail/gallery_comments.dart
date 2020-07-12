import 'package:fhentai/common/global.dart';
import 'package:fhentai/generated/i18n.dart';
import 'package:fhentai/model/gallery_detail_model.dart';
import 'package:fhentai/model/gallery_model.dart';
import 'package:fhentai/views/detail/gallery_detail.dart';
import 'package:fhentai/views/other/webview_link.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';

class GalleryComments extends StatelessWidget {
  GalleryComments(this.comments);

  final List<Comment> comments;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(I18n.of(context).GComments),
      ),
      body: Container(
        child: ListView.separated(
          itemCount: comments.length,
          itemBuilder: (context, index) {
            Comment comment = comments[index];
            return GalleryCommentItem(comment);
          },
          separatorBuilder: (BuildContext context, int index) => Divider(),
        ),
      ),
    );
  }
}

class GalleryCommentItem extends StatelessWidget {
  GalleryCommentItem(this.comment, {this.showAll = true});
  final Comment comment;
  final bool showAll;
  @override
  Widget build(BuildContext context) {
    return ListTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(comment.userName),
            Text(comment.time),
          ],
        ),
        subtitle: ConstrainedBox(
          constraints:
              BoxConstraints(maxHeight: showAll ? double.infinity : 100),
          child: Html(
            data: comment.comment + ' ' + comment.score,
            style: {
              'body': Style(
                  margin: EdgeInsets.only(top: 8),
                  padding: EdgeInsets.all(0),
                  fontSize: FontSize(16))
            },
            onLinkTap: (url) {
              if (url.contains(Global.ehUri + '/g') ||
                  url.contains(Global.exUri + '/g')) {
                RegExp re = RegExp(r'/g/(.*?)/(.*)/?');
                try {
                  RegExpMatch res = re.firstMatch(url);
                  String gid = res.group(1);
                  String token = res.group(2);
                  if (token.contains('/'))
                    token = token.substring(0, token.length - 1);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GalleryDetail(GalleryInfo(
                            token: token,
                            gid: gid,
                            category: 'unknow',
                            title: "unknow",
                            filecount: 0,
                            rating: 0,
                            thumb: '',
                            time: '',
                            uploader: '',
                            url: "")),
                      ));
                  return;
                } catch (e) {}
              }
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WebviewLink(url),
                  ));
            },
          ),
        ));
  }
}
