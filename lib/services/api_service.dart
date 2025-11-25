import 'package:http/http.dart' as http;
import 'dart:convert';

class BackendApiService {
  static const String _backendIp = '192.168.2.9';
  static const String _backendPort = '3000';
  static const String baseUrl = 'http://$_backendIp:$_backendPort';

  static Future<Map<String, dynamic>> testDbConnection() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/db-test'));
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return {'success': false, 'message': 'Request failed: ${response.statusCode}'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }
}

// 后续可添加其他接口方法，如登录、获取数据等
// static Future<Map<String, dynamic>> login(String username, String password) async {...}
