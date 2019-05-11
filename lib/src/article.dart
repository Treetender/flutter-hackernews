
import 'package:built_value/built_value.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/serializer.dart';
import 'serializers.dart';
import 'dart:convert' as json;

part 'article.g.dart';

List<int> parseTopStories(String jsonStr) => List<int>.from(json.jsonDecode(jsonStr));
Article parseArticle(String jsonStr)  {
  final parsed = json.jsonDecode(jsonStr);
  return standardSerializers.deserializeWith(Article.serializer, parsed);
}

abstract class Article implements Built<Article, ArticleBuilder> {

  static Serializer<Article> get serializer => _$articleSerializer;

  ///The item's unique id.
  int get id;	
  
  ///true if the item is deleted.
  @nullable
  bool get deleted; 
  
  ///The type of item. One of "job", "story", "comment", "poll", or "pollopt"
  @nullable
  String get type;
  
  ///	The username of the item's author.
  String get by; 
  
  ///	Creation date of the item, in Unix Time.
  int get time; 
  
  ///	The comment, story or poll text. HTML.
  @nullable
  String get text; 
  
  //	true if the item is dead.
  @nullable
  bool get dead; 
  
  ///	The comment's parent: either another comment or the relevant story.
  @nullable
  int get parent; 
  
  ///The pollopt's associated poll.
  @nullable
  int get poll;	
  
  ///	The ids of the item's comments, in ranked display order.
  BuiltList<int> get kids; 
  
  /// The URL of the story.
  @nullable
  String get url; 
  
  ///The story's score, or the votes for a pollopt.
  int get score; 
  
  ///	The title of the story, poll or job.
  @nullable
  String get title; 
  
  ///	A list of related pollopts, in display order.
  BuiltList<int> get parts; 
  
  ///	In the case of stories or polls, the total comment count.
  @nullable
  int get descendants; 

  Article._();
  factory Article([updates(ArticleBuilder b)]) = _$Article;
}