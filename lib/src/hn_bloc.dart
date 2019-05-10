import 'dart:async';
import 'dart:collection';

import 'package:hackernews/src/article.dart';
import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart' as http;

enum StoriesType {
  topStories,
  newStories,
}

class HackerNewsBloc {

  Sink<StoriesType> get storiesType => _storiesTypeController.sink;
  Stream<UnmodifiableListView<Article>> get articles => _articlesSubject.stream;

  final _articlesSubject = BehaviorSubject<UnmodifiableListView<Article>>();
  final _storiesTypeController = StreamController<StoriesType>();

  var _articles = <Article>[];

  HackerNewsBloc() {
    _getArticlesAndUpdate(_topIds);

    _storiesTypeController.stream.listen((storiesType) {
        if(storiesType == StoriesType.newStories) {
          _getArticlesAndUpdate(_newIds);
        } else {
          _getArticlesAndUpdate(_topIds);
        }
    });
  }

  static List<int> _newIds = [
    17392995,
    17397852,
    17395342,
    17385291,
    17395675,

  ];

  static List<int> _topIds = [
    17387438,
    17393560,
    17391971,
    17392455
  ];

  _getArticlesAndUpdate(List<int> ids) {
    _getArticles(ids).then((_) {
      _articlesSubject.add(UnmodifiableListView(_articles));
    });
  }

  Future<Null> _getArticles(List<int> ids) async {
     final futureArticles = ids.map((id) => _getArticle(id));
     final articles = await Future.wait(futureArticles);
     _articles = articles;
  }

  Future<Article> _getArticle(int id) async {
    final storyUrl = 'https://hacker-news.firebaseio.com/v0/item/$id.json';
    final storyRes = await http.get(storyUrl);

    if (storyRes.statusCode == 200) {
      return parseArticle(storyRes.body);
    }
    return null;
  }

}