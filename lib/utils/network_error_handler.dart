import 'dart:async';
import 'dart:io';

/// A utility class to handle common network errors and provide user-friendly messages
class NetworkErrorHandler {
  /// Handle various network errors and return appropriate user-friendly message
  static String handleError(dynamic error) {
    if (error is SocketException || error is TimeoutException) {
      return 'Network connection error. Please check your internet connection and try again.';
    } else if (error is FormatException) {
      return 'Unable to process data. Please try again later.';
    } else if (error is HttpException) {
      return 'Unable to reach the server. Please try again later.';
    } else {
      return error?.toString() ?? 'An unknown error occurred';
    }
  }

  /// Wrap an async operation with timeout and error handling
  static Future<T> executeWithTimeout<T>({
    required Future<T> Function() operation,
    Duration timeout = const Duration(seconds: 30),
  }) async {
    try {
      return await operation().timeout(timeout);
    } on TimeoutException {
      throw TimeoutException('The operation timed out. Please try again.');
    } catch (e) {
      throw Exception(handleError(e));
    }
  }
}
