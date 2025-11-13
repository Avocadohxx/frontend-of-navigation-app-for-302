import 'package:flutter/material.dart';
import 'pages/auth/auth_entry_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Campus App',
      home: const AuthEntryPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
