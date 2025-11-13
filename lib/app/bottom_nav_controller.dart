import 'package:flutter/material.dart';
import 'app_bottomNavigationBar.dart';
import '../pages/home_page.dart';
import '../pages/profile_page.dart';
import '../pages/contacts_page.dart';
import '../models/user_model.dart';

class BottomNavController extends StatefulWidget {
  const BottomNavController({super.key, required this.loggedInUser});

  final UserModel loggedInUser;

  @override
  _BottomNavControllerState createState() => _BottomNavControllerState();
}

class _BottomNavControllerState extends State<BottomNavController> {
  int _currentIndex = 0;

  // page list
  List<Widget> get _pages => [
    HomePage(loggedInUser: widget.loggedInUser),
    const ContactsPage(),
    ProfilePage(user: widget.loggedInUser),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: AppBottomNavigationBar(
        onTabSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        currentIndex: _currentIndex,
      ),
    );
  }
}