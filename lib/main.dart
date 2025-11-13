import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:version4/pages/location.dart';
import 'package:version4/pages/map.dart';

/// Main entry point of the Flutter application
/// Flutter应用程序的主入口点
void main() {
  runApp(const MyApp());
}

/// Root application widget that sets up the overall theme and structure
/// 根应用程序组件，设置整体主题和结构
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
        textTheme: TextTheme(
          labelLarge: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.lightBlue, // Button background color / 按钮背景色
            foregroundColor: Colors.white, // Button text color / 按钮文字颜色
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18), // Rounded corners / 圆角
            ),
            padding: const EdgeInsets.symmetric(
                horizontal: 40, vertical: 18), // Padding to increase clickable area / 内边距，增加点击区域
            elevation: 6, // Shadow effect / 阴影效果
            shadowColor: Colors.blue.withOpacity(0.3),
          ),
        ),
      ),
      home: const MyHomePage(title: 'SHOU Campus Navigation demo'),
    );
  }
}

/// Home page widget that displays the main navigation interface
/// 主页组件，显示主要导航界面
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

/// State class for the home page, handling UI rendering and interactions
/// 主页的状态类，处理UI渲染和交互
class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Set semi-transparent black background for better white text visibility
      // 设置半透明黑色背景，使白色文字更清晰
      backgroundColor: Colors.black.withOpacity(0.1),
      appBar: AppBar(
        title: Text(
          widget.title,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white, // White title text / 白色标题文字
          ),
        ),
        backgroundColor: Colors.transparent, // Transparent AppBar background / 透明AppBar背景
        elevation: 0, // Remove shadow for cleaner appearance / 移除阴影，使整体更干净
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.jpg'), // Background image path / 背景图片路径
            fit: BoxFit.cover, // Make image cover the entire container / 使图片覆盖整个容器
          ),
        ),
        child: Stack(
          children: [
            // Blurred background layer using BackdropFilter
            // 使用BackdropFilter实现的虚化背景层
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5), // Blur intensity / 虚化程度
              child: Container(
                color: Colors.transparent, // Keep transparent for blur effect / 保持透明，让模糊效果作用于下方图片
              ),
            ),
            // Content layer with semi-transparent background for better readability
            // 内容层，带有半透明背景以增强可读性
            Align(
              alignment: Alignment.center,
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1), // Semi-transparent white background / 半透明白色背景
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Location button for navigating to location page
                    // 定位按钮，用于导航到定位页面
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LocationPage(),
                          ),
                        );
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.location_on, size: 20, color: Colors.white),
                          SizedBox(width: 8),
                          const Text('Your Location', style: TextStyle(color: Colors.white)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40), // Spacing between buttons / 按钮间距

                    // Map button for navigating to map page
                    // 地图按钮，用于导航到地图页面
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MapPage(),
                          ),
                        );
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.map, size: 20, color: Colors.white),
                          SizedBox(width: 8),
                          const Text('Campus Map', style: TextStyle(color: Colors.white)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}