import 'package:logger/logger.dart';
import '../constants/app_constants.dart';

class ErrorHandler {
  static final Logger _logger = Logger();

  static String parseError(dynamic error) {
    final errorString = error.toString();
    _logger.e('Parsing error: $errorString');

    // Clean up the error message
    String cleanError = errorString.replaceAll('Exception: ', '');

    // Map specific errors to user-friendly messages
    if (cleanError.contains('Failed to fetch') ||
        cleanError.contains('fetch')) {
      return 'Unable to fetch the article. Please check the URL and try again.';
    } else if (cleanError.contains('timeout') ||
        cleanError.contains('timed out')) {
      return AppConstants.timeoutError;
    } else if (cleanError.contains('paywall') ||
        cleanError.contains('member-only')) {
      return AppConstants.paywallError;
    } else if (cleanError.contains('not found') || cleanError.contains('404')) {
      return AppConstants.notFoundError;
    } else if (cleanError.contains('network') ||
        cleanError.contains('connection')) {
      return AppConstants.networkError;
    } else if (cleanError.contains('invalid') ||
        cleanError.contains('malformed')) {
      return AppConstants.invalidUrlError;
    } else {
      return cleanError.isNotEmpty ? cleanError : AppConstants.genericError;
    }
  }

  static void logError(String context, String message) {
    _logger.e('[$context] $message');
  }

  static void logInfo(String context, String message) {
    _logger.i('[$context] $message');
  }

  static void logWarning(String context, String message) {
    _logger.w('[$context] $message');
  }
}
