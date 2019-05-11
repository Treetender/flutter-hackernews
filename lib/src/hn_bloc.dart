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

  Stream<bool> get isLoading => _isLoadingSubject.stream;
  Sink<StoriesType> get storiesType => _storiesTypeController.sink;
  Stream<UnmodifiableListView<Article>> get articles => _articlesSubject.stream;
  
  final _isLoadingSubject = BehaviorSubject<bool>(seedValue: false);
  final _articlesSubject = BehaviorSubject<UnmodifiableListView<Article>>();
  final _storiesTypeController = StreamController<StoriesType>();

  var _articles = <Article>[];

  HackerNewsBloc() {
    _initializeArticles();

    _storiesTypeController.stream.listen((storiesType) async {
      _getArticlesAndUpdate(await _getIds(storiesType));
    });
  }

  Future<void> _initializeArticles() async {
    _getArticlesAndUpdate(await _getIds(StoriesType.topStories));
  }

  void dispose() {
    _storiesTypeController.close();
    _isLoadingSubject.close();
    _articlesSubject.close();
  }

  static const _baseUrl = "https://hacker-news.firebaseio.com/v0/";

  Future<List<int>> _getIds(StoriesType type) async {
     final partUrl = type == StoriesType.topStories ? 'top' : 'new'; 
     final url = "$_baseUrl${partUrl}stories.json";

     final response = await http.get(url);

     if(response.statusCode != 200) {
       throw HackerNewsApiError('Failed to get $partUrl stories');
     }

     return parseTopStories(response.body);

  }

  _getArticlesAndUpdate(List<int> ids) async {
    _isLoadingSubject.add(true);
    await _getArticles(ids);
    _articlesSubject.add(UnmodifiableListView(_articles));
    _isLoadingSubject.add(false);
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
    throw HackerNewsApiError('Failed to get artcile $id');
  }

}

class HackerNewsApiError extends Error {
  final String message;

  HackerNewsApiError(this.message);
}