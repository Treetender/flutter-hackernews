class Article {
  final String text;
  final String domain;
  final String by;
  final String age;
  final int score;
  final int commentsCount;

  const Article({
    this.text,
    this.domain,
    this.by,
    this.age,
    this.score,
    this.commentsCount
  });
}

final articles = [
  new Article(
    text: "Article One",
    domain: "wiley.com",
    by: "zdw",
    age: "2 days",
    score: 100,
    commentsCount: 5
  ),
  new Article(
    text: "Article Two",
    domain: "wiley.com",
    by: "Amber",
    age: "2 days",
    score: 120,
    commentsCount: 3
  ),
  new Article(
    text: "Article Three",
    domain: "wiley.com",
    by: "oscar",
    age: "4 days",
    score: 80,
    commentsCount: 2
  )
];