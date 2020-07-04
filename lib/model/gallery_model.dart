import 'dart:convert';
import 'dart:math';

import 'package:fhentai/common/global.dart';
import 'package:fhentai/views/gallery.dart';
import 'package:flutter/material.dart';

class ResponseGalerry {
  List<GalleryInfo> list;
  int total;
  bool isHistories = false;

  ResponseGalerry(this.list, this.total, {this.isHistories});

  factory ResponseGalerry.getFromHistories() {
    List<String> jsonStrList;
    jsonStrList = Global.prefs.getStringList(PREFS_HISTORIES) ?? [];

    List<GalleryInfo> list = jsonStrList.map((jsonStr) {
      return GalleryInfo.fromRawJson(jsonStr);
    }).toList();
    int total = list.length;

    return ResponseGalerry(list, total, isHistories: true);
  }

  /// must use `ResponseGalerry.getfromHistories();`
  void pushToHistories(GalleryInfo record) {
    assert(isHistories, 'must use ResponseGalerry.getfromHistories()');
    list.removeWhere((o) => o.gid == record.gid);
    list.insert(0, record);
    total = min(list.length, Global.prefs.getInt(PREFS_HISTORIES_MAX_LENGTH));
    list = list.sublist(0, total);
    List<String> jsonStrList = list.map((e) => e.toRawJson()).toList();
    Global.prefs.setStringList(PREFS_HISTORIES, jsonStrList);
  }

  void clear() {
    Global.prefs.setStringList(PREFS_HISTORIES, []);
  }
}
// To parse this JSON data, do
//
//     final galleryInfo = galleryInfoFromJson(jsonString);

class GalleryInfo {
  GalleryInfo({
    this.title,
    this.category,
    this.time,
    this.rating,
    this.url,
    this.uploader,
    this.filecount,
    this.gid,
    this.token,
    this.thumb,
  });

  final String title;
  final String category;
  final String time;
  final double rating;
  final String url;
  final String uploader;
  final int filecount;
  final String gid;
  final String token;
  final String thumb;

  factory GalleryInfo.fromRawJson(String str) =>
      GalleryInfo.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GalleryInfo.fromJson(Map<String, dynamic> json) => GalleryInfo(
        title: json["title"],
        category: json["category"],
        time: json["time"],
        rating: json["rating"].toDouble(),
        url: json["url"],
        uploader: json["uploader"],
        filecount: json["filecount"],
        gid: json["gid"],
        token: json["token"],
        thumb: json["thumb"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "category": category,
        "time": time,
        "rating": rating,
        "url": url,
        "uploader": uploader,
        "filecount": filecount,
        "gid": gid,
        "token": token,
        "thumb": thumb,
      };
}

class GalleryModel extends ChangeNotifier {
  Map<GalleryMode, ResponseGalerry> _galleryCacheMap = {};

  ResponseGalerry getGalleryList(GalleryMode mode) => _galleryCacheMap[mode];

  void setGalleryList(GalleryMode mode, ResponseGalerry galleryList) {
    _galleryCacheMap[mode] = galleryList;
  }
}
