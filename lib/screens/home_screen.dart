import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFF5F6F8), Color(0xFFFFFFFF)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Welcome Back,',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF2D3142),
                    ),
                  ),
                  const Text(
                    'John Doe',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4C3FF7),
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildTotalBalanceCard(context),
                  const SizedBox(height: 24),
                  const Text(
                    'Products Summary',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2D3142),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Column(
                    children: [
                      _buildProductCard(
                        context,
                        'Share Capital',
                        'KES 50,000',
                        FontAwesomeIcons.chartPie,
                        const Color(0xFF6C5DD3),
                        [
                          {'name': 'Core Shares', 'amount': 'KES 30,000'},
                          {'name': 'Additional Shares', 'amount': 'KES 20,000'},
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildProductCard(
                        context,
                        'Savings',
                        'KES 85,000',
                        FontAwesomeIcons.piggyBank,
                        const Color(0xFF7FBA7A),
                        [
                          {'name': 'Holiday Savings', 'amount': 'KES 35,000'},
                          {'name': 'Emergency Fund', 'amount': 'KES 30,000'},
                          {'name': 'Education Fund', 'amount': 'KES 20,000'},
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildProductCard(
                        context,
                        'Loans',
                        'KES 120,000',
                        FontAwesomeIcons.handHoldingDollar,
                        const Color(0xFFFF8A65),
                        [
                          {'name': 'Phone Loan', 'amount': 'KES 20,000'},
                          {'name': 'Digital Loan', 'amount': 'KES 40,000'},
                          {'name': 'Motorbike Loan', 'amount': 'KES 60,000'},
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _getAccountTransactions(String accountName) {
    // Simulated transactions for different accounts
    switch (accountName) {
      case 'Core Shares':
        return [
          {
            'title': 'Monthly Share Contribution',
            'amount': '+KES 5,000',
            'date': '2024-03-15',
            'icon': FontAwesomeIcons.circlePlus,
            'color': Colors.green,
          },
          {
            'title': 'Share Capital Top-up',
            'amount': '+KES 10,000',
            'date': '2024-03-01',
            'icon': FontAwesomeIcons.circlePlus,
            'color': Colors.green,
          },
        ];
      case 'Additional Shares':
        return [
          {
            'title': 'Extra Shares Purchase',
            'amount': '+KES 7,000',
            'date': '2024-03-10',
            'icon': FontAwesomeIcons.circlePlus,
            'color': Colors.green,
          },
        ];
      case 'Holiday Savings':
        return [
          {
            'title': 'Monthly Savings',
            'amount': '+KES 3,000',
            'date': '2024-03-15',
            'icon': FontAwesomeIcons.circlePlus,
            'color': Colors.green,
          },
          {
            'title': 'Holiday Withdrawal',
            'amount': '-KES 10,000',
            'date': '2024-02-20',
            'icon': FontAwesomeIcons.circleMinus,
            'color': Colors.red,
          },
        ];
      case 'Emergency Fund':
        return [
          {
            'title': 'Emergency Deposit',
            'amount': '+KES 5,000',
            'date': '2024-03-12',
            'icon': FontAwesomeIcons.circlePlus,
            'color': Colors.green,
          },
        ];
      case 'Education Fund':
        return [
          {
            'title': 'School Fees Savings',
            'amount': '+KES 8,000',
            'date': '2024-03-15',
            'icon': FontAwesomeIcons.circlePlus,
            'color': Colors.green,
          },
          {
            'title': 'Term Payment',
            'amount': '-KES 15,000',
            'date': '2024-01-05',
            'icon': FontAwesomeIcons.circleMinus,
            'color': Colors.red,
          },
        ];
      case 'Phone Loan':
        return [
          {
            'title': 'Loan Disbursement',
            'amount': '+KES 20,000',
            'date': '2024-02-01',
            'icon': FontAwesomeIcons.circlePlus,
            'color': Colors.green,
          },
          {
            'title': 'Monthly Payment',
            'amount': '-KES 2,000',
            'date': '2024-03-15',
            'icon': FontAwesomeIcons.circleMinus,
            'color': Colors.red,
          },
        ];
      case 'Digital Loan':
        return [
          {
            'title': 'Loan Disbursement',
            'amount': '+KES 40,000',
            'date': '2024-01-15',
            'icon': FontAwesomeIcons.circlePlus,
            'color': Colors.green,
          },
          {
            'title': 'Monthly Payment',
            'amount': '-KES 4,500',
            'date': '2024-03-15',
            'icon': FontAwesomeIcons.circleMinus,
            'color': Colors.red,
          },
        ];
      case 'Motorbike Loan':
        return [
          {
            'title': 'Loan Disbursement',
            'amount': '+KES 60,000',
            'date': '2024-01-01',
            'icon': FontAwesomeIcons.circlePlus,
            'color': Colors.green,
          },
          {
            'title': 'Monthly Payment',
            'amount': '-KES 6,000',
            'date': '2024-03-15',
            'icon': FontAwesomeIcons.circleMinus,
            'color': Colors.red,
          },
          {
            'title': 'Monthly Payment',
            'amount': '-KES 6,000',
            'date': '2024-02-15',
            'icon': FontAwesomeIcons.circleMinus,
            'color': Colors.red,
          },
        ];
      default:
        return [];
    }
  }

  Widget _buildQuickAction(
    BuildContext context,
    IconData icon,
    String label,
    Color color,
  ) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(
            icon,
            color: color,
            size: 24,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildTransactionItem(String title, String amount, String date, IconData icon, Color color) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    date,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              amount,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: amount.startsWith('+') ? Colors.green : Colors.red,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductCard(BuildContext context, String title, String amount, IconData icon, Color color, List<Map<String, String>> accounts) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          backgroundColor: Colors.transparent,
          isScrollControlled: true,
          builder: (context) => _buildAccountsList(context, title, accounts, color),
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: color.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: color,
                    size: 24,
                  ),
                ),
                Text(
                  '${accounts.length} accounts',
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D3142),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              amount,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountsList(BuildContext context, String title, List<Map<String, String>> accounts, Color color) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 16),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              Expanded(
                child: Text(
                  '$title Accounts',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(width: 48), // Balance the back button
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: accounts.map((account) => Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  title: Text(account['name']!),
                  trailing: Text(
                    account['amount']!,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _showAccountTransactions(context, account, title, accounts, color);
                  },
                ),
              )).toList(),
            ),
          ),
        ],
      ),
    );
  }

  void _showAccountTransactions(BuildContext context, Map<String, String> selectedAccount, String productTitle, List<Map<String, String>> allAccounts, Color color) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 16),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context);
                    showModalBottomSheet(
                      context: context,
                      backgroundColor: Colors.transparent,
                      isScrollControlled: true,
                      builder: (context) => _buildAccountsList(context, productTitle, allAccounts, color),
                    );
                  },
                ),
                Expanded(
                  child: Text(
                    '${selectedAccount['name']} Transactions',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(width: 48), // Balance the back button
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Balance: ${selectedAccount['amount']}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: color,
                ),
              ),
            ),
            const Divider(),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: _getAccountTransactions(selectedAccount['name']!)
                    .map((transaction) => _buildTransactionItem(
                          transaction['title'],
                          transaction['amount'],
                          transaction['date'],
                          transaction['icon'],
                          transaction['color'],
                        ))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTotalBalanceCard(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF6C5DD3), Color(0xFF8B80F8)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Total Balance',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'KES 135,000',
            style: TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.pushNamed(context, '/invest', arguments: {'initialTab': 0}),
                  icon: const Icon(FontAwesomeIcons.piggyBank, size: 16),
                  label: const Text('Save'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF6C5DD3),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.pushNamed(context, '/invest', arguments: {'initialTab': 1}),
                  icon: const Icon(FontAwesomeIcons.handHoldingDollar, size: 16),
                  label: const Text('Borrow'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white24,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
