import 'package:flutter/material.dart';

class InvestScreen extends StatelessWidget {
  const InvestScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Invest'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const Text(
            'Investment Opportunities',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          _buildInvestmentOption(
            context,
            'Fixed Deposit',
            'Earn up to 12% per annum',
            'Minimum investment: \$1,000',
            Icons.account_balance,
            Colors.blue,
          ),
          _buildInvestmentOption(
            context,
            'Group Savings',
            'Join a savings group',
            'Minimum contribution: \$100/month',
            Icons.group,
            Colors.green,
          ),
          _buildInvestmentOption(
            context,
            'Business Loan',
            'Get funding for your business',
            'Flexible repayment terms',
            Icons.business,
            Colors.orange,
          ),
          _buildInvestmentOption(
            context,
            'Emergency Fund',
            'Save for unexpected expenses',
            'No minimum deposit',
            Icons.emergency,
            Colors.red,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // TODO: Implement investment creation
        },
        label: const Text('New Investment'),
        icon: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildInvestmentOption(
    BuildContext context,
    String title,
    String description,
    String details,
    IconData icon,
    Color color,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () {
          // TODO: Navigate to investment details
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
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
                  size: 32,
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
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: const TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      details,
                      style: TextStyle(
                        color: color,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey[400],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
