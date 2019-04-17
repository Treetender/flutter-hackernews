import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'src/article.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as json;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.dark,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<int> _ids = [];

  Future<Article> _getArticle(int id) async {
    final storyUrl = 'https://hacker-news.firebaseio.com/v0/item/$id.json';
    final storyRes = await http.get(storyUrl);

    if (storyRes.statusCode == 200) {
      return parseArticle(storyRes.body);
    }
    return null;
  }

  Future<void> _getTopStoryIds() async {
    final idsUrl = 'https://hacker-news.firebaseio.com/v0/topstories.json';
    final idsRes = await http.get(idsUrl);

    if (idsRes.statusCode == 200) {
      var ids = List<int>.from(json.jsonDecode(idsRes.body));
      setState(() {
        _ids = ids;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: RefreshIndicator(
        onRefresh: _getTopStoryIds,
        child: ListView(
          children: _ids
              .map((i) => FutureBuilder<Article>(
                    future: _getArticle(i),
                    builder: (BuildContext context,
                        AsyncSnapshot<Article> snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return _buildItem(snapshot.data);
                      } else {
                        return Center(child: CircularProgressIndicator());
                      }
                    },
                  ))
              .toList(),
        ),
      ),
    );
  }

  Widget _buildItem(Article article) {
    return Padding(
        key: Key(article.text),
        padding: const EdgeInsets.all(8.0),
        child: ExpansionTile(
          title: Text(article.title, style: new TextStyle(fontSize: 24.0)),
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text('${article.descendants} comments'),
                IconButton(
                  icon: Icon(Icons.launch),
                  onPressed: () async {
                    if (await canLaunch(article.url)) {
                      await launch(article.url, forceWebView: true);
                    }
                  },
                  color: Theme.of(context).accentColor,
                )
              ],
            ),
          ],
        ));
  }
}
