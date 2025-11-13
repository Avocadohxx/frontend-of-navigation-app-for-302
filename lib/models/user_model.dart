class UserModel {
  final int id;
  final String userName;
  final String? phoneNum;
  final String? email;
  String avatarUrl;
  final String lastLoginTime;

  UserModel({
    required this.id,
    required this.userName,
    this.phoneNum,
    this.email,
    required this.avatarUrl,
    required this.lastLoginTime,
  });

  // 从后端返回的JSON数据转换为模型（后续对接用）
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? 0,
      userName: json['user_name'] ?? 'Unknown User',
      phoneNum: json['phone_num'] ?? 'Not set',
      email: json['email'] ?? 'Not set',
      avatarUrl: json['avatar_url'] ?? 'https://naviapp-shanghai-83857.oss-cn-shanghai.aliyuncs.com/avatar/default_avatar.jpg',
      lastLoginTime: json['last_login_time'] != null
          ? DateTime.parse(json['last_login_time']).toString().substring(0, 16)
          : 'Never logged in',
    );
  }
}