import 'package:fhentai/common/global.dart';
import 'package:fhentai/generated/i18n.dart';
import 'package:fhentai/views/gallery.dart';
import 'package:flutter/material.dart';

class BNavigation extends StatelessWidget {
  final GalleryMode current;
  final Function(int value, GalleryMode mode) onChange;
  const BNavigation(this.current, {Key key, @required this.onChange})
      : assert(onChange != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<BarItem> list = [
      BarItem(
        I18n.of(context).Front_Page,
        Icon(Icons.home),
        GalleryMode.FrontPage,
      ),
      BarItem(
        I18n.of(context).Watched,
        Icon(Icons.subscriptions),
        GalleryMode.Watched,
      ),
      BarItem(
        I18n.of(context).Popular,
        Icon(Icons.whatshot),
        GalleryMode.Popular,
      ),
      BarItem(I18n.of(context).Favorites, Icon(Icons.favorite),
          GalleryMode.Favorites),
      BarItem(I18n.of(context).Histories, Icon(Icons.history),
          GalleryMode.Histories),
    ];
    return BottomNavigationBar(
      selectedItemColor: Theme.of(context).colorScheme.primary,
      unselectedItemColor: Colors.grey,
      type: BottomNavigationBarType.fixed,
      currentIndex: current.index,
      onTap: (index) {
        onChange(index, list[index].mode);
      },
      items: [
        ...list.map(
          (e) => BottomNavigationBarItem(
            icon: e.icon,
            title: Text(e.title),
          ),
        )
      ],
    );
  }
}

class BarItem {
  String title;
  Widget icon;
  GalleryMode mode;
  BarItem(this.title, this.icon, this.mode);
}
