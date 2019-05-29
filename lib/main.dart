import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:hackernews/src/article_search.dart';
import 'package:hackernews/src/hn_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:collection/collection.dart';
import 'package:hackernews/src/article.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

void main() {
  final hnBloc = HackerNewsBloc();
  runApp(MyApp(bloc: hnBloc));
}

class MyApp extends StatelessWidget {
  final HackerNewsBloc bloc;

  MyApp({
    Key key,
    this.bloc,
  }) : super(key: key);

  static const primaryColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
          primaryColor: primaryColor,
          scaffoldBackgroundColor: primaryColor,
          canvasColor: Colors.black,
          textTheme: Theme.of(context).textTheme.copyWith(
              caption: TextStyle(color: Colors.white54),
              subhead: TextStyle(fontFamily: 'Garamond', fontSize: 10.0))),
      darkTheme: ThemeData(
        textTheme: Theme.of(context).textTheme.copyWith(
            caption: TextStyle(color: Colors.white54),
            subhead: TextStyle(fontFamily: 'Garamond', fontSize: 10.0)),
        brightness: Brightness.dark,
      ),
      home: MyHomePage(title: 'Flutter Hacker News', bloc: this.bloc),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final HackerNewsBloc bloc;

  MyHomePage({Key key, this.title, this.bloc}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: LoadingInfo(widget.bloc.isLoading),
        title: Text(widget.title),
        elevation: 0.0,
        actions: <Widget>[
          Builder(
            builder: (context) => IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () async {
                    final selectedArticle = await showSearch(
                        context: context,
                        delegate: ArticleSearch(widget.bloc.articles));
                    if (selectedArticle != null) {
                      openWebsite(selectedArticle.url);
                    }
                  },
                ),
          )
        ],
      ),
      body: StreamBuilder<UnmodifiableListView<Article>>(
        stream: widget.bloc.articles,
        initialData: UnmodifiableListView<Article>([]),
        builder: (context, snapshot) =>
            ListView(children: snapshot.data.map(_buildItem).toList()),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        items: [
          BottomNavigationBarItem(
              title: Text('Top Stories'), icon: Icon(Icons.priority_high)),
          BottomNavigationBarItem(
              title: Text('New Stories'), icon: Icon(Icons.new_releases))
        ],
        onTap: (index) {
          if (index == 0) {
            widget.bloc.storiesType.add(StoriesType.topStories);
          } else {
            widget.bloc.storiesType.add(StoriesType.newStories);
          }
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }

  Widget _buildItem(Article article) {
    return Padding(
        key: Key(article.text),
        padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 12.0),
        child: ExpansionTile(
          title: Text(article.title, style: new TextStyle(fontSize: 24.0)),
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text('${article.descendants} comments'),
                  SizedBox(
                    width: 16.0,
                  ),
                  IconButton(
                    icon: Icon(Icons.launch),
                    onPressed: () async {
                      openWebsite(article.url);
                    },
                    color: Theme.of(context).accentColor,
                  )
                ],
              ),
            ),
          ],
        ));
  }

  Future<void> openWebsite(String url) async {
    if (await canLaunch(url)) {
      await launch(url, forceWebView: true);
    }
  }
}

class LoadingInfo extends StatefulWidget {
  final Stream<bool> _isLoading;

  LoadingInfo(this._isLoading);

  @override
  _LoadingInfoState createState() => _LoadingInfoState();
}

class _LoadingInfoState extends State<LoadingInfo>
    with TickerProviderStateMixin {
  AnimationController _controller;

  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: widget._isLoading,
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.hasData && snapshot.data) {
            _controller.repeat(reverse: true);
          } else {
            return Icon(FontAwesomeIcons.hackerNews);
          }
          return FadeTransition(
            child: Icon(FontAwesomeIcons.hackerNews),
            opacity: Tween(begin: 0.25, end: 1.0).animate(
                CurvedAnimation(curve: Curves.easeIn, parent: _controller)),
          );
        });
  }
}
