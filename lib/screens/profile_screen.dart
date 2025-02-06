import 'package:flutter/material.dart';
import '../models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/cache_service.dart';
import '../services/office_service.dart';
import 'marketplace_screen.dart';
import '../widgets/top_menu_bar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../config/api_config.dart';
import 'package:intl/intl.dart';

class ProfileScreen extends StatefulWidget {
  final UserModel? user;
  const ProfileScreen({Key? key, this.user}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? _selectedOfficeId;
  List<Map<String, dynamic>> _offices = [];
  bool _isLoading = false;
  bool _isTransferring = false;
  UserModel? _currentUser;

  @override
  void initState() {
    super.initState();
    _currentUser = widget.user;
    _loadOffices();
    _refreshUserData();
  }

  Future<void> _loadOffices() async {
    try {
      setState(() {
        _isLoading = true;
      });
      final offices = await OfficeService.getAllOffices(
        ApiConfig.defaultUsername,
        ApiConfig.defaultPassword,
      );
      setState(() {
        _offices = offices;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading offices: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _submitTransfer() async {
    if (_selectedOfficeId == null || widget.user == null) {
      debugPrint(
          '❌ Transfer cancelled: No destination office selected or user is null');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a destination office'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Check if transfer is from HEAD OFFICE
    if (_currentUser?.officeId != 1) {
      debugPrint(
          '❌ Transfer cancelled: Transfers only allowed from Market Place');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Office transfers are only allowed from Market Place to Cooperative'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    debugPrint('\n🚀 Starting client transfer process...');
    debugPrint('📋 Transfer Details:');
    debugPrint('- Client ID: ${widget.user!.id}');
    debugPrint('- Current Office ID: ${widget.user!.officeId}');
    debugPrint('- Destination Office ID: $_selectedOfficeId');
    debugPrint('- Client Name: ${widget.user!.displayName}');

    try {
      setState(() {
        _isTransferring = true;
      });
      debugPrint('🔄 Setting transfer state to loading...');

      // Step 1: Propose Transfer
      final proposeUrl =
          '${ApiConfig.baseUrl}/clients/${widget.user!.id}?command=proposeTransfer';
      final headers = ApiConfig.getHeaders(
        ApiConfig.defaultUsername,
        ApiConfig.defaultPassword,
      );

      debugPrint('\n📤 STEP 1: Proposing Transfer');
      debugPrint('URL: $proposeUrl');
      debugPrint(
          'Headers: ${const JsonEncoder.withIndent('  ').convert(headers)}');

      final proposePayload = {
        'destinationOfficeId': _selectedOfficeId,
        'note': '',
        'dateFormat': 'dd MMMM yyyy',
        'locale': 'en',
        'transferDate': DateFormat('dd MMMM yyyy').format(DateTime.now()),
      };
      debugPrint(
          'Payload: ${const JsonEncoder.withIndent('  ').convert(proposePayload)}');

      final proposeResponse = await http.post(
        Uri.parse(proposeUrl),
        headers: headers,
        body: json.encode(proposePayload),
      );

      debugPrint('\n📥 Propose Transfer Response:');
      debugPrint('Status Code: ${proposeResponse.statusCode}');
      debugPrint('Response Body: ${proposeResponse.body}');
      debugPrint('Response Headers: ${proposeResponse.headers}');

      if (proposeResponse.statusCode != 200) {
        throw Exception(
            'Failed to propose transfer: ${proposeResponse.statusCode}\nResponse: ${proposeResponse.body}');
      }
      debugPrint('✅ Transfer proposal successful');

      // Step 2: Accept Transfer
      debugPrint('\n📤 STEP 2: Accepting Transfer');
      final acceptUrl =
          '${ApiConfig.baseUrl}/clients/${widget.user!.id}?command=acceptTransfer';
      debugPrint('URL: $acceptUrl');

      final acceptPayload = {
        'note': 'yes',
      };
      debugPrint(
          'Payload: ${const JsonEncoder.withIndent('  ').convert(acceptPayload)}');

      final acceptResponse = await http.post(
        Uri.parse(acceptUrl),
        headers: headers,
        body: json.encode(acceptPayload),
      );

      debugPrint('\n📥 Accept Transfer Response:');
      debugPrint('Status Code: ${acceptResponse.statusCode}');
      debugPrint('Response Body: ${acceptResponse.body}');
      debugPrint('Response Headers: ${acceptResponse.headers}');

      if (acceptResponse.statusCode != 200) {
        throw Exception(
            'Failed to accept transfer: ${acceptResponse.statusCode}\nResponse: ${acceptResponse.body}');
      }
      debugPrint('✅ Transfer acceptance successful');

      // Update both local state and cache
      final updatedUser = UserModel(
        id: _currentUser!.id,
        accountNo: _currentUser!.accountNo,
        displayName: _currentUser!.displayName,
        officeId: int.parse(_selectedOfficeId!),
        emailAddress: _currentUser!.emailAddress,
        mobileNo: _currentUser!.mobileNo,
      );

      // Update cache
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_data', jsonEncode(updatedUser.toJson()));
      debugPrint('💾 Updated user data in cache');

      setState(() {
        _isTransferring = false;
        _currentUser = updatedUser;
        _selectedOfficeId = null;
      });
      debugPrint(
          '🔄 Updated local state with new office ID: ${updatedUser.officeId}');

      if (mounted) {
        debugPrint('\n🎉 Transfer process completed successfully!');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Transfer completed successfully'),
            backgroundColor: Colors.green,
          ),
        );
        debugPrint('🔄 Reloading offices list and refreshing UI...');
        await _loadOffices();
        setState(() {}); // Force UI refresh
      }
    } catch (e) {
      debugPrint('\n❌ ERROR during transfer process:');
      debugPrint(e.toString());
      debugPrint('Stack trace:');
      debugPrint(StackTrace.current.toString());

      setState(() {
        _isTransferring = false;
      });
      debugPrint('🔄 Setting transfer state to complete (after error)...');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Office transfer was not successful'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _refreshUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userData = prefs.getString('user_data');
      if (userData != null) {
        final userJson = jsonDecode(userData);
        setState(() {
          _currentUser = UserModel.fromJson(userJson);
        });
        debugPrint('✅ Refreshed user data from cache');
      }
    } catch (e) {
      debugPrint('❌ Error refreshing user data: $e');
    }
  }

  Future<void> _onRefresh() async {
    debugPrint('🔄 Pull-to-refresh triggered');
    await Future.wait([
      _loadOffices(),
      _refreshUserData(),
    ]);
    setState(() {});
    debugPrint('✅ Refresh completed');
  }

  @override
  Widget build(BuildContext context) {
    if (_currentUser == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final memberSince = DateTime.now().year.toString();
    final currentOffice = _offices.firstWhere(
      (office) => office['id'].toString() == _currentUser!.officeId.toString(),
      orElse: () => {'name': 'Unknown Office'},
    );

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            TopMenuBar(
              title: 'Profile',
              subtitle: 'Manage your account',
              userName: _currentUser?.displayName,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(
                      'https://ui-avatars.com/api/?name=${Uri.encodeComponent(_currentUser!.displayName)}&background=6C5DD3&color=fff&size=200',
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _currentUser!.displayName,
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
                          Icons.person, 'Account No', _currentUser!.accountNo),
                      if (_currentUser!.emailAddress != null)
                        _buildInfoItem(
                            Icons.email, 'Email', _currentUser!.emailAddress!),
                      if (_currentUser!.mobileNo != null)
                        _buildInfoItem(
                            Icons.phone, 'Phone', _currentUser!.mobileNo!),
                      _buildInfoItem(Icons.business, 'Office',
                          '${currentOffice['name']} (ID: ${_currentUser!.officeId})'),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildOfficeTransferSection(),
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOfficeTransferSection() {
    // Only show transfer section if user is in HEAD OFFICE
    if (_currentUser?.officeId != 1) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Office Transfer',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Office transfers are only allowed from Market Place to Cooperative.',
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Office Transfer',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else
              Column(
                children: [
                  DropdownButtonFormField<String>(
                    value: _selectedOfficeId,
                    decoration: const InputDecoration(
                      labelText: 'Select Destination Office',
                      border: OutlineInputBorder(),
                    ),
                    items: _offices
                        .where((office) =>
                            office['id'].toString() !=
                            _currentUser!.officeId.toString())
                        .map((office) {
                      final officeId = office['id'].toString();
                      debugPrint(
                          'Creating dropdown item for office: ${office['name']} with ID: $officeId');
                      return DropdownMenuItem<String>(
                        value: officeId,
                        child: Text(office['name']),
                      );
                    }).toList()
                      ..sort((a, b) => (a.child as Text).data!.compareTo(
                          (b.child as Text).data!)), // Sort by office name
                    onChanged: (value) {
                      debugPrint('Selected office ID: $value');
                      setState(() {
                        _selectedOfficeId = value;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _isTransferring ? null : _submitTransfer,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 45),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: _isTransferring
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Text('Submit Transfer'),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _logout(BuildContext context) async {
    await CacheService.clearCache();
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    if (!mounted) return;

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
