import 'package:flutter/material.dart';
import '../models/user_model.dart';
import 'edit_profile_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key, required this.user});

  // 接收登录成功后的用户信息
  final UserModel user;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late UserModel _currentUser;

  @override
  void initState() {
    super.initState();
    _currentUser = widget.user;
  }

  // 接收编辑页面返回的更新后用户信息
  void _updateUserInfo(UserModel updatedUser) {
    setState(() {
      _currentUser = updatedUser;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        title: Text('Profile', style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
        backgroundColor: colorScheme.background,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // avatar
            _buildAvatarSection(colorScheme),
            const SizedBox(height: 32),

            // user info card
            _buildUserInfoCard(textTheme, colorScheme),
            const SizedBox(height: 32),

            // edit
            _buildEditButton(theme, context),
            const SizedBox(height: 16),

            // logout button
            _buildLogoutButton(theme, context),
          ],
        ),
      ),
    );
  }

  // avatar show
  Widget _buildAvatarSection(ColorScheme colorScheme) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              image: AssetImage(_currentUser.avatarUrl),
              fit: BoxFit.cover,
            ),
            border: Border.all(color: colorScheme.primary, width: 2),
          ),
        ),

        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: colorScheme.primary,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.camera_alt_outlined, color: Colors.white, size: 18),
        ),
      ],
    );
  }

  // 用户信息卡片
  Widget _buildUserInfoCard(TextTheme textTheme, ColorScheme colorScheme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Personal Information', style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),

          // 用户名
          _buildInfoItem(
            icon: Icons.person_outline,
            label: 'Username',
            value: _currentUser.userName,
            textTheme: textTheme,
          ),
          const SizedBox(height: 16),

          // 手机号
          _buildInfoItem(
            icon: Icons.phone_outlined,
            label: 'Phone Number',
            value: _currentUser.phoneNum!,
            textTheme: textTheme,
          ),
          const SizedBox(height: 16),

          // 邮箱
          _buildInfoItem(
            icon: Icons.email_outlined,
            label: 'Email',
            value: _currentUser.email!,
            textTheme: textTheme,
          ),
          const SizedBox(height: 16),

          // 最后登录时间
          _buildInfoItem(
            icon: Icons.access_time_outlined,
            label: 'Last Login',
            value: _currentUser.lastLoginTime,
            textTheme: textTheme,
          ),
          const SizedBox(height: 16),

          // 学号
          _buildInfoItem(
            icon: Icons.badge_outlined,
            label: 'Student ID',
            value: '2021' + (_currentUser.id % 10000).toString().padLeft(4, '0'),
            textTheme: textTheme,
          ),
          const SizedBox(height: 16),

          // 学院
          _buildInfoItem(
            icon: Icons.school_outlined,
            label: 'School',
            value: 'School of Computer Science',
            textTheme: textTheme,
          ),
          const SizedBox(height: 16),

          // 年级
          _buildInfoItem(
            icon: Icons.trending_up_outlined,
            label: 'Grade',
            value: 'Junior (3rd Year)',
            textTheme: textTheme,
          ),
        ],
      ),
    );
  }

  // 单个信息项组件
  Widget _buildInfoItem({
    required IconData icon,
    required String label,
    required String value,
    required TextTheme textTheme,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: Colors.grey[500]),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: textTheme.bodySmall?.copyWith(color: Colors.grey[500])),
              const SizedBox(height: 4),
              Text(value, style: textTheme.bodyMedium),
            ],
          ),
        ),
      ],
    );
  }

  // 编辑按钮
  Widget _buildEditButton(ThemeData theme, BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: () => _navigateToEditPage(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: theme.colorScheme.primary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 0,
        ),
        child: Text(
          'Edit Profile',
          style: theme.textTheme.bodyLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  // 跳转到编辑页面
  void _navigateToEditPage(BuildContext context) async {
    // 跳转并接收返回的更新后数据
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfilePage(user: _currentUser),
      ),
    );

    // 如果返回了更新后的用户信息，刷新页面
    if (result != null && result is UserModel) {
      _updateUserInfo(result);
    }
  }

  // 登出按钮
  Widget _buildLogoutButton(ThemeData theme, BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton(
        onPressed: () => _handleLogout(context),
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: Colors.red.shade400, width: 2),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 0,
        ),
        child: Text(
          'Logout',
          style: theme.textTheme.bodyLarge?.copyWith(
            color: Colors.red.shade400,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  // 处理登出
  void _handleLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // 关闭对话框
                Navigator.of(context).pop();
                // 返回到登录页面，清除所有导航栈
                Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
              },
              child: Text(
                'Logout',
                style: TextStyle(color: Colors.red.shade400),
              ),
            ),
          ],
        );
      },
    );
  }
}