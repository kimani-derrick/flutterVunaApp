import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import '../services/group_service.dart';

class GroupTransactionsScreen extends StatefulWidget {
  final String accountId;
  final String groupName;
  final String accountNo;

  const GroupTransactionsScreen({
    Key? key,
    required this.accountId,
    required this.groupName,
    required this.accountNo,
  }) : super(key: key);

  @override
  _GroupTransactionsScreenState createState() =>
      _GroupTransactionsScreenState();
}

class _GroupTransactionsScreenState extends State<GroupTransactionsScreen> {
  late Future<List<Map<String, dynamic>>> _transactionsFuture;

  @override
  void initState() {
    super.initState();
    _transactionsFuture = _fetchTransactions();
  }

  Future<List<Map<String, dynamic>>> _fetchTransactions() async {
    return GroupService.getGroupTransactions(widget.accountId);
  }

  String _getTransactionTypeIcon(String type) {
    switch (type.toLowerCase()) {
      case 'deposit':
      case 'interest_posting':
        return '↓';
      case 'withdrawal':
        return '↑';
      default:
        return '•';
    }
  }

  Color _getTransactionColor(String type) {
    switch (type.toLowerCase()) {
      case 'deposit':
      case 'interest_posting':
        return Colors.green;
      case 'withdrawal':
        return Colors.red;
      default:
        return Colors.grey;
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
              widget.groupName,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Account: ${widget.accountNo}',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.white70,
              ),
            ),
          ],
        ),
        elevation: 0,
        backgroundColor: const Color(0xFF4C3FF7),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () {
              // TODO: Implement date filter
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _transactionsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
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

          return RefreshIndicator(
            onRefresh: () async {
              setState(() {
                _transactionsFuture = _fetchTransactions();
              });
            },
            child: ListView.builder(
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                final transaction = transactions[index];
                final type =
                    transaction['transactionType']?['value'] ?? 'Unknown';
                final amount = transaction['amount'] ?? 0.0;
                final date = transaction['date'] != null
                    ? DateTime(
                        transaction['date'][0],
                        transaction['date'][1],
                        transaction['date'][2],
                      )
                    : null;
                final submittedDate = transaction['submittedOnDate'] != null
                    ? DateTime(
                        transaction['submittedOnDate'][0],
                        transaction['submittedOnDate'][1],
                        transaction['submittedOnDate'][2],
                      )
                    : null;
                final runningBalance = transaction['runningBalance'] ?? 0.0;
                final currency =
                    transaction['currency']?['displaySymbol'] ?? 'KES';
                final isCredit = transaction['entryType'] == 'CREDIT';

                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: ListTile(
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: _getTransactionColor(type).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Text(
                          isCredit ? '↓' : '↑',
                          style: TextStyle(
                            fontSize: 24,
                            color: _getTransactionColor(type),
                          ),
                        ),
                      ),
                    ),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          type,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '$currency ${NumberFormat('#,##0.00').format(amount)}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isCredit ? Colors.green : Colors.red,
                          ),
                        ),
                      ],
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (date != null) ...[
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                FontAwesomeIcons.calendar,
                                size: 12,
                                color: Colors.grey[600],
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Transaction: ${DateFormat('MMM d, y').format(date)}',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ],
                        if (submittedDate != null && submittedDate != date) ...[
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                FontAwesomeIcons.clock,
                                size: 12,
                                color: Colors.grey[600],
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Submitted: ${DateFormat('MMM d, y').format(submittedDate)}',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ],
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              'Balance: $currency ${NumberFormat('#,##0.00').format(runningBalance)}',
                              style: TextStyle(
                                color: Colors.grey[800],
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
            ),
          );
        },
      ),
    );
  }
}
