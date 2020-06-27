import 'package:flutter/material.dart';

class ResponseGalerry {
  final List<GalleryInfo> list;
  final int total;

  ResponseGalerry(this.list, this.total);
}

class GalleryInfo {
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

  GalleryInfo({
    this.title,
    this.category,
    this.time,
    this.rating,
    this.url,
    this.uploader,
    this.filecount,
    @required this.gid,
    @required this.token,
    this.thumb,
  })  : assert(gid != null),
        assert(token != null);
}

class GalleryModel extends ChangeNotifier {
  List<GalleryInfo> _galleryList = [];

  List<GalleryInfo> get galleryList => _galleryList;

  set galleryList(List<GalleryInfo> galleryList) {
    _galleryList = galleryList;
    notifyListeners();
  }
}
