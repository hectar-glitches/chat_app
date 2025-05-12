import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/friends_provider.dart';
import 'providers/group_chat_provider.dart';
import 'screens/contact_list_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => FriendsProvider()),
        ChangeNotifierProvider(create: (context) => GroupChatProvider()),
      ],
      child: MaterialApp(
        title: 'Chat App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: const Color(0xFF00BF6D),
          scaffoldBackgroundColor: const Color(0xFF1D1D35),
          appBarTheme: const AppBarTheme(color: Color(0xFF1D1D35)),
        ),
        home: const ContactListScreen(),
      ),
    );
  }
}
