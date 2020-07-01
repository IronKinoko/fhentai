import 'dart:convert';

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
    this.time,
    this.url,
    this.path,
    this.ratingCount,
    this.favcount,
    this.favoritelink,
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
  String filesize;
  bool expunged;
  String rating;
  String torrentcount;
  List<Torrent> torrents;
  List<String> tags;
  String time;
  String url;
  String path;
  String ratingCount;
  String favcount;
  String favoritelink;

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
        time: json["time"],
        url: json["url"],
        path: json["path"],
        ratingCount: json["rating_count"],
        favcount: json["favcount"],
        favoritelink: json["favoritelink"],
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
        "time": time,
        "url": url,
        "path": path,
        "rating_count": ratingCount,
        "favcount": favcount,
        "favoritelink": favoritelink,
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

  String thumb;
  String url;

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
