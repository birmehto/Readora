import 'package:flutter_test/flutter_test.dart';
import 'package:readora/core/utils/url_validator.dart';

void main() {
  group('UrlValidator', () {
    test('extractUrlFromText finds URL in shared text', () {
      const text =
          'Read “I Made My Flutter App Load 3x Faster” by Abhinav on Medium: https://codingplainenglish.medium.com/article-id';
      final result = UrlValidator.extractUrlFromText(text);
      expect(result, 'https://codingplainenglish.medium.com/article-id');
    });

    test('extractUrlFromText returns null when no URL is present', () {
      const text = 'Just some random text with no links.';
      final result = UrlValidator.extractUrlFromText(text);
      expect(result, null);
    });

    test('cleanTextiseUrl extracts target URL from Textise wrapper', () {
      const textiseUrl =
          'http://textise.org/showtext.aspx?strURL=https://codingplainenglish.medium.com/i-made-my-flutter-app-load-3x-faster-heres-the-exact-optimization-ec2ca3617f2f';
      final result = UrlValidator.cleanTextiseUrl(textiseUrl);
      expect(
        result,
        'https://codingplainenglish.medium.com/i-made-my-flutter-app-load-3x-faster-heres-the-exact-optimization-ec2ca3617f2f',
      );
    });

    test('cleanTextiseUrl returns original URL if not Textise', () {
      const url = 'https://medium.com';
      final result = UrlValidator.cleanTextiseUrl(url);
      expect(result, url);
    });

    test(
      'cleanTextiseUrl handles Textise URL without strURL param gracefully',
      () {
        const url = 'http://textise.org/showtext.aspx';
        final result = UrlValidator.cleanTextiseUrl(url);
        expect(
          result,
          url,
        ); // Or null? behavior depends on implementation, safer to return original
      },
    );
    test('isMediumArticle validates various Medium article formats', () {
      final validUrls = [
        'https://medium.com/@user/article-slug-id123',
        'https://towardsdatascience.com/some-article-id456',
        'https://username.medium.com/another-article-id789',
        'https://uxdesign.cc/design-article-abc',
        'https://medium.com/publication/slug-123',
      ];

      for (final url in validUrls) {
        expect(
          UrlValidator.isMediumArticle(url),
          isTrue,
          reason: 'Should be valid: $url',
        );
      }

      final invalidUrls = [
        'https://medium.com/',
        'https://medium.com/about',
        'https://medium.com/@user',
        'https://towardsdatascience.com/',
        'https://medium.com/me/settings',
        'https://google.com',
        'not-a-url',
      ];

      for (final url in invalidUrls) {
        expect(
          UrlValidator.isMediumArticle(url),
          isFalse,
          reason: 'Should be invalid: $url',
        );
      }
    });

    test('isMediumArticle handles custom domains from list', () {
      expect(
        UrlValidator.isMediumArticle('https://betterhumans.pub/article'),
        isTrue,
      );
      expect(UrlValidator.isMediumArticle('https://eand.co/article'), isTrue);
    });
  });
}
