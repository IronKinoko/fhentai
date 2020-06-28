import 'package:flutter/material.dart';

class ColorCategory extends StatelessWidget {
  final String category;

  const ColorCategory(
    this.category, {
    Key key,
  }) : super(key: key);

  Color getColor() {
    Color color;
    switch (category) {
      case 'Doujinshi':
        color = Color(0xFF9E2720);
        break;
      case 'Manga':
        color = Color(0xFFDB6C24);
        break;
      case 'Artist CG':
        color = Color(0xFFD38F1D);
        break;
      case 'Game CG':
        color = Color(0xFF6A936D);
        break;
      case 'Western':
        color = Color(0xFFAB9F60);
        break;
      case 'Non-H':
        color = Color(0xFF5FA9CF);
        break;
      case 'Image Set':
        color = Color(0xFF325CA2);
        break;
      case 'Cosplay':
        color = Color(0xFF6A32A2);
        break;
      case 'Asian Porn':
        color = Color(0xFFA23282);
        break;
      case 'Misc':
        color = Color(0xFF777777);
        break;
      default:
    }
    return color;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: getColor(),
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Text(
        category,
        style: TextStyle(color: Colors.white, fontSize: 14),
      ),
    );
  }
}
