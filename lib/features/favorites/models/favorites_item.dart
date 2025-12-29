class FavoriteItem {
  FavoriteItem({
    required this.title,
    required this.url,
    required this.visitedAt,
    this.author,
    this.domain,
    this.imageUrl,
  });

  factory FavoriteItem.fromJson(Map<String, dynamic> json) {
    return FavoriteItem(
      title: json['title'] ?? '',
      url: json['url'] ?? '',
      visitedAt: DateTime.tryParse(json['visitedAt'] ?? '') ?? DateTime.now(),
      author: json['author'],
      domain: json['domain'],
      imageUrl: json['imageUrl'],
    );
  }
  final String title;
  final String url;
  final DateTime visitedAt;
  final String? author;
  final String? domain;
  final String? imageUrl;


}
