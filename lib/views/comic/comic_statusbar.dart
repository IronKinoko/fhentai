import 'package:flutter/material.dart';

class ComicStatusBar extends StatefulWidget {
  ComicStatusBar({this.index, this.total});

  final int index;
  final int total;

  @override
  _ComicStatusBarState createState() => _ComicStatusBarState();
}

class _ComicStatusBarState extends State<ComicStatusBar> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8).copyWith(left: 16),
      decoration: BoxDecoration(
        color: Colors.black38,
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(16), topLeft: Radius.circular(16)),
      ),
      child: Row(
        children: <Widget>[
          Text(
            '${(widget.index ?? 0) + 1} / ${widget.total}',
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
