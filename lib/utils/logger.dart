import 'dart:developer' as developer;

/// Log levels for the app
enum LogLevel { debug, info, warning, error }

/// A simple logging utility that provides consistent log formatting
/// and can be configured to show logs only at specific levels.
class Logger {
  static LogLevel _currentLevel = LogLevel.debug;

  /// Current minimum log level that will be displayed
  static LogLevel get currentLevel => _currentLevel;

  /// Set the minimum log level to display
  static void setLogLevel(LogLevel level) {
    _currentLevel = level;
  }

  /// Log a message at the debug level
  static void d(String tag, String message) {
    _log(LogLevel.debug, tag, message);
  }

  /// Log a message at the info level
  static void i(String tag, String message) {
    _log(LogLevel.info, tag, message);
  }

  /// Log a message at the warning level
  static void w(String tag, String message) {
    _log(LogLevel.warning, tag, message);
  }

  /// Log a message at the error level
  static void e(
    String tag,
    String message, [
    dynamic error,
    StackTrace? stackTrace,
  ]) {
    _log(LogLevel.error, tag, message);
    if (error != null) {
      developer.log('ERROR: $error', name: tag);
    }
    if (stackTrace != null) {
      developer.log('STACK TRACE: $stackTrace', name: tag);
    }
  }

  /// Internal method to handle logging based on current level
  static void _log(LogLevel level, String tag, String message) {
    if (level.index < _currentLevel.index) {
      return;
    }

    final levelString = level.toString().split('.').last.toUpperCase();
    final timestamp = DateTime.now().toIso8601String();
    developer.log('[$timestamp] [$levelString] $message', name: tag);
  }
}
