import 'package:flutter/material.dart';
import '../app/bottom_nav_controller.dart';

class Contact {
  final String name;
  final String phone;
  final String email;
  final String role;
  final String department;

  Contact(this.name, this.phone, this.email, this.role, this.department);
}

class ContactsPage extends StatefulWidget {
  const ContactsPage({super.key});

  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  List<Contact> _contacts = [];

  @override
  void initState() {
    super.initState();
    _loadContacts();
  }

  void _loadContacts() {
    _contacts = [
      Contact(
        'Prof. Zhang',
        '13800138001',
        'zhang.prof@university.edu.cn',
        'Professor',
        'Computer Science Department',
      ),
      Contact(
        'Dr. Li',
        '13800138002',
        'li.teacher@university.edu.cn',
        'Associate Professor',
        'Software Engineering Department',
      ),
      Contact(
        'Dean Wang',
        '13800138003',
        'wang.dean@university.edu.cn',
        'Department Chair',
        'Computer Science Department',
      ),
      Contact(
        'Liu (Student)',
        '13800138004',
        'liu.student@student.edu.cn',
        'Student',
        'Software Engineering Year 3',
      ),
      Contact(
        'Chen (Student)',
        '13800138005',
        'chen.student@student.edu.cn',
        'Student',
        'Computer Science Year 3',
      ),
      Contact('TA Zhao', '13800138006', 'zhao.ta@university.edu.cn', 'Teaching Assistant', 'AI Department'),
      Contact(
        'Prof. Sun',
        '13800138007',
        'sun.prof@university.edu.cn',
        'Professor',
        'Data Science Department',
      ),
      Contact(
        'Zhou (Class Monitor)',
        '13800138008',
        'zhou.student@student.edu.cn',
        'Class Monitor',
        'Software Engineering Year 3',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contacts'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.home),
          onPressed: () {
            final navigator = HomeNavigator.of(context);
            if (navigator != null) {
              navigator.navigateToHome();
            }
          },
          tooltip: 'Back to Home',
        ),
      ),
      backgroundColor: const Color(0xFFF8F5F0),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _contacts.length,
        itemBuilder: (context, index) {
          final contact = _contacts[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: CircleAvatar(
                backgroundColor: Colors.blue.shade100,
                child: Text(
                  contact.name.isNotEmpty ? contact.name[0] : '?',
                  style: TextStyle(
                    color: Colors.blue.shade800,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              title: Text(
                contact.name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    contact.role,
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                  Text(
                    contact.department,
                    style: TextStyle(color: Colors.grey[500], fontSize: 11),
                  ),
                ],
              ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Icon(Icons.phone, size: 16, color: Colors.grey[600]),
                  const SizedBox(height: 4),
                  Icon(Icons.email, size: 16, color: Colors.grey[600]),
                ],
              ),
              onTap: () {
                _showContactDetails(contact);
              },
            ),
          );
        },
      ),
    );
  }

  void _showContactDetails(Contact contact) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.blue.shade100,
                  child: Text(
                    contact.name.isNotEmpty ? contact.name[0] : '?',
                    style: TextStyle(
                      color: Colors.blue.shade800,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        contact.name,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        contact.role,
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            _buildDetailItem(Icons.phone, 'Phone', contact.phone),
            _buildDetailItem(Icons.email, 'Email', contact.email),
            _buildDetailItem(Icons.business, 'Department', contact.department),

            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Calling ${contact.phone}...')),
                      );
                    },
                    icon: const Icon(Icons.phone),
                    label: const Text('Call'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Emailing ${contact.email}...')),
                      );
                    },
                    icon: const Icon(Icons.email),
                    label: const Text('Email'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 12),
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(
            child: Text(value, style: TextStyle(color: Colors.grey[700])),
          ),
        ],
      ),
    );
  }
}
