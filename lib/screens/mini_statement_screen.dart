import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/investment_service.dart';

class MiniStatementScreen extends StatefulWidget {
  final String accountId;
  final String accountName;

  const MiniStatementScreen({
    Key? key,
    required this.accountId,
    required this.accountName,
  }) : super(key: key);

  @override
  State<MiniStatementScreen> createState() => _MiniStatementScreenState();
}

class _MiniStatementScreenState extends State<MiniStatementScreen> {
  late Future<List<dynamic>> _transactionsFuture;
  final _dateFormat = DateFormat('dd MMM yyyy');
  final _currencyFormat = NumberFormat('#,##0.00');

  @override
  void initState() {
    super.initState();
    _transactionsFuture = _fetchTransactions();
  }

  Future<List<dynamic>> _fetchTransactions() async {
    try {
      final transactions = await InvestmentService.getAccountTransactions(
        widget.accountId,
      );
      return transactions;
    } catch (e) {
      throw Exception('Failed to load transactions: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Mini Statement',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
                fontSize: 20,
              ),
            ),
            Text(
              widget.accountName,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.8),
                fontSize: 14,
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF4C3FF7),
        elevation: 0,
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _transactionsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4C3FF7)),
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
                    'Error loading transactions',
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

          final transactions = snapshot.data ?? [];
          if (transactions.isEmpty) {
            return const Center(
              child: Text(
                'No transactions found',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                ),
              ),
            );
          }

          // Take only the last 5 transactions
          final recentTransactions = transactions.take(5).toList();

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: recentTransactions.length,
            itemBuilder: (context, index) {
              final transaction = recentTransactions[index];
              final amount = transaction['amount'] as num;
              final date = DateTime(
                transaction['date'][0] as int,
                transaction['date'][1] as int,
                transaction['date'][2] as int,
              );
              final type = transaction['transactionType']['value'] as String;
              final isCredit = !transaction['transactionType']['withdrawal'] &&
                  !transaction['transactionType']['feeDeduction'];
              final description = type;

              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _dateFormat.format(date),
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                          Text(
                            'KES ${_currencyFormat.format(amount)}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: isCredit
                                  ? Colors.green[700]
                                  : Colors.red[700],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        description,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  isCredit ? Colors.green[50] : Colors.red[50],
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              isCredit ? 'Credit' : 'Debit',
                              style: TextStyle(
                                fontSize: 12,
                                color: isCredit
                                    ? Colors.green[700]
                                    : Colors.red[700],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Text(
                            'Balance: KES ${_currencyFormat.format(transaction['runningBalance'] as num)}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
