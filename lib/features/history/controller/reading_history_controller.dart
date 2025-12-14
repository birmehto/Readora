import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../article/model.dart';

class ReadingHistoryController extends GetxController {
  static const String _historyKey = 'reading_history';
  static const String _favoritesKey = 'favorites';
  static const int _maxHistoryItems = 50;

  final GetStorage _storage = GetStorage();
  final _history = <Article>[].obs;
  final _favorites = <Article>[].obs;

  List<Article> get history => _history;
  List<Article> get favorites => _favorites;

  @override
  void onInit() {
    super.onInit();
    _loadHistory();
    _loadFavorites();
  }

  void _loadHistory() {
    try {
      final historyJson = _storage.read<List>(_historyKey) ?? [];
      _history.value = historyJson
          .map((json) => Article.fromJson(Map<String, dynamic>.from(json)))
          .toList();
    } catch (e) {
      // Handle error silently
    }
  }

  void _loadFavorites() {
    try {
      final favoritesJson = _storage.read<List>(_favoritesKey) ?? [];
      _favorites.value = favoritesJson
          .map((json) => Article.fromJson(Map<String, dynamic>.from(json)))
          .toList();
    } catch (e) {
      // Handle error silently
    }
  }

  void addToHistory(Article article) {
    try {
      _history.removeWhere((a) => a.originalUrl == article.originalUrl);
      _history.insert(0, article);

      if (_history.length > _maxHistoryItems) {
        _history.removeRange(_maxHistoryItems, _history.length);
      }

      _saveHistory();
    } catch (e) {
      // Handle error silently
    }
  }

  void _saveHistory() {
    try {
      final historyJson = _history.map((article) => article.toJson()).toList();
      _storage.write(_historyKey, historyJson);
    } catch (e) {
      // Handle error silently
    }
  }

  void toggleFavorite(Article article) {
    try {
      final index = _favorites.indexWhere(
        (a) => a.originalUrl == article.originalUrl,
      );

      if (index >= 0) {
        _favorites.removeAt(index);
      } else {
        _favorites.insert(0, article);
      }

      _saveFavorites();
    } catch (e) {
      // Handle error silently
    }
  }

  void _saveFavorites() {
    try {
      final favoritesJson = _favorites
          .map((article) => article.toJson())
          .toList();
      _storage.write(_favoritesKey, favoritesJson);
    } catch (e) {
      // Handle error silently
    }
  }

  bool isFavorite(Article article) {
    return _favorites.any((a) => a.originalUrl == article.originalUrl);
  }

  // Statistics getters
  int get totalArticlesRead => _history.length;
  int get totalFavorites => _favorites.length;

  int get totalReadingTime {
    return _history.fold(0, (sum, article) => sum + (article.readingTime ?? 0));
  }

  List<String> get topAuthors {
    final authorCounts = <String, int>{};
    for (final article in _history) {
      authorCounts[article.author] = (authorCounts[article.author] ?? 0) + 1;
    }

    final sortedAuthors = authorCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return sortedAuthors.take(5).map((e) => e.key).toList();
  }

  // Method to add sample data for testing (can be removed in production)
  void addSampleData() {
    final sampleArticles = [
      Article(
        title: 'Getting Started with Flutter',
        author: 'Flutter Team',
        content:
            'Flutter is Google\'s UI toolkit for building beautiful, natively compiled applications...',
        subtitle: 'A comprehensive guide to Flutter development',
        publishedDate: DateTime.now().subtract(const Duration(days: 1)),
        originalUrl: 'https://flutter.dev/docs/get-started',
        readingTime: 10,
        tags: ['Flutter', 'Mobile', 'Development'],
      ),
      Article(
        title: 'State Management in Flutter',
        author: 'John Doe',
        content:
            'State management is one of the most important concepts in Flutter...',
        subtitle: 'Understanding different state management approaches',
        publishedDate: DateTime.now().subtract(const Duration(days: 3)),
        originalUrl: 'https://example.com/state-management',
        readingTime: 15,
        tags: ['Flutter', 'State Management', 'Architecture'],
      ),
      Article(
        title: 'Building Responsive UIs',
        author: 'Jane Smith',
        content:
            'Creating responsive user interfaces is crucial for modern applications...',
        publishedDate: DateTime.now().subtract(const Duration(days: 7)),
        originalUrl: 'https://example.com/responsive-ui',
        readingTime: 8,
        tags: ['UI', 'Design', 'Responsive'],
      ),
    ];

    for (final article in sampleArticles) {
      addToHistory(article);
    }

    // Add first article to favorites
    toggleFavorite(sampleArticles.first);
  }

  void clearHistory() {
    try {
      _history.clear();
      _storage.remove(_historyKey);
    } catch (e) {
      // Handle error silently
    }
  }

  void removeFromHistory(Article article) {
    try {
      _history.removeWhere((a) => a.originalUrl == article.originalUrl);
      _saveHistory();
    } catch (e) {
      // Handle error silently
    }
  }
}
