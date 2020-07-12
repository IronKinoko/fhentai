import 'dart:math';

import 'package:fhentai/common/global.dart';
import 'package:fhentai/generated/i18n.dart';
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
      height: MediaQuery.of(context).size.height * 0.6,
      child: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.error,
            size: 48,
          ),
          SizedBox(height: 16),
          Text(I18n.of(context).SearchShort),
        ],
      )),
    );
  }

  @override
  void showResults(BuildContext context) {
    if (query.length < 3) {
      return super.showResults(context);
    }
    jump(context, query);
  }

  void jump(BuildContext context, String fSearch) {
    save(fSearch);
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => SearchResult(
            fSearch: fSearch,
          ),
        ));
  }

  void save(String fSearch) {
    suggestionsList.removeWhere((element) => element == fSearch);
    suggestionsList.insert(0, fSearch);
    Global.prefs.setStringList(PREFS_SUGGESTIONS, suggestionsList);
  }

  void remove(int index) {
    suggestionsList.removeAt(index);
    Global.prefs.setStringList(PREFS_SUGGESTIONS, suggestionsList);
  }

  final List<String> suggestionsList =
      Global.prefs.getStringList(PREFS_SUGGESTIONS) ?? [];

  @override
  Widget buildSuggestions(BuildContext context) {
    return StatefulBuilder(
      builder: (context, setState) {
        final List<String> currentSuggestions =
            suggestionsList.where((o) => o.contains(query)).toList();

        return ListView.builder(
          itemBuilder: (context, index) => ListTile(
            onTap: () {
              jump(context, currentSuggestions[index]);
            },
            onLongPress: () {
              remove(index);
              setState(() {});
            },
            leading: Icon(Icons.history),
            title: Text(currentSuggestions[index]),
            trailing: Transform.rotate(
              angle: pi / 4,
              child: Icon(Icons.arrow_back),
            ),
          ),
          itemCount: currentSuggestions.length,
        );
      },
    );
  }
}
