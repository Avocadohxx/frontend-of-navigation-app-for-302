import 'package:flutter/material.dart';

class AppBottomNavigationBar extends StatelessWidget {
  final Function(int index) onTabSelected;
  final int currentIndex;

  const AppBottomNavigationBar({required this.onTabSelected,required this.currentIndex, super.key});

  @override
  Widget build(BuildContext context) {
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
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.contact_phone), label: "Contacts"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
        onTap: onTabSelected,
      ),
    );
  }
}