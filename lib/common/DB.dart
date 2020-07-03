import 'package:fhentai/model/db_model.dart';
import 'package:flutter/services.dart';

Future<String> loadAsset() async {
  return await rootBundle.loadString('assets/config.json');
}

class DB {
  static TagDb _db;

  static TagDb get db => _db;
  Future<void> init() async {
    String jsonStr = await rootBundle.loadString('assets/db.text.json');
    _db = TagDb.fromRawJson(jsonStr);
  }
}
