import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../main.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.loggedInUser});

  final UserModel loggedInUser;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final appSettings = AppSettingsProvider.of(context);
    final isZh = appSettings.language == 'zh';

    final titleStyle = TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: Colors.grey[800],
    );

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(isZh ? '校园导航' : 'Campus Navigator'),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black87,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => _showSettings(context),
            tooltip: isZh ? '设置' : 'Settings',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 32),

            // 用户欢迎卡片
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue.shade400, Colors.blue.shade600],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.white.withOpacity(0.2),
                        backgroundImage: AssetImage(widget.loggedInUser.avatarUrl),
                        child: widget.loggedInUser.avatarUrl.startsWith('assets')
                            ? null
                            : Text(
                                widget.loggedInUser.userName.isNotEmpty
                                    ? widget.loggedInUser.userName[0].toUpperCase()
                                    : 'U',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isZh
                                  ? '欢迎回来，${widget.loggedInUser.userName}'
                                  : 'Welcome back, ${widget.loggedInUser.userName}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              isZh ? '开始探索智慧校园' : 'Start exploring smart campus',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // service title
            Text(
              isZh ? '智能功能' : 'Smart Features',
              style: titleStyle.copyWith(color: Theme.of(context).brightness == Brightness.dark ? Colors.grey[300] : Colors.grey[800]),
            ),
            const SizedBox(height: 16),

            // service
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                _serviceCard(
                  image:"assets/images/smart-path.png" ,
                  color: const Color(0xFFF5F2E9),
                  title: isZh ? '🗺️ 室内外地图' : '🗺️ Indoor-Outdoor Map',
                  subtitle: isZh ? '矢量瓦片 + 3D路径' : 'Vector Tiles + 3D Path',
                  onTap: () => _showTechDetails('map', isZh),
                ),
                _serviceCard(
                  image: "assets/images/classroom.jpg",
                  color: const Color(0xFFE8F5E8),
                  title: isZh ? '📡 实时教室' : '📡 Real-time Classroom',
                  subtitle: isZh ? 'ESP32 + MQTT状态' : 'ESP32 + MQTT Status',
                  onTap: () => _showTechDetails('classroom', isZh),
                ),
                _serviceCard(
                  image: "assets/images/ar.jpg",
                  color: const Color(0xFFE8F0FF),
                  title: isZh ? '🥽 AR导航' : '🥽 AR Navigation',
                  subtitle: isZh ? 'ARCore + 3D箭头' : 'ARCore + 3D Arrows',
                  onTap: () => _showTechDetails('ar', isZh),
                ),
                _serviceCard(
                  image: "assets/images/tech.jpg",
                  color: const Color(0xFFFFF0E8),
                  title: isZh ? '🔄 技术栈' : '🔄 Tech Stack',
                  subtitle: 'Flutter + NestJS + PostGIS',
                  onTap: () => _showTechDetails('stack', isZh),
                ),
                _serviceCard(
                  image: "assets/images/cross.jpg",
                  color: const Color(0xFFF5F2E9),
                  title: isZh ? '📱 跨平台' : '📱 Cross Platform',
                  subtitle: isZh ? 'iOS + Android支持' : 'iOS + Android Support',
                  onTap: () => _showTechDetails('platform', isZh),
                ),
                _serviceCard(
                  image: "assets/images/ai.png",
                  color: const Color(0xFFF8E8FF),
                  title: isZh ? '🚀 AI优化' : '🚀 AI Optimized',
                  subtitle: isZh ? '智能路径规划' : 'Smart Path Planning',
                  onTap: () => _showTechDetails('ai', isZh),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // 单个服务卡片
  Widget _serviceCard({
    required String image,
    required Color color,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 190,
        height: 230,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 100,
                width: 200,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Image.asset(image, fit: BoxFit.contain),
              ),
              const SizedBox(height: 12),
              Text(title,
                  style: TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w600)),
              const SizedBox(height: 4),
              Text(subtitle,
                  style: TextStyle(
                      fontSize: 12, color: Colors.grey[700])),
            ],
          ),
        ),
      ),
    );
  }

  void _showTechDetails(String tech, bool isZh) {
    final Map<String, Map<String, dynamic>> techInfoZh = {
      'map': {
        'title': '🗺️ 室内外一体化地图引擎',
        'tech': ['Mapbox GL Native', 'PostGIS 3D网络', 'SVG→MBTiles转换'],
        'features': [
          '矢量瓦片渲染，节省30-50%数据',
          'A*算法跨楼层路径规划',
          'CAD图纸转换与叠加融合',
          '3D坐标系避免重复上下楼'
        ],
        'color': Colors.green
      },
      'classroom': {
        'title': '📡 实时教室状态系统',
        'tech': ['ESP32红外计数器', 'MQTT协议', 'Redis Stream', 'GraphQL Subscription'],
        'features': [
          'Airflow自动同步课表',
          '实时占用状态监测',
          '毫秒级数据更新',
          '智能使用预测'
        ],
        'color': Colors.blue
      },
      'ar': {
        'title': '🥽 AR实时导航',
        'tech': ['ARCore/ARKit', 'Flutter FFI', 'IMU预积分'],
        'features': [
          '持久性锚点定位',
          '1秒快速启动AR',
          '低纹理区域漂移校正',
          '3D箭头精准指引'
        ],
        'color': Colors.purple
      },
      'stack': {
        'title': '🔄 完整技术栈',
        'tech': ['Flutter', 'NestJS', 'PostgreSQL', 'Redis'],
        'features': [
          '跨平台移动端开发',
          '高性能后端API服务',
          '关系型数据存储',
          '缓存与队列处理'
        ],
        'color': Colors.orange
      },
      'platform': {
        'title': '📱 跨平台支持',
        'tech': ['iOS', 'Android', 'Web'],
        'features': [
          '原生性能体验',
          '统一代码库',
          '快速迭代更新',
          '云端热修复支持'
        ],
        'color': Colors.teal
      },
      'ai': {
        'title': '🚀 AI智能优化',
        'tech': ['机器学习路径优化', '用户行为预测', '智能推荐'],
        'features': [
          '个性化路径推荐',
          '实时避让拥堵',
          '学习习惯分析',
          '智能教室推荐'
        ],
        'color': Colors.red
      }
    };

    final Map<String, Map<String, dynamic>> techInfoEn = {
      'map': {
        'title': '🗺️ Indoor-Outdoor Map Engine',
        'tech': ['Mapbox GL Native', 'PostGIS 3D Network', 'SVG→MBTiles Convert'],
        'features': [
          'Vector tile rendering saves 30-50% data',
          'A* algorithm for cross-floor pathfinding',
          'CAD drawing conversion and overlay',
          '3D coordinate system avoids duplicate floors'
        ],
        'color': Colors.green
      },
      'classroom': {
        'title': '📡 Real-time Classroom Status',
        'tech': ['ESP32 IR Counter', 'MQTT Protocol', 'Redis Stream', 'GraphQL Subscription'],
        'features': [
          'Airflow auto-sync schedule',
          'Real-time occupancy monitoring',
          'Millisecond-level data updates',
          'Smart usage prediction'
        ],
        'color': Colors.blue
      },
      'ar': {
        'title': '🥽 AR Real-time Navigation',
        'tech': ['ARCore/ARKit', 'Flutter FFI', 'IMU Pre-integration'],
        'features': [
          'Persistent anchor positioning',
          '1-second fast AR startup',
          'Low-texture drift correction',
          '3D arrow precise guidance'
        ],
        'color': Colors.purple
      },
      'stack': {
        'title': '🔄 Complete Tech Stack',
        'tech': ['Flutter', 'NestJS', 'PostgreSQL', 'Redis'],
        'features': [
          'Cross-platform mobile development',
          'High-performance backend API',
          'Relational data storage',
          'Caching and queue processing'
        ],
        'color': Colors.orange
      },
      'platform': {
        'title': '📱 Cross-Platform Support',
        'tech': ['iOS', 'Android', 'Web'],
        'features': [
          'Native performance experience',
          'Unified codebase',
          'Fast iteration updates',
          'Cloud hotfix support'
        ],
        'color': Colors.teal
      },
      'ai': {
        'title': '🚀 AI Smart Optimization',
        'tech': ['ML Path Optimization', 'User Behavior Prediction', 'Smart Recommendation'],
        'features': [
          'Personalized path recommendations',
          'Real-time congestion avoidance',
          'Learning habit analysis',
          'Smart classroom recommendations'
        ],
        'color': Colors.red
      }
    };

    final techInfo = isZh ? techInfoZh : techInfoEn;
    final info = techInfo[tech]!;
    final coreTech = isZh ? '核心技术' : 'Core Technology';
    final features = isZh ? '功能特性' : 'Features';
    final experienceAR = isZh ? '体验AR导航' : 'Experience AR Navigation';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        builder: (context, scrollController) => Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            color: Theme.of(context).scaffoldBackgroundColor,
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),

                Text(
                  info['title'],
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: info['color'] as Color,
                  ),
                ),

                const SizedBox(height: 20),

                // 技术栈
                _buildTechSection(coreTech, info['tech'] as List<String>, Icons.code),

                const SizedBox(height: 16),

                // 功能特性
                _buildTechSection(features, info['features'] as List<String>, Icons.star),

                const SizedBox(height: 24),

                // 演示按钮
                if (tech == 'ar')
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      _showARDemo(isZh);
                    },
                    icon: const Icon(Icons.view_in_ar),
                    label: Text(experienceAR),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: info['color'] as Color,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 48),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTechSection(String title, List<String> items, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 20, color: Colors.grey[600]),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...items.map((item) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('•', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  item,
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ),
            ],
          ),
        )),
      ],
    );
  }

  void _showARDemo(bool isZh) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: Colors.black,
        child: Container(
          width: 300,
          height: 400,
          decoration: BoxDecoration(
            color: Colors.black87,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Stack(
            children: [
              // AR相机视图模拟
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.green, width: 2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.camera_alt,
                        color: Colors.green,
                        size: 60,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      isZh ? 'AR导航已启动' : 'AR Navigation Activated',
                      style: const TextStyle(
                        color: Colors.green,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      isZh ? '跟随3D箭头前往目的地' : 'Follow 3D arrows to destination',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),

              // 3D箭头
              const Positioned(
                bottom: 100,
                child: Icon(
                  Icons.navigation,
                  color: Colors.green,
                  size: 40,
                ),
              ),

              // 关闭按钮
              Positioned(
                top: 20,
                right: 20,
                child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSettings(BuildContext context) {
    final appSettings = AppSettingsProvider.of(context);

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            final isZh = appSettings.language == 'zh';

            return Container(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  Text(
                    isZh ? '设置' : 'Settings',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Theme settings
                  Text(
                    isZh ? '外观' : 'Appearance',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildOptionButton(
                          label: isZh ? '浅色模式' : 'Light Mode',
                          icon: Icons.light_mode,
                          isSelected: appSettings.themeMode == ThemeMode.light,
                          onTap: () {
                            appSettings.setThemeMode(ThemeMode.light);
                            setModalState(() {});
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildOptionButton(
                          label: isZh ? '深色模式' : 'Dark Mode',
                          icon: Icons.dark_mode,
                          isSelected: appSettings.themeMode == ThemeMode.dark,
                          onTap: () {
                            appSettings.setThemeMode(ThemeMode.dark);
                            setModalState(() {});
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Language settings
                  Text(
                    isZh ? '语言' : 'Language',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildOptionButton(
                          label: isZh ? '英文' : 'English',
                          icon: Icons.language,
                          isSelected: appSettings.language == 'en',
                          onTap: () {
                            appSettings.setLanguage('en');
                            setModalState(() {});
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildOptionButton(
                          label: isZh ? '中文' : 'Chinese',
                          icon: Icons.translate,
                          isSelected: appSettings.language == 'zh',
                          onTap: () {
                            appSettings.setLanguage('zh');
                            setModalState(() {});
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildOptionButton({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    IconData? icon,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.shade50 : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey.shade300,
            width: 2,
          ),
        ),
        child: Column(
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                color: isSelected ? Colors.blue : Colors.grey.shade600,
                size: 28,
              ),
              const SizedBox(height: 8),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? Colors.blue : Colors.grey.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}