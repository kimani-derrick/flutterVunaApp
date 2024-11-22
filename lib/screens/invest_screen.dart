import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class InvestScreen extends StatefulWidget {
  const InvestScreen({Key? key}) : super(key: key);

  @override
  State<InvestScreen> createState() => _InvestScreenState();
}

class _InvestScreenState extends State<InvestScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    
    // Handle initial tab selection from arguments
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      if (args != null && args.containsKey('initialTab')) {
        _tabController.animateTo(args['initialTab'] as int);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Investment Products'),
        backgroundColor: const Color(0xFF6C5DD3),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Savings Products'),
            Tab(text: 'Loan Products'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildSavingsProducts(),
          _buildLoanProducts(),
        ],
      ),
    );
  }

  Widget _buildSavingsProducts() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildProductCard(
          'Core Shares',
          'Build your ownership in the SACCO',
          'Current value: KES 30,000',
          FontAwesomeIcons.chartPie,
          const Color(0xFF6C5DD3),
          () => _showProductDetails(context, 'Core Shares'),
        ),
        const SizedBox(height: 16),
        _buildProductCard(
          'Additional Shares',
          'Increase your investment portfolio',
          'Current value: KES 20,000',
          FontAwesomeIcons.plus,
          const Color(0xFF6C5DD3),
          () => _showProductDetails(context, 'Additional Shares'),
        ),
        const SizedBox(height: 16),
        _buildProductCard(
          'Holiday Savings',
          'Save for your dream vacation',
          'Current value: KES 35,000',
          FontAwesomeIcons.umbrellaBeach,
          const Color(0xFF7FBA7A),
          () => _showProductDetails(context, 'Holiday Savings'),
        ),
        const SizedBox(height: 16),
        _buildProductCard(
          'Emergency Fund',
          'Be prepared for the unexpected',
          'Current value: KES 30,000',
          FontAwesomeIcons.shield,
          const Color(0xFF7FBA7A),
          () => _showProductDetails(context, 'Emergency Fund'),
        ),
        const SizedBox(height: 16),
        _buildProductCard(
          'Education Fund',
          'Secure your future learning',
          'Current value: KES 20,000',
          FontAwesomeIcons.graduationCap,
          const Color(0xFF7FBA7A),
          () => _showProductDetails(context, 'Education Fund'),
        ),
      ],
    );
  }

  Widget _buildLoanProducts() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildProductCard(
          'Phone Loan',
          'Get a new smartphone',
          'Current balance: KES 20,000',
          FontAwesomeIcons.mobileScreen,
          const Color(0xFFFF8A65),
          () => _showProductDetails(context, 'Phone Loan'),
        ),
        const SizedBox(height: 16),
        _buildProductCard(
          'Digital Loan',
          'Quick access to funds',
          'Current balance: KES 40,000',
          FontAwesomeIcons.bolt,
          const Color(0xFFFF8A65),
          () => _showProductDetails(context, 'Digital Loan'),
        ),
        const SizedBox(height: 16),
        _buildProductCard(
          'Motorbike Loan',
          'Finance your mobility',
          'Current balance: KES 60,000',
          FontAwesomeIcons.motorcycle,
          const Color(0xFFFF8A65),
          () => _showProductDetails(context, 'Motorbike Loan'),
        ),
      ],
    );
  }

  Widget _buildProductCard(
    String title,
    String subtitle,
    String feature,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, color: color),
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
                          subtitle,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  feature,
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showProductDetails(BuildContext context, String productName) {
    // Get product-specific details
    Map<String, String> details = _getProductDetails(productName);
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 16),
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.symmetric(horizontal: 180),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                productName,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(24),
                children: [
                  _buildFeatureItem('Current Balance', details['balance'] ?? ''),
                  _buildFeatureItem('Minimum Amount', details['minimum'] ?? ''),
                  _buildFeatureItem('Maximum Amount', details['maximum'] ?? ''),
                  _buildFeatureItem('Interest Rate', details['rate'] ?? ''),
                  _buildFeatureItem('Term', details['term'] ?? ''),
                  _buildFeatureItem('Processing Time', details['processing'] ?? ''),
                  const SizedBox(height: 24),
                  const Text(
                    'Requirements',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...details['requirements']?.split('|').map((req) => _buildRequirementItem(req)) ?? [],
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _showApplicationForm(context, productName);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6C5DD3),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      details['buttonText'] ?? 'Apply Now',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
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
  }

  Map<String, String> _getProductDetails(String productName) {
    switch (productName) {
      case 'Core Shares':
        return {
          'balance': 'KES 30,000',
          'minimum': 'KES 5,000',
          'maximum': 'No limit',
          'rate': 'Annual dividend rate',
          'term': 'Long-term investment',
          'processing': 'Immediate',
          'requirements': 'Valid ID/Passport|KRA PIN Certificate|Recent passport photo',
          'buttonText': 'Buy More Shares',
        };
      case 'Additional Shares':
        return {
          'balance': 'KES 20,000',
          'minimum': 'KES 1,000',
          'maximum': 'No limit',
          'rate': 'Annual dividend rate',
          'term': 'Long-term investment',
          'processing': 'Immediate',
          'requirements': 'Must have Core Shares|KRA PIN Certificate',
          'buttonText': 'Buy More Shares',
        };
      case 'Holiday Savings':
        return {
          'balance': 'KES 35,000',
          'minimum': 'KES 1,000 monthly',
          'maximum': 'No limit',
          'rate': '8% p.a.',
          'term': 'Minimum 6 months',
          'processing': '24 hours for withdrawals',
          'requirements': 'Valid ID/Passport|Active account for 3 months',
          'buttonText': 'Start Saving',
        };
      case 'Emergency Fund':
        return {
          'balance': 'KES 30,000',
          'minimum': 'KES 500',
          'maximum': 'No limit',
          'rate': '6% p.a.',
          'term': 'Flexible withdrawals',
          'processing': 'Immediate access',
          'requirements': 'Valid ID/Passport|Active account',
          'buttonText': 'Save Now',
        };
      case 'Education Fund':
        return {
          'balance': 'KES 20,000',
          'minimum': 'KES 2,000 monthly',
          'maximum': 'No limit',
          'rate': '10% p.a.',
          'term': 'Minimum 1 year',
          'processing': '48 hours for withdrawals',
          'requirements': 'Valid ID/Passport|Proof of enrollment|KRA PIN Certificate',
          'buttonText': 'Start Saving',
        };
      case 'Phone Loan':
        return {
          'balance': 'KES 20,000',
          'minimum': 'KES 5,000',
          'maximum': 'KES 50,000',
          'rate': '12% p.a.',
          'term': '3 - 12 months',
          'processing': '24 hours',
          'requirements': 'Valid ID/Passport|3 months membership|Proof of income',
          'buttonText': 'Apply for Loan',
        };
      case 'Digital Loan':
        return {
          'balance': 'KES 40,000',
          'minimum': 'KES 1,000',
          'maximum': 'KES 100,000',
          'rate': '14% p.a.',
          'term': '1 - 6 months',
          'processing': 'Instant',
          'requirements': 'Valid ID/Passport|Active account|Credit score check',
          'buttonText': 'Get Instant Loan',
        };
      case 'Motorbike Loan':
        return {
          'balance': 'KES 60,000',
          'minimum': 'KES 50,000',
          'maximum': 'KES 300,000',
          'rate': '15% p.a.',
          'term': '6 - 36 months',
          'processing': '48 hours',
          'requirements': 'Valid ID/Passport|6 months membership|Proof of income|KRA PIN Certificate|Insurance quote',
          'buttonText': 'Apply for Loan',
        };
      default:
        return {};
    }
  }

  Widget _buildFeatureItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 16,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRequirementItem(String requirement) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          const Icon(
            Icons.check_circle,
            color: Color(0xFF6C5DD3),
            size: 20,
          ),
          const SizedBox(width: 12),
          Text(
            requirement,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  void _showApplicationForm(BuildContext context, String productName) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.9,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 16),
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.symmetric(horizontal: 180),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                'Apply for $productName',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(24),
                children: [
                  _buildTextField('Amount (KES)', TextInputType.number),
                  _buildTextField('Purpose', TextInputType.text),
                  _buildTextField('Term (months)', TextInputType.number),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _showSuccessDialog(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6C5DD3),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Submit Application',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
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
  }

  Widget _buildTextField(String label, TextInputType keyboardType) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.check_circle,
              color: Color(0xFF6C5DD3),
              size: 64,
            ),
            const SizedBox(height: 16),
            const Text(
              'Application Submitted!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'We will review your application and get back to you within 24 hours.',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6C5DD3),
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Done',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
