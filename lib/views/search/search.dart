import 'dart:io';
import 'dart:math';
import 'package:fhentai/views/search/search_result.dart';
import 'package:flutter/material.dart';

class SearchPage extends SearchDelegate<String> {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.search),
        tooltip: MaterialLocalizations.of(context).searchFieldLabel,
        onPressed: () {
          showResults(context);
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return BackButton();
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container(
      child: null,
    );
  }

  @override
  void showResults(BuildContext context) {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => SearchResult(
            fSearch: query,
          ),
        ));
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) => ListTile(
        onTap: () {},
        leading: Icon(Icons.history),
        title: Text('text'),
        trailing: Transform.rotate(
          angle: pi / 4,
          child: Icon(Icons.arrow_back),
        ),
      ),
      itemCount: 10,
    );
  }
}
