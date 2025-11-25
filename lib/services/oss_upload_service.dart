import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OssUploadService {
  final String baseUrl; // 后端接口地址，如http://localhost:3000

  OssUploadService(this.baseUrl);

  // 步骤1：请求预签名URL
  Future<Map<String, dynamic>> getPresignedUrl(int userId, String fileExt) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/avatar/signature'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'fileExt': fileExt}),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to get presigned URL');
    }
    return json.decode(response.body);
  }

  // 步骤2：直传文件到OSS
  Future<String> uploadToOss(File file, String presignedUrl) async {
    final response = await http.put(
      Uri.parse(presignedUrl),
      headers: {'Content-Type': 'image/${file.path.split('.').last}'},
      body: await file.readAsBytes(),
    );
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to upload to OSS');
    }
    // 从预签名URL中提取公网访问地址
    return presignedUrl.replaceFirst('?', '/').split('?')[0];
  }

  // 步骤3：通知后端更新数据库
  Future<void> updateAvatarInDb(int userId, String avatarUrl) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/avatar/update'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'userId': userId, 'avatarUrl': avatarUrl}),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update avatar in DB');
    }
  }

  // 完整上传流程
  Future<String> uploadAvatar(int userId, File file) async {
    final fileExt = file.path.split('.').last;
    final signature = await getPresignedUrl(userId, fileExt);
    final avatarUrl = await uploadToOss(file, signature['presignedUrl']);
    await updateAvatarInDb(userId, avatarUrl);
    return avatarUrl;
  }
}