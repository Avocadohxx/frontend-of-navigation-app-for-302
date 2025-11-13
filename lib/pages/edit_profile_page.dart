import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key, required this.user});

  final UserModel user;

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  bool _isLoading = false;
  File? _selectedImage;
  final _picker = ImagePicker();
  final String _baseUrl = 'http://192.168.2.9:3000';

  // 定义固定颜色（适配英文APP风格）
  final Color _hintTextColor = Colors.grey[500]!;
  final Color _primaryTextColor = Colors.black87;
  final Color _secondaryTextColor = Colors.black54;

  @override
  void initState() {
    super.initState();
    _phoneController = TextEditingController(
      text: widget.user.phoneNum == 'Not set' ? '' : widget.user.phoneNum,
    );
    _emailController = TextEditingController(
      text: widget.user.email == 'Not set' ? '' : widget.user.email,
    );
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  // Get JWT token from local storage
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  // Select image from gallery
  Future<void> _selectImage() async {
    final pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (pickedFile != null) {
      setState(() => _selectedImage = File(pickedFile.path));
      await _uploadAvatar();
    }
  }

  // Upload avatar to Aliyun OSS
  Future<void> _uploadAvatar() async {
    if (_selectedImage == null) return;

    setState(() => _isLoading = true);
    try {
      final token = await _getToken();
      if (token == null) throw Exception('Please log in first');

      final fileExt = _selectedImage!.path.split('.').last.toLowerCase();
      if (!['png', 'jpg', 'jpeg', 'webp'].contains(fileExt)) {
        throw Exception('Only png, jpg, jpeg, webp formats are supported');
      }

      // Get presigned URL from backend
      final signatureResponse = await http.post(
        Uri.parse('$_baseUrl/auth/avatar/signature'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({'fileExt': fileExt}),
      );

      if (signatureResponse.statusCode != 200) throw Exception('Failed to get upload URL');
      final signatureData = json.decode(signatureResponse.body);
      final presignedUrl = signatureData['presignedUrl'];
      final newAvatarUrl = signatureData['publicUrl'];

      // Upload image directly to OSS
      final uploadResponse = await http.put(
        Uri.parse(presignedUrl),
        headers: {'Content-Type': 'image/$fileExt'},
        body: await _selectedImage!.readAsBytes(),
      );

      if (uploadResponse.statusCode != 200 && uploadResponse.statusCode != 204) {
        throw Exception('Failed to upload avatar');
      }

      // Notify backend to update database
      await http.post(
        Uri.parse('$_baseUrl/auth/avatar/update'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'userId': widget.user.id,
          'avatarUrl': newAvatarUrl,
        }),
      );

      // Refresh avatar locally
      setState(() {
        widget.user.avatarUrl = newAvatarUrl;
        _selectedImage = null;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Avatar uploaded successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Upload failed: ${e.toString()}')),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // Submit profile updates (phone & email)
  Future<void> _submitEdit() async {
    setState(() => _isLoading = true);

    try {
      final token = await _getToken();
      if (token == null) throw Exception('Please log in first');

      final response = await http.post(
        Uri.parse('$_baseUrl/auth/update-profile'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'userId': widget.user.id,
          'phoneNum': _phoneController.text.trim().isEmpty ? 'Not set' : _phoneController.text.trim(),
          'email': _emailController.text.trim().isEmpty ? 'Not set' : _emailController.text.trim(),
        }),
      );

      if (response.statusCode != 200) throw Exception('Failed to update profile');

      // Build updated user model
      final updatedUser = UserModel(
        id: widget.user.id,
        userName: widget.user.userName,
        phoneNum: _phoneController.text.trim().isEmpty ? 'Not set' : _phoneController.text.trim(),
        email: _emailController.text.trim().isEmpty ? 'Not set' : _emailController.text.trim(),
        avatarUrl: widget.user.avatarUrl,
        lastLoginTime: widget.user.lastLoginTime,
      );

      Navigator.pop(context, updatedUser);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Update failed: ${e.toString()}')),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        title: const Text(
          'Edit Profile',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: colorScheme.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          children: [
            _buildAvatarSection(theme),
            const SizedBox(height: 32),
            _buildEditForm(colorScheme),
            const SizedBox(height: 32),
            _buildSubmitButton(theme),
          ],
        ),
      ),
    );
  }

  // Avatar upload section
  Widget _buildAvatarSection(ThemeData theme) {
    return Column(
      children: [
        GestureDetector(
          onTap: _isLoading ? null : _selectImage,
          child: Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: theme.colorScheme.primary, width: 2),
                ),
                child: ClipOval(
                  child: _selectedImage != null
                      ? Image.file(_selectedImage!, fit: BoxFit.cover)
                      : Image.network(
                    widget.user.avatarUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(Icons.person, size: 60, color: Colors.grey[400]);
                    },
                  ),
                ),
              ),
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  shape: BoxShape.circle,
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                    : const Icon(Icons.camera_alt_outlined, color: Colors.white, size: 18),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Tap to change avatar',
          style: TextStyle(fontSize: 12, color: _hintTextColor),
        ),
      ],
    );
  }

  // Edit form (phone & email)
  Widget _buildEditForm(ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Username',
          style: TextStyle(fontSize: 12, color: _hintTextColor),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            widget.user.userName,
            style: TextStyle(fontSize: 16, color: _primaryTextColor),
          ),
        ),
        const SizedBox(height: 24),

        Text(
          'Phone Number',
          style: TextStyle(fontSize: 12, color: _hintTextColor),
        ),
        const SizedBox(height: 4),
        TextFormField(
          controller: _phoneController,
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            hintText: 'Enter your phone number',
            hintStyle: TextStyle(color: _hintTextColor),
            fillColor: colorScheme.surface,
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
          style: TextStyle(fontSize: 16, color: _primaryTextColor),
        ),
        const SizedBox(height: 16),

        Text(
          'Email',
          style: TextStyle(fontSize: 12, color: _hintTextColor),
        ),
        const SizedBox(height: 4),
        TextFormField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            hintText: 'Enter your email address',
            hintStyle: TextStyle(color: _hintTextColor),
            fillColor: colorScheme.surface,
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
          style: TextStyle(fontSize: 16, color: _primaryTextColor),
        ),
      ],
    );
  }

  // Submit button
  Widget _buildSubmitButton(ThemeData theme) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _submitEdit,
        style: ElevatedButton.styleFrom(
          backgroundColor: theme.colorScheme.primary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 0,
        ),
        child: _isLoading
            ? const CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
            : const Text(
          'Save Changes',
          style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}