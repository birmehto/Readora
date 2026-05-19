import 'package:flutter_test/flutter_test.dart';
import 'package:readora/features/favorites/data/models/favorite_article_model.dart';
import 'package:readora/features/favorites/domain/entities/favorite_article.dart';
import 'package:readora/features/favorites/domain/repositories/favorites_repository.dart';
import 'package:readora/features/favorites/domain/usecases/get_favorites_usecase.dart';
import 'package:readora/features/favorites/domain/usecases/remove_favorite_usecase.dart';

class MockFavoritesRepository implements FavoritesRepository {
  final List<FavoriteArticle> _favorites = [];
  bool removeFavoriteCalled = false;
  String? lastRemovedUrl;

  @override
  Future<List<FavoriteArticle>> getFavorites() async {
    return _favorites;
  }

  @override
  Future<void> removeFavorite(String url) async {
    removeFavoriteCalled = true;
    lastRemovedUrl = url;
    _favorites.removeWhere((item) => item.url == url);
  }
}

void main() {
  group('FavoriteArticleModel Tests', () {
    test('fromJson should parse correctly', () {
      final json = {
        'title': 'Test Article',
        'url': 'https://medium.com/test',
        'visitedAt': '2026-05-19T12:00:00.000Z',
        'author': 'Test Author',
        'domain': 'medium.com',
        'imageUrl': 'https://medium.com/image.png',
      };

      final model = FavoriteArticleModel.fromJson(json);

      expect(model.title, 'Test Article');
      expect(model.url, 'https://medium.com/test');
      expect(model.visitedAt, DateTime.parse('2026-05-19T12:00:00.000Z'));
      expect(model.author, 'Test Author');
      expect(model.domain, 'medium.com');
      expect(model.imageUrl, 'https://medium.com/image.png');
    });

    test('toJson should convert correctly', () {
      final visited = DateTime.parse('2026-05-19T12:00:00.000Z');
      final model = FavoriteArticleModel(
        title: 'Test Article',
        url: 'https://medium.com/test',
        visitedAt: visited,
        author: 'Test Author',
        domain: 'medium.com',
        imageUrl: 'https://medium.com/image.png',
      );

      final json = model.toJson();

      expect(json['title'], 'Test Article');
      expect(json['url'], 'https://medium.com/test');
      expect(json['visitedAt'], visited.toIso8601String());
      expect(json['author'], 'Test Author');
      expect(json['domain'], 'medium.com');
      expect(json['imageUrl'], 'https://medium.com/image.png');
    });
  });

  group('Favorites UseCase Tests', () {
    late MockFavoritesRepository repository;
    late GetFavoritesUseCase getFavoritesUseCase;
    late RemoveFavoriteUseCase removeFavoriteUseCase;

    setUp(() {
      repository = MockFavoritesRepository();
      getFavoritesUseCase = GetFavoritesUseCase(repository);
      removeFavoriteUseCase = RemoveFavoriteUseCase(repository);
    });

    test('GetFavoritesUseCase returns list from repository', () async {
      final article = FavoriteArticle(
        title: 'Hello',
        url: 'https://medium.com/hello',
        visitedAt: DateTime.now(),
      );
      repository._favorites.add(article);

      final result = await getFavoritesUseCase.execute();

      expect(result.length, 1);
      expect(result.first.title, 'Hello');
      expect(result.first.url, 'https://medium.com/hello');
    });

    test('RemoveFavoriteUseCase calls remove on repository', () async {
      const url = 'https://medium.com/hello';

      await removeFavoriteUseCase.execute(url);

      expect(repository.removeFavoriteCalled, true);
      expect(repository.lastRemovedUrl, url);
    });
  });
}
