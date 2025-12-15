import 'package:flutter/material.dart';
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

    // 直接创建用户模型，跳过API验证
    final userModel = UserModel(
      id: 1,
      userName: _usernameController.text.trim().isEmpty ? 'User' : _usernameController.text.trim(),
      email: 'user@example.com',
      phoneNum: '0000000000',
      avatarUrl: 'https://naviapp-shanghai-83857.oss-cn-shanghai.aliyuncs.com/avatar/default_avatar.jpg',
      lastLoginTime: DateTime.now().toIso8601String().substring(0, 16),
    );
    
    // 保存模拟的token和用户信息
    await LocalStorageService.saveLoginInfo('mock_token', {
      'id': 1,
      'user_name': userModel.userName,
      'email': userModel.email,
      'phone_num': userModel.phoneNum,
      'avatar_url': userModel.avatarUrl,
      'last_login_time': userModel.lastLoginTime,
    });

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => BottomNavController(loggedInUser: userModel)),
      );
    }

    setState(() => _isLoading = false);
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