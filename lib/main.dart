import 'package:flutter/material.dart';
import 'pages/auth/auth_entry_page.dart';
import 'utils/app_settings.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AppSettings _appSettings = AppSettings();

  @override
  void initState() {
    super.initState();
    _appSettings.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Campus App',
      home: const AuthEntryPage(),
      debugShowCheckedModeBanner: false,
      themeMode: _appSettings.themeMode,
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFFF8F5F0),
        colorScheme: const ColorScheme.light(
          primary: Colors.blue,
          secondary: Colors.blueAccent,
          background: Color(0xFFF8F5F0),
          surface: Colors.white,
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFF121212),
        colorScheme: const ColorScheme.dark(
          primary: Colors.blue,
          secondary: Colors.blueAccent,
          background: Color(0xFF121212),
          surface: Color(0xFF1E1E1E),
        ),
      ),
      builder: (context, child) {
        return AppSettingsProvider(
          settings: _appSettings,
          child: child!,
        );
      },
    );
  }
}

class AppSettingsProvider extends InheritedWidget {
  final AppSettings settings;

  const AppSettingsProvider({
    super.key,
    required this.settings,
    required super.child,
  });

  static AppSettings of(BuildContext context) {
    final provider = context.dependOnInheritedWidgetOfExactType<AppSettingsProvider>();
    return provider!.settings;
  }

  @override
  bool updateShouldNotify(AppSettingsProvider oldWidget) {
    return settings != oldWidget.settings;
  }
}
