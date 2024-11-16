import 'package:flutter/material.dart';
import 'package:food_app/login/splash_screen.dart';
import 'package:provider/provider.dart';
import 'theme_provider.dart'; // Import ThemeProvider
 // Import HomePage

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'Food App',
      theme: ThemeData.light(), // Giao diện sáng
      darkTheme: ThemeData.dark(), // Giao diện tối
      themeMode: themeProvider.themeMode, // Áp dụng trạng thái theme
      home: const SplashScreen(),
    );
  }
}
