import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fhentai/apis/gallery.dart';
import 'package:uuid/uuid.dart';

class GalleryDetailModel extends ChangeNotifier {
  Map<String, GalleryDetailPageState> _galleryMap = {};
  GalleryDetailPageState get(String gid) {
    return _galleryMap[gid];
  }

  void add(String gid, GalleryDetailPageState state) {
    _galleryMap[gid] = state;
    notifyListeners();
  }

  void clear() {
    _galleryMap.clear();
    notifyListeners();
  }

  void setCurrentIndex(String gid, int index) {
    GalleryDetailPageState store = get(gid);
    store.readerState.currentIndex = index;
    checkNeedGetNextPage(store, index);
    notifyListeners();
  }

  void checkNeedGetNextPage(GalleryDetailPageState store, int index) async {
    int filecount = int.parse(store.info.filecount);
    int pagesLength = store.pages.length;
    if (store.readerState.loading) return;
    if (filecount > pagesLength) {
      /// 需要加载下一页
      if (pagesLength - index < 7) {
        store.readerState.loading = true;
        ++store.readerState.loadedPage;
        List<Page> nextPages = await getNextPage(store.info.gid.toString(),
            store.info.token, store.readerState.loadedPage);
        store.pages.addAll(nextPages);
        store.readerState.loading = false;
        notifyListeners();
      }
    }
  }

  Future<String> getRemoteHighQualityImageUrl(Page page, int index) async {
    if (page.imgurl == null) {
      page.imgurl = await loadHighQualityImageUrl(page.url);
      notifyListeners();
    }
    return page.imgurl;
  }

  Future<GalleryDetailPageState> fetchGalleryDetail(
      String gid, String token) async {
    GalleryDetailPageState res;
    res = get(gid);
    if (res == null) {
      res = await galleryDetail(gid, token);
      add(gid, res);
    }
    notifyListeners();
    return res;
  }
}

class GalleryComicReaderState {
  int currentIndex;
  int loadedPage = 0;
  bool loading = false;

  GalleryComicReaderState({this.currentIndex = 0});
}

class GalleryDetailPageState {
  GalleryDetailPageState({
    this.info,
    this.pages,
    this.comments,
    this.tags,
  });

  Info info;
  List<Page> pages;
  List<Comment> comments;
  List<Tag> tags;

  GalleryComicReaderState readerState =
      GalleryComicReaderState(currentIndex: 0);

  factory GalleryDetailPageState.fromRawJson(String str) =>
      GalleryDetailPageState.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GalleryDetailPageState.fromJson(Map<String, dynamic> json) =>
      GalleryDetailPageState(
        info: Info.fromJson(json["info"]),
        pages: List<Page>.from(json["pages"].map((x) => Page.fromJson(x))),
        comments: List<Comment>.from(
            json["comments"].map((x) => Comment.fromJson(x))),
        tags: List<Tag>.from(json["tags"].map((x) => Tag.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "info": info.toJson(),
        "pages": List<dynamic>.from(pages.map((x) => x.toJson())),
        "comments": List<dynamic>.from(comments.map((x) => x.toJson())),
        "tags": List<dynamic>.from(tags.map((x) => x.toJson())),
      };
}

class Comment {
  Comment({
    this.time,
    this.userName,
    this.score,
    this.comment,
  });

  String time;
  String userName;
  String score;
  String comment;

  factory Comment.fromRawJson(String str) => Comment.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
        time: json["time"],
        userName: json["userName"],
        score: json["score"],
        comment: json["comment"],
      );

  Map<String, dynamic> toJson() => {
        "time": time,
        "userName": userName,
        "score": score,
        "comment": comment,
      };
}

class Info {
  Info({
    this.gid,
    this.token,
    this.archiverKey,
    this.title,
    this.titleJpn,
    this.category,
    this.thumb,
    this.uploader,
    this.posted,
    this.filecount,
    this.filesize,
    this.expunged,
    this.rating,
    this.torrentcount,
    this.torrents,
    this.tags,
    this.url,
    this.path,
    this.ratingCount,
    this.favcount,
    this.favoritelink,
    this.error,
    this.language,
  });

  int gid;
  String token;
  String archiverKey;
  String title;
  String titleJpn;
  String category;
  String thumb;
  String uploader;
  String posted;
  String filecount;
  int filesize;
  bool expunged;
  String rating;
  String torrentcount;
  List<Torrent> torrents;
  List<String> tags;
  String url;
  String path;
  String ratingCount;
  String favcount;
  String favoritelink;
  String error;
  String language;

  factory Info.fromRawJson(String str) => Info.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Info.fromJson(Map<String, dynamic> json) => Info(
        gid: json["gid"],
        token: json["token"],
        archiverKey: json["archiver_key"],
        title: json["title"],
        titleJpn: json["title_jpn"],
        category: json["category"],
        thumb: json["thumb"],
        uploader: json["uploader"],
        posted: json["posted"],
        filecount: json["filecount"],
        filesize: json["filesize"],
        expunged: json["expunged"],
        rating: json["rating"],
        torrentcount: json["torrentcount"],
        torrents: List<Torrent>.from(
            json["torrents"].map((x) => Torrent.fromJson(x))),
        tags: List<String>.from(json["tags"].map((x) => x)),
        url: json["url"],
        path: json["path"],
        ratingCount: json["rating_count"],
        favcount: json["favcount"],
        favoritelink: json["favoritelink"],
        error: json['error'],
      );

