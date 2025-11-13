import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/user_model.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.loggedInUser});

  final UserModel loggedInUser;

  @override
  Widget build(BuildContext context) {
    final Color bgColor = const Color(0xFFF8F5F0);
    final Color cardColor = Colors.white;
    final TextStyle titleStyle =
    GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold);
    final TextStyle subtitleStyle = GoogleFonts.poppins(fontSize: 14);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0, //bar阴影
        title: const Text(''),
        toolbarHeight: 0, //隐藏bar空间
      ),
      body: SingleChildScrollView( //滚动视图
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 顶部用户栏
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(52),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundImage: NetworkImage(loggedInUser.avatarUrl),
                    //child: Icon(Icons.person, color: Colors.grey[300]),
                  ),
                  SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('👋 Hello!!!', style: subtitleStyle),
                      Text(
                        loggedInUser.userName,
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      iconSize: 24,
                      icon: Icon(Icons.notifications),
                      onPressed: () {
                        // notification
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),

            // notification card
            SizedBox(
              height: 120,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _eventCard(
                    title: "New Event",
                    date: "24 June, 2025",
                    desc: "We are waiting for everyone at the Pantry at 4 p.m.",
                    icon: Icons.event_available,
                  ),
                  const SizedBox(width: 16),
                  _eventCard(
                    title: "David Birthday",
                    date: "12 June, 2025",
                    desc: "Don't forget to congratulate our product manager on this great day.",
                    icon: Icons.cake,
                  ),
                  const SizedBox(width: 16),
                  _eventCard(
                    title: "Team Meeting",
                    date: "10 June, 2025",
                    desc: "Join the team meeting at 10 a.m. in the conference room.",
                    icon: Icons.meeting_room,
                  ),
                  const SizedBox(width: 16),
                  _eventCard(
                    title: "Project Deadline",
                    date: "30 June, 2025",
                    desc: "Submit the project report before the deadline.",
                    icon: Icons.date_range,
                  ),
                  const SizedBox(width: 16),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // service title
            Text('Services', style: titleStyle.copyWith(color: Colors.grey[800])),
            SizedBox(height: 8),

            // service
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                _serviceCard(
                  image: "assets/images/muti-mode.png",
                  color: const Color(0xFFF5F2E9),
                  title: "Muti-mode Navigation",
                  subtitle: "Plan your Route",
                ),
                _serviceCard(
                  image: "assets/images/smart-path.png",
                  color: const Color(0xFFF5F2E9),
                  title: "Smart Path Planning",
                  subtitle: "Classroom, Cafe & More",
                ),
                _serviceCard(
                  image: "assets/images/smart-path.png",
                  color: const Color(0xFFF5F2E9),
                  title: "Real-time Information Sync",
                  subtitle: "News and Updates",
                ),
                _serviceCard(
                  image: "assets/images/smart-path.png",
                  color: const Color(0xFFF5F2E9),
                  title: "Smart Campus Notifications",
                  subtitle: "Accurate & Convenient",
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // 单个通知卡片
  Widget _eventCard({
    required String title,
    required String date,
    required String desc,
    required IconData icon,
  }) {
    return Container(
      width: 230,
      height: 120,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
          ),
        ],
      ),
      padding: const EdgeInsets.all(14), // 卡片内部的内边距
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.green[400]),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            date,
            style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600]),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
          const SizedBox(height: 6),
          Text(
            desc,
            style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[700]),
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
        ],
      ),
    );
  }

  // 单个服务卡片
  Widget _serviceCard({
    required String image,
    required Color color,
    required String title,
    required String subtitle,
  }) {
    return Container(
      width: 190,
      height: 230,
      decoration: BoxDecoration(
        color: Colors.white,
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
                style: GoogleFonts.poppins(
                    fontSize: 14, fontWeight: FontWeight.w600)),
            const SizedBox(height: 4),
            Text(subtitle,
                style: GoogleFonts.poppins(
                    fontSize: 12, color: Colors.grey[700])),
          ],
        ),
      ),
    );
  }
}