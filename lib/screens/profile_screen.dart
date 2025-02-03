import 'package:flutter/material.dart';
import '../models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/cache_service.dart';
import '../services/office_service.dart';
import 'marketplace_screen.dart';
import '../widgets/top_menu_bar.dart';

class ProfileScreen extends StatefulWidget {
  final UserModel? user;
  const ProfileScreen({Key? key, this.user}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Office transfer functionality temporarily hidden
  // String? _selectedOfficeId;
  // List<Map<String, dynamic>> _offices = [];
  // bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // _loadOffices(); // Office loading temporarily disabled
  }

  // Future<void> _loadOffices() async {
  //   try {
  //     setState(() {
  //       _isLoading = true;
  //     });
  //     final offices = await OfficeService.getAllOffices();
  //     setState(() {
  //       _offices = offices;
  //       _isLoading = false;
  //     });
  //   } catch (e) {
  //     setState(() {
  //       _isLoading = false;
  //     });
  //     if (mounted) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //           content: Text('Error loading offices: $e'),
  //           backgroundColor: Colors.red,
  //         ),
  //       );
  //     }
  //   }
  // }

  // Future<void> _submitTransfer() async {
  //   // Transfer functionality temporarily hidden
  // }

  @override
  Widget build(BuildContext context) {
    if (widget.user == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final memberSince = DateTime.now().year.toString(); // Simplified for now
    // final currentOffice = _offices.firstWhere(
    //   (office) => office['id'] == widget.user!.officeId,
    //   orElse: () => {'name': 'Unknown Office'},
    // );

    return Scaffold(
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          TopMenuBar(
            title: 'Profile',
            subtitle: 'Manage your account',
            userName: widget.user?.displayName,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
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
                      _buildInfoItem(
                          Icons.phone, 'Phone', widget.user!.mobileNo!),
                    // Office display temporarily hidden
                    // _buildInfoItem(Icons.business, 'Office', currentOffice['name']),
                  ],
                ),
                const SizedBox(height: 16),
                // Office transfer section temporarily hidden
                // _buildOfficeTransferSection(),
                // const SizedBox(height: 16),
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
          ),
        ],
      ),
    );
  }

  // Widget _buildOfficeTransferSection() {
  //   // Office transfer section temporarily hidden
  // }

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
