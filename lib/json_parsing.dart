
import 'dart:convert' as json;

List<int> parseTopStories(String jsonStr) => List<int>.from(json.jsonDecode(jsonStr));

Article parseArticle(String jsonStr) {
  final parsed = json.jsonDecode(jsonStr);

  Article article = Article.fromJson(parsed);
  return article;
}

class Article {
  final String text;
  final String url;
  final String by;
  final int timestamp;
  final int score;

  const Article({
    this.text,
    this.url,
    this.by,
    this.timestamp,
    this.score,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    if (json == null)
      return null;

    return Article(
      text: json['title'] ?? '[null]',
      url: json['url'],
      by: json['by'],
      score: json['score'],
      timestamp: json['time']
    );
  }
}