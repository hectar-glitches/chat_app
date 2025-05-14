import 'package:flutter/material.dart';

/// App theme and UI related constants
class AppTheme {
  // Primary colors
  static const Color backgroundColor = Color(0xFF101014);
  static const Color cardColor = Color(0xFF202024);
  static const Color inputBackgroundColor = Color(0xFF202024);
  static const Color accentColor = Color(0xFFFF6B6B);
  static const Color userMessageBubbleColor = Color(0xFF00BF6D);
  static const Color otherMessageBubbleColor = Color(0xFF2C2C3A);

  // Status colors
  static const Color onlineStatusColor = Color(0xFF4CAF50);
  static const Color errorColor = Color(0xFFE53935);
  static const Color warningColor = Color(0xFFFFA726);
  static const Color successColor = Color(0xFF43A047);

  // Text styles
  static const TextStyle titleStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  static const TextStyle bodyStyle = TextStyle(
    fontSize: 14,
    color: Colors.white,
  );

  static const TextStyle subtitleStyle = TextStyle(
    fontSize: 12,
    color: Colors.white70,
  );

  // Spacing and dimensions
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;

  static const double defaultRadius = 12.0;
  static const double smallRadius = 8.0;
  static const double largeRadius = 24.0;

  // Animation durations
  static const Duration shortAnimationDuration = Duration(milliseconds: 200);
  static const Duration defaultAnimationDuration = Duration(milliseconds: 300);
  static const Duration longAnimationDuration = Duration(milliseconds: 500);
}

/// API and networking related constants
class NetworkConstants {
  static const int defaultTimeoutSeconds = 30;
  static const int longTimeoutSeconds = 60;

  static const String apiBaseUrl = 'https://api.example.com';
  static const String chatEndpoint = '/chat';
  static const String usersEndpoint = '/users';

  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
  };
}

/// Feature flags and configuration options
class AppConfig {
  static const bool enableOfflineMode = true;
  static const bool enableAnalytics = false;
  static const bool enablePushNotifications = true;
  static const bool enableImageCompression = true;

  static const int messagesPerPage = 20;
  static const int maxImageSizeKb = 1024;
}
