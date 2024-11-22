import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Decorative Menu Bar at the top
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 100, // Reduced from 120 to 100
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFF6C5DD3),
                    const Color(0xFF8B80F8),
                  ],
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: SafeArea(
                bottom: false, // Don't consider bottom safe area
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 10), // Adjusted padding
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min, // Important to prevent vertical expansion
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Welcome back',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white70,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'John Doe',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min, // Important to prevent horizontal expansion
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: IconButton(
                              constraints: const BoxConstraints( // Constrain the icon button size
                                minWidth: 40,
                                minHeight: 40,
                              ),
                              icon: const Icon(
                                FontAwesomeIcons.bell,
                                color: Colors.white,
                                size: 20,
                              ),
                              onPressed: () {},
                            ),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Container(
                              padding: const EdgeInsets.all(2),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  'https://ui-avatars.com/api/?name=John+Doe&background=6C5DD3&color=fff&size=36',
                                  width: 36,
                                  height: 36,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Main Content
          Padding(
            padding: const EdgeInsets.only(top: 110), // Adjusted from 130 to 110
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                    _buildProductCard(
                      context,
                      'Share Capital',
                      'KES 50,000',
                      FontAwesomeIcons.chartPie,
                      const Color(0xFF6C5DD3),
                    ),
                    const SizedBox(height: 16),
                    _buildProductCard(
                      context,
                      'Savings',
                      'KES 85,000',
                      FontAwesomeIcons.piggyBank,
                      const Color(0xFF7FBA7A),
                    ),
                    const SizedBox(height: 16),
                    _buildProductCard(
                      context,
                      'Loans',
                      'KES 120,000',
                      FontAwesomeIcons.handHoldingDollar,
                      const Color(0xFFFF8A65),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Map<String, List<Map<String, dynamic>>> _getProductAccounts() {
    return {
      'Share Capital': [
        {
          'name': 'Core Shares',
          'amount': 'KES 30,000',
          'description': 'Mandatory shares as per SACCO rules',
          'color': const Color(0xFF6C5DD3),
        },
        {
          'name': 'Additional Shares',
          'amount': 'KES 20,000',
          'description': 'Optional additional investment shares',
          'color': const Color(0xFF6C5DD3),
        },
      ],
      'Savings': [
        {
          'name': 'Holiday Savings',
          'amount': 'KES 35,000',
          'description': 'Save for your next vacation',
          'color': const Color(0xFF7FBA7A),
        },
        {
          'name': 'Emergency Fund',
          'amount': 'KES 30,000',
          'description': 'For unexpected expenses',
          'color': const Color(0xFF7FBA7A),
        },
        {
          'name': 'Education Fund',
          'amount': 'KES 20,000',
          'description': 'Save for future education needs',
          'color': const Color(0xFF7FBA7A),
        },
      ],
      'Loans': [
        {
          'name': 'Phone Loan',
          'amount': 'KES 20,000',
          'description': 'Mobile device financing',
          'color': const Color(0xFFFF8A65),
        },
        {
          'name': 'Digital Loan',
          'amount': 'KES 40,000',
          'description': 'Quick access digital loan',
          'color': const Color(0xFFFF8A65),
        },
        {
          'name': 'Motorbike Loan',
          'amount': 'KES 60,000',
          'description': 'Vehicle financing loan',
          'color': const Color(0xFFFF8A65),
        },
      ],
    };
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
            'description': 'Regular monthly share contribution',
          },
          {
            'title': 'Share Capital Top-up',
            'amount': '+KES 10,000',
            'date': '2024-03-01',
            'icon': FontAwesomeIcons.circlePlus,
            'color': Colors.green,
            'description': 'Additional share capital investment',
          },
          {
            'title': 'Dividend Reinvestment',
            'amount': '+KES 8,500',
            'date': '2024-02-15',
            'icon': FontAwesomeIcons.circlePlus,
            'color': Colors.green,
            'description': 'Annual dividend converted to shares',
          },
        ];

      case 'Additional Shares':
        return [
          {
            'title': 'Extra Shares Purchase',
            'amount': '+KES 15,000',
            'date': '2024-03-10',
            'icon': FontAwesomeIcons.circlePlus,
            'color': Colors.green,
            'description': 'Investment in additional shares',
          },
          {
            'title': 'Bonus Shares Allocation',
            'amount': '+KES 5,000',
            'date': '2024-02-28',
            'icon': FontAwesomeIcons.gift,
            'color': Colors.green,
            'description': 'Bonus shares from SACCO promotion',
          },
        ];

      case 'Holiday Savings':
        return [
          {
            'title': 'Monthly Savings Deposit',
            'amount': '+KES 5,000',
            'date': '2024-03-15',
            'icon': FontAwesomeIcons.circlePlus,
            'color': Colors.green,
            'description': 'Regular holiday savings contribution',
          },
          {
            'title': 'Travel Booking Withdrawal',
            'amount': '-KES 15,000',
            'date': '2024-02-20',
            'icon': FontAwesomeIcons.circleMinus,
            'color': Colors.red,
            'description': 'Flight ticket payment from savings',
          },
          {
            'title': 'Bonus Interest Credit',
            'amount': '+KES 1,200',
            'date': '2024-02-01',
            'icon': FontAwesomeIcons.percent,
            'color': Colors.green,
            'description': 'Quarterly interest earnings',
          },
        ];

      case 'Emergency Fund':
        return [
          {
            'title': 'Emergency Deposit',
            'amount': '+KES 10,000',
            'date': '2024-03-12',
            'icon': FontAwesomeIcons.circlePlus,
            'color': Colors.green,
            'description': 'Monthly emergency fund contribution',
          },
          {
            'title': 'Medical Emergency',
            'amount': '-KES 8,000',
            'date': '2024-02-25',
            'icon': FontAwesomeIcons.circleMinus,
            'color': Colors.red,
            'description': 'Hospital bill payment',
          },
          {
            'title': 'Interest Earned',
            'amount': '+KES 750',
            'date': '2024-02-01',
            'icon': FontAwesomeIcons.percent,
            'color': Colors.green,
            'description': 'Monthly interest on emergency fund',
          },
        ];

      case 'Education Fund':
        return [
          {
            'title': 'School Fees Savings',
            'amount': '+KES 12,000',
            'date': '2024-03-15',
            'icon': FontAwesomeIcons.circlePlus,
            'color': Colors.green,
            'description': 'Monthly education savings',
          },
          {
            'title': 'Term Fee Payment',
            'amount': '-KES 35,000',
            'date': '2024-01-05',
            'icon': FontAwesomeIcons.circleMinus,
            'color': Colors.red,
            'description': 'School fees payment for Term 1',
          },
          {
            'title': 'Education Bonus',
            'amount': '+KES 2,500',
            'date': '2024-01-01',
            'icon': FontAwesomeIcons.gift,
            'color': Colors.green,
            'description': 'Back to school bonus credit',
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
            'description': 'Phone financing loan approval',
          },
          {
            'title': 'Monthly Repayment',
            'amount': '-KES 2,500',
            'date': '2024-03-15',
            'icon': FontAwesomeIcons.circleMinus,
            'color': Colors.red,
            'description': 'Regular loan repayment',
          },
          {
            'title': 'Early Repayment Bonus',
            'amount': '-KES 5,000',
            'date': '2024-03-10',
            'icon': FontAwesomeIcons.percent,
            'color': Colors.red,
            'description': 'Additional payment with 5% discount',
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
            'description': 'Quick digital loan approval',
          },
          {
            'title': 'Monthly Repayment',
            'amount': '-KES 4,500',
            'date': '2024-03-15',
            'icon': FontAwesomeIcons.circleMinus,
            'color': Colors.red,
            'description': 'Regular loan repayment',
          },
          {
            'title': 'Late Payment Fee',
            'amount': '-KES 500',
            'date': '2024-02-16',
            'icon': FontAwesomeIcons.circleExclamation,
            'color': Colors.red,
            'description': 'Late payment penalty',
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
            'description': 'Motorbike financing approval',
          },
          {
            'title': 'Monthly Repayment',
            'amount': '-KES 6,000',
            'date': '2024-03-15',
            'icon': FontAwesomeIcons.circleMinus,
            'color': Colors.red,
            'description': 'Regular loan repayment',
          },
          {
            'title': 'Insurance Premium',
            'amount': '-KES 2,500',
            'date': '2024-03-01',
            'icon': FontAwesomeIcons.shield,
            'color': Colors.red,
            'description': 'Monthly bike insurance payment',
          },
          {
            'title': 'Monthly Repayment',
            'amount': '-KES 6,000',
            'date': '2024-02-15',
            'icon': FontAwesomeIcons.circleMinus,
            'color': Colors.red,
            'description': 'Regular loan repayment',
          },
        ];

      default:
        return [];
    }
  }

  void _showProductDetails(BuildContext context, String productName) {
    final accounts = _getProductAccounts()[productName] ?? [];
    final color = productName == 'Share Capital' 
        ? const Color(0xFF6C5DD3)
        : productName == 'Savings' 
            ? const Color(0xFF7FBA7A)
            : const Color(0xFFFF8A65);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.75,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    color,
                    color.withOpacity(0.8),
                  ],
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(
                              FontAwesomeIcons.arrowLeft,
                              color: Colors.white,
                              size: 20,
                            ),
                            onPressed: () => Navigator.pop(context),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            productName,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Total Balance',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    accounts.fold<double>(
                      0,
                      (prev, account) {
                        final amount = double.parse(account['amount'].substring(4).replaceAll(',', ''));
                        return prev + amount;
                      },
                    ).toString().startsWith('-')
                        ? '-KES ${accounts.fold<double>(
                            0,
                            (prev, account) {
                              final amount = double.parse(account['amount'].substring(4).replaceAll(',', ''));
                              return prev + amount;
                            },
                          ).abs().toStringAsFixed(0)}'
                        : 'KES ${accounts.fold<double>(
                            0,
                            (prev, account) {
                              final amount = double.parse(account['amount'].substring(4).replaceAll(',', ''));
                              return prev + amount;
                            },
                          ).toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(20),
                itemCount: accounts.length,
                itemBuilder: (context, index) {
                  final account = accounts[index];
                  return GestureDetector(
                    onTap: () => _showAccountTransactions(context, account['name'], color),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: color.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              productName == 'Share Capital' 
                                  ? FontAwesomeIcons.chartPie
                                  : productName == 'Savings'
                                      ? FontAwesomeIcons.piggyBank
                                      : FontAwesomeIcons.handHoldingDollar,
                              color: color,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  account['name'],
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF2D3142),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  account['description'],
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  account['amount'],
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: color,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            FontAwesomeIcons.angleRight,
                            color: color,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAccountTransactions(BuildContext context, String accountName, Color color) {
    final transactions = _getAccountTransactions(accountName);
    
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.75,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    color,
                    color.withOpacity(0.8),
                  ],
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(
                              FontAwesomeIcons.arrowLeft,
                              color: Colors.white,
                              size: 20,
                            ),
                            onPressed: () => Navigator.pop(context),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            accountName,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Recent Transactions',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(20),
                itemCount: transactions.length,
                itemBuilder: (context, index) {
                  final transaction = transactions[index];
                  return _buildTransactionItem(transaction);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionItem(Map<String, dynamic> transaction) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: transaction['color'].withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  transaction['icon'],
                  color: transaction['color'],
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      transaction['title'],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2D3142),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      transaction['date'],
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                transaction['amount'],
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: transaction['amount'].startsWith('+') 
                      ? Colors.green 
                      : Colors.red,
                ),
              ),
            ],
          ),
          if (transaction['description'] != null) ...[
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.only(left: 60),
              child: Text(
                transaction['description'],
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildProductCard(
    BuildContext context,
    String title,
    String amount,
    IconData icon,
    Color color,
  ) {
    return GestureDetector(
      onTap: () {
        _showProductDetails(context, title);
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
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
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2D3142),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    amount,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2D3142),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              FontAwesomeIcons.angleRight,
              color: color,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTotalBalanceCard(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      elevation: 8,
      shadowColor: const Color(0xFF6C5DD3).withOpacity(0.2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF6C5DD3), Color(0xFF8B80F8)],
          ),
          borderRadius: BorderRadius.circular(20),
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
      ),
    );
  }
}
