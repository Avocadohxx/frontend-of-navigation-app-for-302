import 'package:flutter/material.dart';
import '../main.dart';

class AppBottomNavigationBar extends StatelessWidget {
  final Function(int index) onTabSelected;
  final int currentIndex;

  const AppBottomNavigationBar({required this.onTabSelected,required this.currentIndex, super.key});

  @override
  Widget build(BuildContext context) {
    final appSettings = AppSettingsProvider.of(context);
    final isZh = appSettings.language == 'zh';

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        selectedItemColor: Colors.amber[800],
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        items: [
          BottomNavigationBarItem(icon: const Icon(Icons.home), label: isZh ? "首页" : "Home"),
          BottomNavigationBarItem(icon: const Icon(Icons.map), label: isZh ? "地图" : "Map"),
          BottomNavigationBarItem(icon: const Icon(Icons.meeting_room), label: isZh ? "教室" : "Room"),
          BottomNavigationBarItem(icon: const Icon(Icons.contact_phone), label: isZh ? "联系人" : "Contacts"),
          BottomNavigationBarItem(icon: const Icon(Icons.person), label: isZh ? "个人" : "Profile"),
        ],
        onTap: onTabSelected,
      ),
    );
  }
}