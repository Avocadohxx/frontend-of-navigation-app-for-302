import 'package:flutter/material.dart';
import 'login_page.dart';
import 'register_page.dart';

class AuthEntryPage extends StatelessWidget {
  const AuthEntryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'The Smart Campus Navigation App',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            const SizedBox(height: 60),

            // Login Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                ),
                child: const Text(
                  'Log In',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Register Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  side: const BorderSide(color: Colors.blueAccent),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RegisterPage()),
                ),
                child: const Text(
                  'Sign Up',
                  style: TextStyle(fontSize: 18, color: Colors.blueAccent),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}