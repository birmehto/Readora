class FavoriteArticle {
  const FavoriteArticle({
    required this.title,
    required this.url,
    required this.visitedAt,
    this.author,
    this.domain,
    this.imageUrl,
  });
  final String title;
  final String url;
  final DateTime visitedAt;
  final String? author;
  final String? domain;
  final String? imageUrl;
}