  Map<String, dynamic> toJson() => {
        "gid": gid,
        "token": token,
        "archiver_key": archiverKey,
        "title": title,
        "title_jpn": titleJpn,
        "category": category,
        "thumb": thumb,
        "uploader": uploader,
        "posted": posted,
        "filecount": filecount,
        "filesize": filesize,
        "expunged": expunged,
        "rating": rating,
        "torrentcount": torrentcount,
        "torrents": List<dynamic>.from(torrents.map((x) => x.toJson())),
        "tags": List<dynamic>.from(tags.map((x) => x)),
        "url": url,
        "path": path,
        "rating_count": ratingCount,
        "favcount": favcount,
        "favoritelink": favoritelink,
        "error": error
      };
}

class Torrent {
  Torrent({
    this.hash,
    this.added,
    this.name,
    this.tsize,
    this.fsize,
    this.downloads,
    this.uploader,
    this.url,
  });

  String hash;
  String added;
  String name;
  String tsize;
  String fsize;
  String downloads;
  String uploader;
  String url;

  factory Torrent.fromRawJson(String str) => Torrent.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Torrent.fromJson(Map<String, dynamic> json) => Torrent(
        hash: json["hash"],
        added: json["added"],
        name: json["name"],
        tsize: json["tsize"],
        fsize: json["fsize"],
        downloads: json["Downloads"],
        uploader: json["Uploader"],
        url: json["url"],
      );

  Map<String, dynamic> toJson() => {
        "hash": hash,
        "added": added,
        "name": name,
        "tsize": tsize,
        "fsize": fsize,
        "Downloads": downloads,
        "Uploader": uploader,
        "url": url,
      };
}

class Page {
  Page({
    this.thumb,
    this.url,
  });

  Page.fromSprites({
    this.alignIndex,
    this.thumb,
    this.url,
    this.spriteWidth,
    this.spriteHeight,
  }) {
    this.sprites = true;
  }

  String thumb;

  /// 图片地址 用于获取高清图��
  String url;

  /// 高清图像链接
  String imgurl;

  /// 雪碧图标志
  bool sprites = false;

  /// 雪碧图偏移位置
  int alignIndex;

  /// 雪碧图单图总容量
  int aligntotal;

  /// 雪碧图宽度
  double spriteWidth;

  /// 雪碧图高度
  double spriteHeight;

  /// hero tag
  final String uuid = Uuid().v4();

  factory Page.fromRawJson(String str) => Page.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Page.fromJson(Map<String, dynamic> json) => Page(
        thumb: json["thumb"],
        url: json["url"],
      );

  Map<String, dynamic> toJson() => {
        "thumb": thumb,
        "url": url,
      };
}

class Tag {
  Tag({
    this.namespace,
    this.frontMatters,
    this.namespaceChs,
    this.description,
  });

  String namespace;
  List<FrontMatter> frontMatters;
  String namespaceChs;
  String description;

  factory Tag.fromRawJson(String str) => Tag.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Tag.fromJson(Map<String, dynamic> json) => Tag(
        namespace: json["namespace"],
        frontMatters: List<FrontMatter>.from(
            json["frontMatters"].map((x) => FrontMatter.fromJson(x))),
        namespaceChs: json["namespace_CHS"],
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "namespace": namespace,
        "frontMatters": List<dynamic>.from(frontMatters.map((x) => x.toJson())),
        "namespace_CHS": namespaceChs,
        "description": description,
      };
}

class FrontMatter {
  FrontMatter({
    this.name,
    this.keyword,
    this.dash,
    this.nameChs,
    this.intro,
  });

  String name;
  String keyword;
  bool dash;
  String nameChs;
  String intro;

  factory FrontMatter.fromRawJson(String str) =>
      FrontMatter.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory FrontMatter.fromJson(Map<String, dynamic> json) => FrontMatter(
        name: json["name"],
        keyword: json["keyword"],
        dash: json["dash"],
        nameChs: json["name_CHS"],
        intro: json["intro"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "keyword": keyword,
        "dash": dash,
        "name_CHS": nameChs,
        "intro": intro,
      };
}

class GdataRes {
  GdataRes({
    this.gmetadata,
  });

  List<Info> gmetadata;

  factory GdataRes.fromRawJson(String str) =>
      GdataRes.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GdataRes.fromJson(Map<String, dynamic> json) => GdataRes(
        gmetadata:
            List<Info>.from(json["gmetadata"].map((x) => Info.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "gmetadata": List<dynamic>.from(gmetadata.map((x) => x.toJson())),
      };
}

class OtherInfo {
  OtherInfo({
    this.ratingCount,
    this.favcount,
    this.favoritelink,
    this.language,
  });

  String ratingCount;
  String favcount;
  String favoritelink;
  String language;

  OtherInfo copyWith({
    String ratingCount,
    String favcount,
    String favoritelink,
  }) =>
      OtherInfo(
        ratingCount: ratingCount ?? this.ratingCount,
        favcount: favcount ?? this.favcount,
        favoritelink: favoritelink ?? this.favoritelink,
      );
}
