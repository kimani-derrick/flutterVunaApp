import 'package:flutter/material.dart';
import '../models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatelessWidget {
  final UserModel? user;
  const ProfileScreen({Key? key, this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final memberSince = DateTime.now().year.toString(); // Simplified for now

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // TODO: Implement edit profile
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.only(
          left: 16.0,
          right: 16.0,
          top: 16.0,
          bottom: 80.0,
        ),
        children: [
          CircleAvatar(
            radius: 50,
            backgroundImage: NetworkImage(
              'https://ui-avatars.com/api/?name=${Uri.encodeComponent(user!.displayName)}&background=6C5DD3&color=fff&size=200',
            ),
          ),
          const SizedBox(height: 16),
          Text(
            user!.displayName,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            'Member since $memberSince',
            style: const TextStyle(
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          _buildSection(
            'Personal Information',
            [
              _buildInfoItem(Icons.person, 'Account No', user!.accountNo),
              _buildInfoItem(Icons.email, 'Email', user!.emailAddress),
              _buildInfoItem(Icons.phone, 'Phone', user!.mobileNo),
              _buildInfoItem(Icons.business, 'Branch', user!.officeName),
            ],
          ),
          const SizedBox(height: 16),
          _buildSection(
            'Account Settings',
            [
              _buildSettingItem(
                Icons.lock,
                'Change Password',
                () {
                  // TODO: Implement change password
                },
              ),
              _buildSettingItem(
                Icons.notifications,
                'Notifications',
                () {
                  // TODO: Implement notifications settings
                },
              ),
              _buildSettingItem(
                Icons.security,
                'Security',
                () {
                  // TODO: Implement security settings
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () async {
              // Clear stored user data
              final prefs = await SharedPreferences.getInstance();
              await prefs.clear();
              
              if (!context.mounted) return;
              Navigator.of(context).pushReplacementNamed('/');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text('Logout'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF6C5DD3)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingItem(IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFF6C5DD3)),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
            const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }
}
