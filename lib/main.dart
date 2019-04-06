import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'src/article.dart';

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
  List<Article> _articles = articles;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: RefreshIndicator(
        child: ListView(
          children: _articles.map(_buildItem).toList(),
        ),
        onRefresh: () async {
          return Future.delayed(const Duration(seconds: 2));
        },
      ),
    );
  }

  Widget _buildItem(Article article) {
    return Padding(
        key: Key(article.text),
        padding: const EdgeInsets.all(8.0),
        child: ExpansionTile(
          title: Text(article.text, style: new TextStyle(fontSize: 24.0)),
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text("${article.commentsCount} comments"),
                IconButton(
                  icon: Icon(Icons.launch),
                  onPressed: () async {
                    final url = "http://${article.url}";
                    if (await canLaunch(url)) {
                      await launch(url, forceWebView: true);
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
