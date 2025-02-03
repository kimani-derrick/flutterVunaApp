import 'package:flutter/material.dart';
import '../models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/cache_service.dart';
import 'marketplace_screen.dart';

class ProfileScreen extends StatefulWidget {
  final UserModel? user;
  const ProfileScreen({Key? key, this.user}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? _selectedOffice;
  // Dummy office data - in real app, this would come from an API
  final List<Map<String, dynamic>> _offices = [
    {'id': 1, 'name': 'Head Office - Nairobi'},
    {'id': 2, 'name': 'Mombasa Branch'},
    {'id': 3, 'name': 'Kisumu Branch'},
    {'id': 4, 'name': 'Nakuru Branch'},
  ];

  @override
  Widget build(BuildContext context) {
    if (widget.user == null) {
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
        padding: const EdgeInsets.all(16.0),
        children: [
          CircleAvatar(
            radius: 50,
            backgroundImage: NetworkImage(
              'https://ui-avatars.com/api/?name=${Uri.encodeComponent(widget.user!.displayName)}&background=6C5DD3&color=fff&size=200',
            ),
          ),
          const SizedBox(height: 16),
          Text(
            widget.user!.displayName,
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
              _buildInfoItem(
                  Icons.person, 'Account No', widget.user!.accountNo),
              if (widget.user!.emailAddress != null)
                _buildInfoItem(
                    Icons.email, 'Email', widget.user!.emailAddress!),
              if (widget.user!.mobileNo != null)
                _buildInfoItem(Icons.phone, 'Phone', widget.user!.mobileNo!),
              _buildInfoItem(Icons.business, 'Office ID',
                  widget.user!.officeId.toString()),
            ],
          ),
          const SizedBox(height: 16),
          _buildSection(
            'Office Transfer Request',
            [
              const Text(
                'Select the office you would like to transfer to:',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _selectedOffice,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                hint: const Text('Select Target Office'),
                items: _offices
                    .where((office) => office['id'] != widget.user!.officeId)
                    .map((office) => DropdownMenuItem(
                          value: office['id'].toString(),
                          child: Text(office['name']),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedOffice = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _selectedOffice == null
                    ? null
                    : () {
                        // Show confirmation dialog
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Confirm Transfer Request'),
                            content: Text(
                                'Are you sure you want to request transfer to ${_offices.firstWhere((office) => office['id'].toString() == _selectedOffice)['name']}?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  // TODO: Implement actual transfer request
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          'Transfer request submitted successfully'),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                  setState(() {
                                    _selectedOffice = null;
                                  });
                                },
                                child: const Text('Confirm'),
                              ),
                            ],
                          ),
                        );
                      },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 45),
                ),
                child: const Text('Submit Transfer Request'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildSection(
            'Account Settings',
            [
              ElevatedButton(
                onPressed: () => _logout(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[400],
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 45),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Logout',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Future<void> _logout(BuildContext context) async {
    debugPrint('\n🚪 Logout initiated');
    debugPrint('🗑️ Clearing all cache before logout...');
    // Clear all cache when logging out
    await CacheService.clearCache();
    debugPrint('✅ Cache cleared successfully');

    // Clear stored credentials
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    if (!mounted) return;

    // Navigate to marketplace screen and remove all previous routes
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const MarketplaceScreen()),
      (route) => false,
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Card(
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
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: const TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(value),
        ],
      ),
    );
  }
}
