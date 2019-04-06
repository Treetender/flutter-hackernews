import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'src/article.dart';
import 'package:http/http.dart' as http;

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
  List<int> _ids = [
    19588996,
    19583384,
    19584921,
    19584540,
    19588852,
    19584005,
    19585033,
    19588017,
    19588744,
    19584509,
    19588395,
    19585174,
    19588961,
    19582774,
    19584440,
    19561274,
    19581721,
    19577832,
    19567962,
    19585640,
    19586219,
    19588812,
    19587782,
    19583531
  ];

  Future<Article> _getArticle(int id) async {
    final storyUrl = 'https://hacker-news.firebaseio.com/v0/item/${id}.json';
        final storyRes = await http.get(storyUrl);

        if (storyRes.statusCode == 200) {
          return parseArticle(storyRes.body);
        }
      return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView(
        children: _ids.map((i) => FutureBuilder<Article>(
          future: _getArticle(i),
          builder: (BuildContext context, AsyncSnapshot<Article> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return _buildItem(snapshot.data);
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },)
        ).toList(),
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
