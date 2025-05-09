import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/friends_provider.dart';
import 'screens/contact_list_screen.dart';
import 'providers/chat_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FriendsProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ChatProvider(),
      child: MaterialApp(
        title: 'Chat App',
        theme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.dark,
          primaryColor: const Color(0xFF1A3636),
          primaryColorDark: const Color(0xFF1A3636),
          colorScheme: const ColorScheme.dark(
            primary: Color(0xFF1A3636),
            secondary: Color(0xFFFFD700),
            surface: Color(0xFF121212),
            error: Colors.red,
            onPrimary: Colors.white,
            onSecondary: Colors.black,
            onSurface: Colors.white,
            onError: Colors.black,
          ),
          scaffoldBackgroundColor: const Color(0xFF121212),
          cardColor: const Color(0xFF1E1E1E),
          textTheme: const TextTheme(
            bodyLarge: TextStyle(color: Colors.white70),
            bodyMedium: TextStyle(color: Colors.white70),
            titleLarge: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            headlineSmall: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            bodySmall: TextStyle(color: Colors.white54),
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF1A3636),
            elevation: 2,
            titleTextStyle: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            iconTheme: IconThemeData(color: Colors.white),
          ),
        ),
        home: const ContactListScreen(),
      ),
    );
  }
}
