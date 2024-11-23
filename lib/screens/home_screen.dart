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
    // Define gradient colors based on the card type
    List<Color> gradientColors;
    Color shadowColor;
    
    switch (title) {
      case 'Savings':
        gradientColors = const [
          Color(0xFF00E676), // Vibrant green
          Color(0xFF00C897), // Medium green
          Color(0xFF00A572), // Deep green
        ];
        shadowColor = const Color(0xFF00C897);
        break;
      case 'Loans':
        gradientColors = const [
          Color(0xFFFF6B6B), // Bright red
          Color(0xFFFF5252), // Medium red
          Color(0xFFFF4949), // Deep red
        ];
        shadowColor = const Color(0xFFFF6B6B);
        break;
      case 'Share Capital':
        gradientColors = const [
          Color(0xFF4FC3F7), // Light blue
          Color(0xFF4DABF7), // Medium blue
          Color(0xFF2B95E9), // Deep blue
        ];
        shadowColor = const Color(0xFF4DABF7);
        break;
      default:
        gradientColors = const [Color(0xFF6B4EFF), Color(0xFF9747FF)];
        shadowColor = const Color(0xFF6B4EFF);
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: const [0.0, 0.5, 1.0],
          colors: gradientColors,
        ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: shadowColor.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            if (title == 'Savings') {
              _showSavingsAccounts();
            }
          },
          borderRadius: BorderRadius.circular(15),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        amount,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white.withOpacity(0.8),
                  size: 20,
                ),
              ],
            ),
          ),
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
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              const Color(0xFF4C3FF7),
                              const Color(0xFF7C3FFF),
                              const Color(0xFF9D3FFF).withOpacity(0.9),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                account.productName,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Account: ${account.accountNo}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.white70,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Balance: ${account.currency.displaySymbol} ${NumberFormat("#,##0.00", "en_US").format(account.accountBalance ?? 0.0)}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Status: ${account.status.value}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: account.status.active ? Colors.green[100] : Colors.white70,
                                ),
                              ),
                            ],
                          ),
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

  Widget _buildInvestmentCard(String title, IconData icon, List<Color> gradientColors) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: gradientColors,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: gradientColors[0].withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              // TODO: Navigate to specific investment category
            },
            borderRadius: BorderRadius.circular(20),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    icon,
                    color: Colors.white,
                    size: 32,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileScreen() {
    return ProfileScreen(user: widget.user);
  }

  Widget _buildMainContent() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF6B4EFF),
                Color(0xFF9747FF),
              ],
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(25),
              bottomRight: Radius.circular(25),
            ),
            boxShadow: [
              BoxShadow(
                color: Color(0x1A000000),
                blurRadius: 10,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(
                  'https://ui-avatars.com/api/?name=${Uri.encodeComponent(widget.user?.displayName ?? "User")}&background=9747FF&color=fff',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome back,',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.7),
                      ),
                    ),
                    Text(
                      widget.user?.displayName ?? 'User',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: const Icon(
                  Icons.notifications_outlined,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: RefreshIndicator(
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
                  const SizedBox(height: 24),
                  FutureBuilder<List<SavingsAccountModel>>(
                    future: _savingsAccountsFuture,
                    builder: (context, snapshot) {
                      String amount = 'KES 0.00';
                      if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                        final totalSavings = snapshot.data!.fold<double>(
                          0.0,
                          (sum, account) => sum + (account.accountBalance ?? 0.0),
                        );
                        final firstAccount = snapshot.data!.first;
                        amount =
                            '${firstAccount.currency.displaySymbol} ${NumberFormat("#,##0.00", "en_US").format(totalSavings)}';
                      }
                      return _buildTotalBalanceCard(context, amount);
                    },
                  ),
                  const SizedBox(height: 32),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Product Summary',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF2D3142),
                          ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  FutureBuilder<List<SavingsAccountModel>>(
                    future: _savingsAccountsFuture,
                    builder: (context, snapshot) {
                      String amount = 'KES 0.00';
                      if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                        final totalSavings = snapshot.data!.fold<double>(
                          0.0,
                          (sum, account) => sum + (account.accountBalance ?? 0.0),
                        );
                        final firstAccount = snapshot.data!.first;
                        amount =
                            '${firstAccount.currency.displaySymbol} ${NumberFormat("#,##0.00", "en_US").format(totalSavings)}';
                      }
                      return _buildProductSummaryCard(
                        'Savings',
                        amount,
                        FontAwesomeIcons.piggyBank,
                      );
                    },
                  ),
                  _buildProductSummaryCard(
                    'Loans',
                    'KES 0.00',
                    FontAwesomeIcons.handHoldingDollar,
                  ),
                  _buildProductSummaryCard(
                    'Share Capital',
                    'KES 0.00',
                    FontAwesomeIcons.chartPie,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> screens = [
      _buildMainContent(),
      const InvestScreen(),
      _buildProfileScreen(),
    ];

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
