import 'package:flutter/material.dart';
import 'package:hackernews/src/hn_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:collection/collection.dart';
import 'package:hackernews/src/article.dart';


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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.dark,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page', bloc: this.bloc),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: StreamBuilder<UnmodifiableListView<Article>>(
        stream: widget.bloc.articles,
        initialData: UnmodifiableListView<Article>([]),
        builder: (context, snapshot) => ListView(
          children: snapshot.data.map(_buildItem).toList()
        ),
      )
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
