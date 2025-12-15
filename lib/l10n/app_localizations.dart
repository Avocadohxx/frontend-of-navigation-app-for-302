import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'campus_navigator': 'Campus Navigator',
      'welcome_back': 'Welcome back,',
      'start_exploring': 'Start exploring smart campus',
      'smart_features': 'Smart Features',
      'indoor_outdoor_map': '🗺️ Indoor-Outdoor Map',
      'vector_tiles_3d': 'Vector Tiles + 3D Path',
      'realtime_classroom': '📡 Real-time Classroom',
      'esp32_mqtt': 'ESP32 + MQTT Status',
      'ar_navigation': '🥽 AR Navigation',
      'arcore_3d': 'ARCore + 3D Arrows',
      'tech_stack': '🔄 Tech Stack',
      'flutter_nestjs': 'Flutter + NestJS + PostGIS',
      'cross_platform': '📱 Cross Platform',
      'ios_android': 'iOS + Android Support',
      'ai_optimized': '🚀 AI Optimized',
      'smart_path': 'Smart Path Planning',
      'settings': 'Settings',
      'language': 'Language',
      'chinese': 'Chinese',
      'english': 'English',
      'appearance': 'Appearance',
      'light_mode': 'Light Mode',
      'dark_mode': 'Dark Mode',
      'cancel': 'Cancel',
      'confirm': 'Confirm',
    },
    'zh': {
      'campus_navigator': '校园导航',
      'welcome_back': '欢迎回来，',
      'start_exploring': '开始探索智能校园',
      'smart_features': '智能功能',
      'indoor_outdoor_map': '🗺️ 室内外地图',
      'vector_tiles_3d': '矢量瓦片 + 3D路径',
      'realtime_classroom': '📡 实时教室',
      'esp32_mqtt': 'ESP32 + MQTT状态',
      'ar_navigation': '🥽 AR导航',
      'arcore_3d': 'ARCore + 3D箭头',
      'tech_stack': '🔄 技术栈',
      'flutter_nestjs': 'Flutter + NestJS + PostGIS',
      'cross_platform': '📱 跨平台',
      'ios_android': 'iOS + Android支持',
      'ai_optimized': '🚀 AI优化',
      'smart_path': '智能路径规划',
      'settings': '设置',
      'language': '语言',
      'chinese': '中文',
      'english': 'English',
      'appearance': '外观',
      'light_mode': '白天模式',
      'dark_mode': '深夜模式',
      'cancel': '取消',
      'confirm': '确认',
    },
  };

  String translate(String key) {
    return _localizedValues[locale.languageCode]?[key] ?? key;
  }
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'zh'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
