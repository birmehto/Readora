import '../../domain/entities/favorite_article.dart';

class FavoriteArticleModel extends FavoriteArticle {
  const FavoriteArticleModel({
    required super.title,
    required super.url,
    required super.visitedAt,
    super.author,
    super.domain,
    super.imageUrl,
  });

  factory FavoriteArticleModel.fromJson(Map<String, dynamic> json) {
    return FavoriteArticleModel(
      title: json['title'] ?? '',
      url: json['url'] ?? '',
      visitedAt: DateTime.tryParse(json['visitedAt'] ?? '') ?? DateTime.now(),
      author: json['author'],
      domain: json['domain'],
      imageUrl: json['imageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'url': url,
      'visitedAt': visitedAt.toIso8601String(),
      'author': author,
      'domain': domain,
      'imageUrl': imageUrl,
    };
  }
}
