class Article {
  final String text;
  final String url;
  final String by;
  final String age;
  final int score;
  final int commentsCount;

  const Article({
    this.text,
    this.url,
    this.by,
    this.age,
    this.score,
    this.commentsCount
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    if (json == null)
      return null;

    return Article(
      text: json['text'] ?? '[null]',
      url: json['url'],
      by: json['by'],
      age: json['age'] ?? 0,
      score: json['score'] ?? 0
    );
  }
}

final articles = [
  new Article(
    text: "Article One",
    url: "wiley.com",
    by: "zdw",
    age: "2 days",
    score: 100,
    commentsCount: 5
  ),
  new Article(
    text: "Article Two",
    url: "wiley.com",
    by: "Amber",
    age: "2 days",
    score: 120,
    commentsCount: 3
  ),
  new Article(
    text: "Article Three",
    url: "wiley.com",
    by: "oscar",
    age: "4 days",
    score: 80,
    commentsCount: 2
  )
];