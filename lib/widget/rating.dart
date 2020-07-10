import 'package:flutter/material.dart';

class Rating extends StatelessWidget {
  final double rating;
  Color color;

  Rating(this.rating, {Key key, this.color}) : super(key: key);

  Icon _getIcon(IconData icon) {
    return Icon(
      icon,
      color: color ?? Color(0xfff9a825),
      size: 18,
    );
  }

  Widget buildStar() {
    var full = (rating).floor();
    var half = (rating - rating.floor()) > 0 && (rating - rating.floor()) < 1;
    List<Widget> list = [];

    for (var i = 0; i < full; i++) {
      list.add(_getIcon(Icons.star));
    }
    if (half) {
      list.add(_getIcon(Icons.star_half));
    }
    for (var i = 0; i < (5 - rating).floor(); i++) {
      list.add(_getIcon(Icons.star_border));
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: list,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(child: buildStar());
  }
}
