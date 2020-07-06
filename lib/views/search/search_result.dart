import 'package:fhentai/views/gallery.dart';
import 'package:flutter/material.dart';

class SearchResult extends StatefulWidget {
  final String fSearch;

  const SearchResult({Key key, @required this.fSearch}) : super(key: key);

  @override
  _SearchResultState createState() => _SearchResultState();
}

class _SearchResultState extends State<SearchResult> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GalleryList(
        fSearch: widget.fSearch,
        isSearch: true,
      ),
    );
  }
}
