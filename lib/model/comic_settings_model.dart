import 'dart:convert';

import 'package:fhentai/common/global.dart';
import 'package:flutter/material.dart';

class ComicSettingsModel extends ChangeNotifier {
  ComicSettings _comicSettings;

  ComicSettings get comicSettings {
    if (_comicSettings == null) {
      _comicSettings = ComicSettings.fromRawJson(
          Global.prefs.getString(PREFS_COMIC_SETTINGS));
    }
    return _comicSettings;
  }

  void saveSettings() {
    Global.prefs.setString(PREFS_COMIC_SETTINGS, comicSettings.toRawJson());
  }
}

enum ComicDirection { Horizontal, Vertical, HorizontalReverse }

class ComicSettings {
  ComicSettings({
    this.direction = ComicDirection.Vertical,
  });

  final ComicDirection direction;

  factory ComicSettings.fromRawJson(String str) =>
      ComicSettings.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ComicSettings.fromJson(Map<String, dynamic> json) => ComicSettings(
        direction: ComicDirection.values[json["direction"]],
      );

  Map<String, dynamic> toJson() => {
        "direction": direction.index,
      };
}
