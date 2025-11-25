// services/local_storage_service.dart
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  // 保存登录信息（token + 用户数据）
  static Future<void> saveLoginInfo(String token, Map<String, dynamic> userData) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token); // 保存token
    await prefs.setString('userData', json.encode(userData)); // 保存用户信息（转为JSON字符串）
  }

  // 获取本地存储的token
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  // 获取本地存储的用户信息
  static Future<Map<String, dynamic>?> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userDataStr = prefs.getString('userData');
    if (userDataStr != null) {
      return json.decode(userDataStr);
    }
    return null;
  }

  // 清除登录信息（退出登录时用）
  static Future<void> clearLoginInfo() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('userData');
  }
}