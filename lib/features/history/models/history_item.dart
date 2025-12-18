class HistoryItem {
  HistoryItem({
    required this.title,
    required this.url,
    required this.visitedAt,
  });

  factory HistoryItem.fromJson(Map<String, dynamic> json) {
    return HistoryItem(
      title: json['title'] ?? '',
      url: json['url'] ?? '',
      visitedAt: DateTime.tryParse(json['visitedAt'] ?? '') ?? DateTime.now(),
    );
  }
  final String title;
  final String url;
  final DateTime visitedAt;

  Map<String, dynamic> toJson() => {
    'title': title,
    'url': url,
    'visitedAt': visitedAt.toIso8601String(),
  };
}
