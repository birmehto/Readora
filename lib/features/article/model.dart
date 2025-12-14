import 'package:equatable/equatable.dart';

class Article extends Equatable {
  final String title;
  final String author;
  final String content;
  final String? subtitle;
  final DateTime? publishedDate;
  final String originalUrl;
  final String? imageUrl;
  final String? authorImageUrl;
  final int? readingTime;
  final List<String> tags;

  const Article({
    required this.title,
    required this.author,
    required this.content,
    this.subtitle,
    this.publishedDate,
    required this.originalUrl,
    this.imageUrl,
    this.authorImageUrl,
    this.readingTime,
    this.tags = const [],
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      title: json['title'] ?? 'Untitled',
      author: json['author'] ?? 'Unknown Author',
      content: json['content'] ?? '',
      subtitle: json['subtitle'],
      publishedDate: json['publishedDate'] != null
          ? DateTime.tryParse(json['publishedDate'])
          : null,
      originalUrl: json['originalUrl'] ?? '',
      imageUrl: json['imageUrl'],
      authorImageUrl: json['authorImageUrl'],
      readingTime: json['readingTime'],
      tags: List<String>.from(json['tags'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'authorName': author,
      'content': content,
      'subtitle': subtitle,
      'publishedDate': publishedDate?.toIso8601String(),
      'originalUrl': originalUrl,
      'imageUrl': imageUrl,
      'authorPhoto': authorImageUrl,
      'readingTime': readingTime,
      'tags': tags,
    };
  }

  @override
  List<Object?> get props => [
    title,
    author,
    content,
    subtitle,
    publishedDate,
    originalUrl,
    imageUrl,
    authorImageUrl,
    readingTime,
    tags,
  ];
}
