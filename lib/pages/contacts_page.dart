import 'package:flutter/material.dart';
import '../services/api_service.dart';

class ContactsPage extends StatefulWidget {
  const ContactsPage({super.key});

  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  String _testResult = '点击按钮测试连接';

  Future<void> _testBackendConnection() async {
    final result = await BackendApiService.testDbConnection();
    setState(() {
      _testResult = result['success']
          ? '✅ 连接成功！数据库版本：${result['data'][0]['version']}'
          : '❌ 连接失败：${result['message']}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('我的')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _testBackendConnection,
              child: const Text('测试前后端连接'),
            ),
            const SizedBox(height: 16),
            Text(_testResult),
          ],
        ),
      ),
    );
  }
}