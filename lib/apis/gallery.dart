import 'package:dio/dio.dart';
import 'package:fhentai/common/global.dart';
import 'package:fhentai/model/gallery_model.dart';
import './parser/gallery_parser.dart';

Future<ResponseGalerry> galleryList({int page, String fSearch = ''}) async {
  try {
    Response res = await Global.dio
        .get(Uri.encodeFull('/?inline_set=dm_l&page=$page&f_search=$fSearch'));

    return parseGalleryList(res.data);
  } catch (e) {
    throw Exception('load Error');
  }
}
