import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:hackernews/src/article.dart';

class ArticleSearch extends SearchDelegate<Article> {
  final Stream<UnmodifiableListView<Article>> articles;
  final _pastSearches = List<String>();

  ArticleSearch(this.articles);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: Icon(Icons.delete),
          onPressed: () {
            query = '';
            showSuggestions(context);
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.close),
        onPressed: () {
          close(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    return StreamBuilder<UnmodifiableListView<Article>>(
        stream: articles,
        builder:
            (context, AsyncSnapshot<UnmodifiableListView<Article>> snapshot) {
          if ((query?.length ?? 0) > 0 && !_pastSearches.contains(query)) {
            _pastSearches.add(query);
          }

          if (_pastSearches.length > 5) {
            _pastSearches.removeAt(5);
          }

          if (!snapshot.hasData) {
            return Center(
              child: Text('No articles!'),
            );
          }

          final results = snapshot.data.where(
              (a) => a.title.toLowerCase().contains(query.toLowerCase()));

          return ListView(
            children: results
                .map<Widget>((a) => ListTile(
                    title: Text(
                      a.title ?? '',
                      style: Theme.of(context).textTheme.headline,
                    ),
                    leading: Icon(Icons.launch),
                    dense: false,
                    onTap: () {
                      close(context, a);
                    }))
                .toList(),
          );
        });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return StreamBuilder<UnmodifiableListView<Article>>(
        stream: articles,
        builder:
            (context, AsyncSnapshot<UnmodifiableListView<Article>> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: Text('No articles!'),
            );
          }

          final results = snapshot.data.where(
              (a) => a.title.toLowerCase().contains(query.toLowerCase()));

          final searchWidgets = _pastSearches
              .map((s) => ListTile(
                  title: Text(
                    s,
                    style: Theme.of(context)
                        .textTheme
                        .subhead
                        .copyWith(fontSize: 16.0),
                  ),
                  dense: true,
                  leading: Icon(Icons.history),
                  onTap: () {
                    query = s;
                    showResults(context);
                  }))
              .toList();

          searchWidgets.addAll(results
              .map((a) => ListTile(
                    title: Text(a.title,
                        style: Theme.of(context)
                            .textTheme
                            .subhead
                            .copyWith(fontSize: 16.0, color: Colors.blue)),
                    leading: Icon(Icons.launch),
                    dense: true,
                    onTap: () async {
                      close(context, a);
                    },
                  ))
              .toList());

          return ListView(children: searchWidgets);
        });
  }
}
