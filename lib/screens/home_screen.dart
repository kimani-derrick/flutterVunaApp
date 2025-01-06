import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import '../models/user_model.dart';
import '../models/savings_account_model.dart';
import '../screens/profile_screen.dart';
import '../screens/invest_screen.dart';
import '../widgets/top_menu_bar.dart';
import '../screens/mini_statement_screen.dart';
import '../services/group_service.dart';
import '../screens/group_transactions_screen.dart';

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
  List<Map<String, dynamic>> groupAccounts = [];
  bool isLoading = true;
  String? errorMessage;
  Future<List<SavingsAccountModel>>? _savingsAccountsFuture;
  late Future<List<Map<String, dynamic>>> _groupAccountsFuture;
  double totalBalance = 0.0;
  String? userName;

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  Future<void> _refreshData() async {
    setState(() {
      isLoading = true;
      _savingsAccountsFuture = fetchSavingsAccounts();
      _groupAccountsFuture = fetchGroupAccounts();
    });

    try {
      // Fetch and update savings accounts
      final fetchedSavingsAccounts = await _savingsAccountsFuture ?? [];
      final groups = await _groupAccountsFuture;

      // Calculate total balance from savings accounts
      double total = 0.0;
      for (var account in fetchedSavingsAccounts) {
        total += account.accountBalance ?? 0.0;
      }

      setState(() {
        savingsAccounts = fetchedSavingsAccounts;
        groupAccounts = groups;
        totalBalance = total;
        isLoading = false;
      });
    } catch (e) {
      debugPrint('Error calculating total balance: $e');
      setState(() {
        isLoading = false;
        errorMessage = e.toString();
      });
    }
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

      debugPrint('\n🔐 Savings Auth Details:');
      debugPrint('Username: $username');
      debugPrint('Password: [REDACTED]');
      debugPrint('ClientId: $clientId');

      if (username == null || password == null || clientId == null) {
        throw Exception('Missing credentials or client ID');
      }

      final credentials = base64.encode(utf8.encode('$username:$password'));
      debugPrint('\nSavings API Call:');
      debugPrint(
          'URL: https://api.vuna.io/fineract-provider/api/v1/self/clients/$clientId/accounts');
      debugPrint('Authorization: Basic $credentials');

      final response = await http.get(
        Uri.parse(
            'https://api.vuna.io/fineract-provider/api/v1/self/clients/$clientId/accounts'),
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
        throw Exception(
            'Failed to load savings accounts: ${response.statusCode}');
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

  void _showGroupAccounts() {
    debugPrint('\n🎯 _showGroupAccounts called');
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        debugPrint('🏗️ Building bottom sheet');
        return DraggableScrollableSheet(
          initialChildSize: 0.9,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          builder: (_, controller) => Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Merry Go Round Groups',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: FutureBuilder<List<Map<String, dynamic>>>(
                    future: _groupAccountsFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      if (snapshot.hasError) {
                        debugPrint('Error in group display: ${snapshot.error}');
                        return Center(
                          child: Text('Error: ${snapshot.error}'),
                        );
                      }

                      final groups = snapshot.data ?? [];
                      debugPrint(
                          'Number of groups to display: ${groups.length}');

                      if (groups.isEmpty) {
                        return const Center(
                          child: Text(
                            'No group accounts found',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        );
                      }

                      return ListView.builder(
                        controller: controller,
                        itemCount: groups.length,
                        itemBuilder: (context, index) {
                          final group = groups[index];
                          final balance = group['balance'] ?? 0.0;
                          final currency =
                              group['currency']?['displaySymbol'] ?? 'KES';
                          final status = group['status']?['value'] ?? 'Unknown';
                          final accountNo = group['accountNo'] ?? 'N/A';
                          final staffName = group['staffName'];
                          final officeName = group['officeName'];
                          final submittedDate =
                              group['timeline']?['submittedOnDate'] != null
                                  ? DateTime(
                                      group['timeline']['submittedOnDate'][0],
                                      group['timeline']['submittedOnDate'][1],
                                      group['timeline']['submittedOnDate'][2],
                                    )
                                  : null;

                          return Card(
                            margin: const EdgeInsets.only(bottom: 16),
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: InkWell(
                              onTap: () {
                                if (group['savingsAccountId'] != null) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          GroupTransactionsScreen(
                                        accountId: group['savingsAccountId']
                                            .toString(),
                                        groupName:
                                            group['name'] ?? 'Unnamed Group',
                                        accountNo:
                                            group['savingsAccountNo'] ?? 'N/A',
                                      ),
                                    ),
                                  );
                                }
                              },
                              borderRadius: BorderRadius.circular(12),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            group['name'] ?? 'Unnamed Group',
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: status == 'Active'
                                                ? Colors.green.withOpacity(0.1)
                                                : Colors.orange
                                                    .withOpacity(0.1),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: Text(
                                            status,
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                              color: status == 'Active'
                                                  ? Colors.green
                                                  : Colors.orange,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    Row(
                                      children: [
                                        Icon(
                                          FontAwesomeIcons.hashtag,
                                          size: 14,
                                          color: Colors.grey[600],
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          group['savingsAccountNo'] ??
                                              accountNo,
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                    ),
                                    if (staffName != null) ...[
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          Icon(
                                            FontAwesomeIcons.userTie,
                                            size: 14,
                                            color: Colors.grey[600],
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            'Staff: $staffName',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                    if (officeName != null) ...[
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          Icon(
                                            FontAwesomeIcons.building,
                                            size: 14,
                                            color: Colors.grey[600],
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            officeName,
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                    if (submittedDate != null) ...[
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          Icon(
                                            FontAwesomeIcons.calendar,
                                            size: 14,
                                            color: Colors.grey[600],
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            'Created: ${DateFormat('MMM d, y').format(submittedDate)}',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                    const SizedBox(height: 16),
                                    Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF4C3FF7)
                                            .withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Balance',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.grey[800],
                                            ),
                                          ),
                                          Text(
                                            '$currency ${NumberFormat('#,##0.00').format(balance)}',
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF4C3FF7),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
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
      },
    );
  }

  Future<List<Map<String, dynamic>>> fetchGroupAccounts() async {
    try {
      final officeId = widget.user?.officeId;
      final clientId = widget.user?.id;
      debugPrint('\n🔄 Fetching group accounts...');
      debugPrint('Office ID: $officeId');
      debugPrint('Client ID: $clientId');
      debugPrint('Username being used: ${widget.username}');

      if (widget.username == null ||
          widget.password == null ||
          officeId == null) {
        debugPrint('❌ Missing credentials or office ID');
        throw Exception('Missing credentials or office ID');
      }

      final groups = await GroupService.getGroupsByOfficeId(
        widget.username!,
        widget.password!,
        officeId.toString(),
      );

      debugPrint('\n📊 Found ${groups.length} groups');

      // Fetch balances for each group
      for (var group in groups) {
        final groupId = group['id'].toString();
        debugPrint('\n💰 Fetching balance for group $groupId');

        try {
          final balanceData = await GroupService.getGroupBalance(
            widget.username!,
            widget.password!,
            groupId,
          );

          // Add balance information to the group data
          if (balanceData['savingsAccounts'] != null &&
              (balanceData['savingsAccounts'] as List).isNotEmpty) {
            final savingsAccount = balanceData['savingsAccounts'][0];
            group['balance'] = savingsAccount['accountBalance'] ?? 0.0;
            group['currency'] = savingsAccount['currency'];
            group['savingsAccountId'] = savingsAccount['id'];
            group['savingsAccountNo'] = savingsAccount['accountNo'];
            debugPrint('✅ Added balance info for group $groupId:');
            debugPrint('Balance: ${group['balance']}');
            debugPrint('Currency: ${group['currency']}');
            debugPrint(
                'Savings Account ID: ${group['savingsAccountId']} (from savingsAccounts[0].id)');
            debugPrint('Savings Account No: ${group['savingsAccountNo']}');
          } else {
            debugPrint('⚠️ No savings accounts found for group $groupId');
            group['balance'] = 0.0;
            group['currency'] = {'displaySymbol': 'KES'};
            group['savingsAccountId'] = null;
            group['savingsAccountNo'] = null;
          }
        } catch (e) {
          debugPrint('⚠️ Error fetching balance for group $groupId: $e');
          group['balance'] = 0.0;
          group['currency'] = {'displaySymbol': 'KES'};
        }
      }

      debugPrint('\n✅ Final groups data:');
      for (var group in groups) {
        debugPrint('Group: ${group['name']}');
        debugPrint('Balance: ${group['balance']}');
        debugPrint('Currency: ${group['currency']}');
      }

      return groups;
    } catch (e) {
      debugPrint('\n❌ Error fetching group accounts: $e');
      setState(() {
        errorMessage = e.toString();
      });
      return [];
    }
  }

  Widget _buildProductSummaryCard(String title, String amount, IconData icon,
      {int? count}) {
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
      ),
      child: InkWell(
        onTap: () {
          switch (title) {
            case 'Savings':
              _showSavingsAccounts();
              break;
            case 'Loans':
              // Handle loans tap
              break;
            case 'Share Capital':
              // Handle share capital tap
              break;
          }
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
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
                    Row(
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF424242),
                          ),
                        ),
                        if (count != null) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  FontAwesomeIcons.layerGroup,
                                  size: 12,
                                  color: primaryColor,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '$count account${count != 1 ? 's' : ''}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: primaryColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      amount,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF424242).withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
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
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (_, controller) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: const EdgeInsets.all(16),
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
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: FutureBuilder<List<SavingsAccountModel>>(
                  future: _savingsAccountsFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Color(0xFF4C3FF7)),
                        ),
                      );
                    }

                    if (snapshot.hasError) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.error_outline,
                              color: Colors.red,
                              size: 48,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Error loading accounts',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.red[700],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              snapshot.error.toString(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    final accounts = snapshot.data ?? [];
                    if (accounts.isEmpty) {
                      return const Center(
                        child: Text(
                          'No savings accounts found',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey,
                          ),
                        ),
                      );
                    }

                    return ListView.builder(
                      controller: controller,
                      itemCount: accounts.length,
                      itemBuilder: (context, index) {
                        final account = accounts[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 16),
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: InkWell(
                            onTap: () {
                              Navigator.pop(context); // Close bottom sheet
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MiniStatementScreen(
                                    accountId: account.id.toString(),
                                    accountName: account.productName,
                                  ),
                                ),
                              );
                            },
                            borderRadius: BorderRadius.circular(12),
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
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Account No: ${account.accountNo}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Balance',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                      Text(
                                        'KES ${NumberFormat('#,##0.00').format(account.accountBalance)}',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF4C3FF7),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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

  Widget _buildBalanceCard(double balance) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF4C3FF7),
            Color(0xFF7C3FFF),
            Color(0xFF9D3FFF),
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
            NumberFormat.currency(
              locale: 'en_KE',
              symbol: 'KES ',
            ).format(balance),
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
                TopMenuBar(
                  userName: widget.user?.displayName,
                  subtitle: 'User',
                ),
                // Total Balance Card
                _buildTotalBalanceCard(
                  context,
                  NumberFormat.currency(locale: 'en_KE', symbol: 'KES ')
                      .format(totalBalance),
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
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              _buildProductSummaryCard(
                                'Savings',
                                NumberFormat.currency(
                                        locale: 'en_KE', symbol: 'KES ')
                                    .format(totalBalance),
                                FontAwesomeIcons.piggyBank,
                                count: savingsAccounts.length,
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
                              const SizedBox(height: 8),
                              Card(
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  side: BorderSide(
                                    color: const Color(0xFF424242)
                                        .withOpacity(0.1),
                                    width: 1,
                                  ),
                                ),
                                child: InkWell(
                                  onTap: _showGroupAccounts,
                                  borderRadius: BorderRadius.circular(12),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(12),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFF5F5F5),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: const Icon(
                                            FontAwesomeIcons.peopleGroup,
                                            color: Color(0xFF424242),
                                            size: 24,
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Row(
                                                children: [
                                                  const Text(
                                                    'Merry Go Round',
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Color(0xFF424242),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Container(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                      horizontal: 8,
                                                      vertical: 2,
                                                    ),
                                                    decoration: BoxDecoration(
                                                      color: const Color(
                                                              0xFF4C3FF7)
                                                          .withOpacity(0.1),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                    ),
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        const Icon(
                                                          FontAwesomeIcons
                                                              .layerGroup,
                                                          size: 12,
                                                          color:
                                                              Color(0xFF4C3FF7),
                                                        ),
                                                        const SizedBox(
                                                            width: 4),
                                                        Text(
                                                          '${groupAccounts.length} group${groupAccounts.length != 1 ? 's' : ''}',
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color: Color(
                                                                0xFF4C3FF7),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                NumberFormat.currency(
                                                  locale: 'en_KE',
                                                  symbol: 'KES ',
                                                ).format(
                                                    groupAccounts.fold<double>(
                                                  0,
                                                  (sum, group) =>
                                                      sum +
                                                      ((group['balance']
                                                                  as num?)
                                                              ?.toDouble() ??
                                                          0.0),
                                                )),
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500,
                                                  color: const Color(0xFF424242)
                                                      .withOpacity(0.8),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Icon(
                                          Icons.keyboard_arrow_right,
                                          color: const Color(0xFF424242)
                                              .withOpacity(0.5),
                                          size: 24,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _refreshData,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TopMenuBar(
                  title: 'Welcome back',
                  subtitle: 'Member',
                  userName: widget.user?.displayName ?? userName,
                ),
                if (isLoading)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(24.0),
                      child: CircularProgressIndicator(),
                    ),
                  )
                else if (errorMessage != null)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Text(
                        'Error: $errorMessage',
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  )
                else
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildBalanceCard(totalBalance),
                        const SizedBox(height: 24),
                        Text(
                          'Products',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[800],
                          ),
                        ),
                        const SizedBox(height: 12),
                        _buildProductSummaryCard(
                          'Savings',
                          NumberFormat.currency(locale: 'en_KE', symbol: 'KES ')
                              .format(totalBalance),
                          FontAwesomeIcons.piggyBank,
                          count: savingsAccounts.length,
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
                        const SizedBox(height: 8),
                        Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(
                              color: const Color(0xFF424242).withOpacity(0.1),
                              width: 1,
                            ),
                          ),
                          child: InkWell(
                            onTap: _showGroupAccounts,
                            borderRadius: BorderRadius.circular(12),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF5F5F5),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Icon(
                                      FontAwesomeIcons.peopleGroup,
                                      color: Color(0xFF424242),
                                      size: 24,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Row(
                                          children: [
                                            const Text(
                                              'Merry Go Round',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                color: Color(0xFF424242),
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 8,
                                                vertical: 2,
                                              ),
                                              decoration: BoxDecoration(
                                                color: const Color(0xFF4C3FF7)
                                                    .withOpacity(0.1),
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  const Icon(
                                                    FontAwesomeIcons.layerGroup,
                                                    size: 12,
                                                    color: Color(0xFF4C3FF7),
                                                  ),
                                                  const SizedBox(width: 4),
                                                  Text(
                                                    '${groupAccounts.length} group${groupAccounts.length != 1 ? 's' : ''}',
                                                    style: const TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Color(0xFF4C3FF7),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          NumberFormat.currency(
                                            locale: 'en_KE',
                                            symbol: 'KES ',
                                          ).format(groupAccounts.fold<double>(
                                            0,
                                            (sum, group) =>
                                                sum +
                                                ((group['balance'] as num?)
                                                        ?.toDouble() ??
                                                    0.0),
                                          )),
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500,
                                            color: const Color(0xFF424242)
                                                .withOpacity(0.8),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Icon(
                                    Icons.keyboard_arrow_right,
                                    color: const Color(0xFF424242)
                                        .withOpacity(0.5),
                                    size: 24,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
