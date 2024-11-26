import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import '../models/user_model.dart';
import '../models/savings_account_model.dart';
import '../screens/profile_screen.dart';
import '../screens/invest_screen.dart';

class HomeScreen extends StatefulWidget {
  final String? username;
  final String? password;
  final UserModel? user;

  const HomeScreen({
    Key? key,
    this.username,
    this.password,
    this.user,
  }) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<SavingsAccountModel> savingsAccounts = [];
  bool isLoading = true;
  String? errorMessage;
  Future<List<SavingsAccountModel>>? _savingsAccountsFuture;
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _savingsAccountsFuture = fetchSavingsAccounts();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<List<SavingsAccountModel>> fetchSavingsAccounts() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      final username = widget.username;
      final password = widget.password;
      final clientId = widget.user?.id;

      if (username == null || password == null || clientId == null) {
        throw Exception('Missing credentials or client ID');
      }

      final credentials = base64.encode(utf8.encode('$username:$password'));
      final response = await http.get(
        Uri.parse('https://api.vuna.io/fineract-provider/api/v1/self/clients/$clientId/accounts'),
        headers: {
          'accept': 'application/json',
          'Authorization': 'Basic $credentials',
          'fineract-platform-tenantid': 'default',
        },
      );

      debugPrint('Savings API Response: ${response.statusCode}');
      debugPrint('Savings API Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> savingsAccounts = data['savingsAccounts'] ?? [];
        
        return savingsAccounts
            .map((account) => SavingsAccountModel.fromJson(account))
            .toList();
      } else {
        throw Exception('Failed to load savings accounts: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error fetching savings accounts: $e');
      setState(() {
        errorMessage = e.toString();
      });
      return [];
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Widget _buildProductSummaryCard(String title, String amount, IconData icon) {
    Color primaryColor;
    Color backgroundColor;

    switch (title) {
      case 'Savings':
        primaryColor = const Color(0xFF2E7D32);
        backgroundColor = const Color(0xFFE8F5E9);
        break;
      case 'Loans':
        primaryColor = const Color(0xFF1565C0);
        backgroundColor = const Color(0xFFE3F2FD);
        break;
      default:
        primaryColor = const Color(0xFF424242);
        backgroundColor = const Color(0xFFF5F5F5);
    }

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: primaryColor.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: () {
          if (title == 'Savings') {
            _showSavingsAccounts();
          }
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: primaryColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: primaryColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      amount,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: primaryColor.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: primaryColor.withOpacity(0.5),
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSavingsAccounts() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.75,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF6B4EFF),
                    Color(0xFF9747FF),
                  ],
                ),
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Savings Accounts',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: FutureBuilder<List<SavingsAccountModel>>(
                future: _savingsAccountsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text('No savings accounts found'),
                    );
                  }

                  final accounts = snapshot.data!;
                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: accounts.length,
                    itemBuilder: (context, index) {
                      final account = accounts[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF1E88E5).withOpacity(0.1),
                              offset: const Offset(0, 4),
                              blurRadius: 12,
                            ),
                          ],
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.white,
                              const Color(0xFF1E88E5).withOpacity(0.05),
                            ],
                          ),
                        ),
                        child: Stack(
                          children: [
                            Positioned(
                              right: -20,
                              top: -20,
                              child: Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      const Color(0xFF1E88E5).withOpacity(0.1),
                                      const Color(0xFF1565C0).withOpacity(0.05),
                                    ],
                                  ),
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF1E88E5).withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: const Icon(
                                          FontAwesomeIcons.piggyBank,
                                          color: Color(0xFF1E88E5),
                                          size: 20,
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              account.productName,
                                              style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xFF1E88E5),
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              'Account: ${account.accountNo}',
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey[600],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF1E88E5).withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      'Balance: ${NumberFormat.currency(locale: 'en_US', symbol: '\$').format(account.accountBalance)}',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF1E88E5),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTotalBalanceCard(BuildContext context, String amount) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF4C3FF7),
            const Color(0xFF7C3FFF),
            const Color(0xFF9D3FFF).withOpacity(0.9),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4C3FF7).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total Balance',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        FontAwesomeIcons.wallet,
                        color: Colors.white,
                        size: 14,
                      ),
                      SizedBox(width: 6),
                      Text(
                        'Wallet',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              amount,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    FontAwesomeIcons.chartLine,
                    color: Colors.white70,
                    size: 16,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'View Analytics',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainContent() {
    return FutureBuilder<List<SavingsAccountModel>>(
      future: _savingsAccountsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final accounts = snapshot.data ?? [];
        final totalBalance = accounts.fold<double>(
          0,
          (sum, account) => sum + (account.accountBalance ?? 0),
        );

        return RefreshIndicator(
          onRefresh: () async {
            setState(() {
              _savingsAccountsFuture = fetchSavingsAccounts();
            });
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Menu Bar
                Container(
                  margin: const EdgeInsets.all(16.0),
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF1E88E5),  // Primary blue
                        Color(0xFF1565C0),  // Darker blue
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF1E88E5).withOpacity(0.3),
                        spreadRadius: 1,
                        blurRadius: 10,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Welcome back,',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white70,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.user?.displayName ?? 'User',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              spreadRadius: 1,
                              blurRadius: 5,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        child: const CircleAvatar(
                          radius: 24,
                          backgroundColor: Colors.transparent,
                          child: Icon(
                            Icons.person,
                            size: 30,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Total Balance Card
                _buildTotalBalanceCard(
                  context,
                  NumberFormat.currency(locale: 'en_US', symbol: '\$').format(totalBalance),
                ),
                const SizedBox(height: 24),

                // Product Summary Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Product Summary',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildProductSummaryCard(
                        'Savings',
                        NumberFormat.currency(locale: 'en_US', symbol: '\$').format(totalBalance),
                        FontAwesomeIcons.piggyBank,
                      ),
                      const SizedBox(height: 8),
                      _buildProductSummaryCard(
                        'Loans',
                        'Apply Now',
                        FontAwesomeIcons.handHoldingDollar,
                      ),
                      const SizedBox(height: 8),
                      _buildProductSummaryCard(
                        'Share Capital',
                        'View Details',
                        FontAwesomeIcons.chartPie,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }

  List<Widget> _buildScreens() {
    return [
      _buildMainContent(),
      InvestScreen(username: widget.username, password: widget.password, user: widget.user),
      ProfileScreen(user: widget.user),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final screens = _buildScreens();
    return Scaffold(
      body: SafeArea(
        child: screens[_selectedIndex],
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF6B4EFF),
              Color(0xFF9747FF),
            ],
          ),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF6B4EFF).withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            backgroundColor: Colors.transparent,
            elevation: 0,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white.withOpacity(0.6),
            selectedFontSize: 14,
            unselectedFontSize: 12,
            type: BottomNavigationBarType.fixed,
            items: const [
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(bottom: 4),
                  child: Icon(FontAwesomeIcons.house),
                ),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(bottom: 4),
                  child: Icon(FontAwesomeIcons.chartLine),
                ),
                label: 'Invest',
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(bottom: 4),
                  child: Icon(FontAwesomeIcons.user),
                ),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
