import 'package:fhentai/common/global.dart';
import 'package:fhentai/generated/i18n.dart';
import 'package:fhentai/model/gallery_detail_model.dart';
import 'package:fhentai/views/other/webview_link.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:url_launcher/url_launcher.dart';

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
