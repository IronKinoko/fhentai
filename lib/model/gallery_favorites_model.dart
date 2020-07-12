import 'package:fhentai/apis/gallery.dart';
import 'package:fhentai/common/global.dart';
import 'package:flutter/material.dart';

class FavoritesModel extends ChangeNotifier {
  List<FavoritesInfo> _list;
  BuildContext context;

  FavoritesModel(this.context);

  List<FavoritesInfo> get list => _list;

  updateTotalList(List<FavoritesInfo> newList) {
    _list = newList;
    notifyListeners();
  }

  Future<void> getRemoteInfo() async {
    if (_list != null || !Global.isSignin) return;
    updateTotalList(await getFevoritesInfo());
  }

  Future<void> addFavorites(int gid, String token, String favcat) async {
    await updateFavorite(gid, token, favcat);

    _list.firstWhere((element) => element.favIndex == favcat).count++;

    notifyListeners();
  }

  Future<void> removeFavorites(
      int gid, String token, String favoritelink) async {
    await updateFavorite(gid, token, 'favdel');
    _list.firstWhere((element) => element.favName == favoritelink).count--;
    notifyListeners();
  }
}

class FavoritesInfo {
  String favName;
  int count;
  String favIndex;

  FavoritesInfo({this.count, this.favIndex, this.favName});

  FavoritesInfo copyWith({
    String favName,
    int count,
    String favIndex,
  }) =>
      FavoritesInfo(
        favName: favName ?? this.favName,
        count: count ?? this.count,
        favIndex: favIndex ?? this.favIndex,
      );
  @override
  String toString() {
    return '$favName $count $favIndex';
  }
}
