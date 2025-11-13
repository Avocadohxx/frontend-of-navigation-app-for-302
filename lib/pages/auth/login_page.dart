import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../services/api_service.dart';
import '../../app/bottom_nav_controller.dart';
import '../../models/user_model.dart';
import '../../../services/local_storage_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await http.post(
        Uri.parse('${BackendApiService.baseUrl}/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'user_name': _usernameController.text.trim(),
          'password': _passwordController.text.trim(),
        }),
      );

      final result = json.decode(response.body);
      if (response.statusCode == 200 && result['success']) {
        final userModel = UserModel.fromJson(result['data']);
        final token = result['data']['token'];
        // 3. 保存token和用户信息到本地存储
        await LocalStorageService.saveLoginInfo(
          token,
          result['data'], // 完整的用户数据（包含last_login_time等）
        );
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => BottomNavController(loggedInUser: userModel)),
          );
        }
      } else {
        setState(() => _errorMessage = result['message'] ?? 'Login failed. Please check your credentials.');
      }
    } catch (e) {
      setState(() => _errorMessage = 'Network error: ${e.toString()}');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Log In'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 40),

              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Please enter your username'
                    : null,
              ),
              const SizedBox(height: 20),

              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Please enter your password'
                    : null,
              ),
              const SizedBox(height: 10),

              if (_errorMessage != null)
                Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleLogin,
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Log In', style: TextStyle(fontSize: 18)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}