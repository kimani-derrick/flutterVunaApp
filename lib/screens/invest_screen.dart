import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../services/investment_service.dart';
import '../models/user_model.dart';
import '../widgets/top_menu_bar.dart';

class InvestScreen extends StatefulWidget {
  final String? username;
  final String? password;
  final UserModel? user;

  const InvestScreen({
    Key? key,
    this.username,
    this.password,
    this.user,
  }) : super(key: key);

  @override
  State<InvestScreen> createState() => _InvestScreenState();
}

class _InvestScreenState extends State<InvestScreen> {
  List<Map<String, dynamic>>? _savingsProducts;
  bool _isLoading = false;
  String? _error;
  final _formKey = GlobalKey<FormState>();
  final _investmentAmountController = TextEditingController();
  final _investmentPeriodController = TextEditingController();
  final _purposeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchSavingsProducts();
  }

  @override
  void dispose() {
    _investmentAmountController.dispose();
    _investmentPeriodController.dispose();
    _purposeController.dispose();
    super.dispose();
  }

  Future<void> _fetchSavingsProducts() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final products = await InvestmentService.getSavingsProducts();
      print('\n🌟 ========== FETCHED PRODUCTS ==========');
      print('Total products fetched: ${products.length}');

      for (var product in products) {
        print('''
📦 Product Details:
  - Name: ${product['name']}
  - Description: ${product['description'] ?? 'No description'}
  - Interest Rate: ${product['nominalAnnualInterestRate']}%
  - Currency: ${product['currency']['displayLabel']}
  - Account Rule: ${product['accountingRule']['value']}
''');
      }
      print('======================================\n');

      if (!mounted) return;
      setState(() {
        _savingsProducts = products;
        _isLoading = false;
      });
    } catch (e) {
      print('❌ ERROR: Failed to fetch products: $e');
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  void _showProductDetails(BuildContext context, String category,
      List<Map<String, dynamic>> products) {
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
                  Text(
                    category,
                    style: const TextStyle(
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
                child: ListView.builder(
                  controller: controller,
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Color(0xFF4C3FF7), Color(0xFF7C3FFF)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(12),
                                topRight: Radius.circular(12),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product['name'] ?? 'Unknown Product',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Interest Rate: ${product['nominalAnnualInterestRate']}%',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (product['description'] != null)
                                  Text(
                                    product['description'],
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                const SizedBox(height: 12),
                                Text(
                                  'Currency: ${product['currency']['displayLabel']}',
                                  style: const TextStyle(fontSize: 14),
                                ),
                                const SizedBox(height: 8),
                                if (product['interestCompoundingPeriodType'] !=
                                    null)
                                  Text(
                                    'Interest Compounding: ${product['interestCompoundingPeriodType']['value']}',
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                if (product['interestPostingPeriodType'] !=
                                    null)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: Text(
                                      'Interest Posting: ${product['interestPostingPeriodType']['value']}',
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ),
                                const SizedBox(height: 16),
                                ElevatedButton(
                                  onPressed: () =>
                                      _showInvestmentForm(context, product),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF4C3FF7),
                                    minimumSize:
                                        const Size(double.infinity, 48),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: const Text(
                                    'Invest Now',
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

  void _showInvestmentForm(BuildContext context, Map<String, dynamic> product) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: DraggableScrollableSheet(
          initialChildSize: 0.9,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          builder: (_, controller) => Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Investment Application',
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
                  Text(
                    'Product: ${product['name']}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: _investmentAmountController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Investment Amount',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.money),
                      prefixText: 'KES ',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an investment amount';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Please enter a valid number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _investmentPeriodController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Investment Period (months)',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.calendar_today),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an investment period';
                      }
                      if (int.tryParse(value) == null) {
                        return 'Please enter a valid number of months';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _purposeController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: 'Purpose of Investment',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.description),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the purpose of your investment';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // Show confirmation dialog
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Confirm Investment'),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Product: ${product['name']}'),
                                Text(
                                    'Amount: KES ${_investmentAmountController.text}'),
                                Text(
                                    'Period: ${_investmentPeriodController.text} months'),
                                Text('Purpose: ${_purposeController.text}'),
                              ],
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Cancel'),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  // TODO: Implement investment submission
                                  Navigator.pop(context); // Close dialog
                                  Navigator.pop(context); // Close form
                                  Navigator.pop(
                                      context); // Close product details

                                  // Show success message
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          'Investment application submitted successfully!'),
                                      backgroundColor: Colors.green,
                                    ),
                                  );

                                  // Clear form
                                  _investmentAmountController.clear();
                                  _investmentPeriodController.clear();
                                  _purposeController.clear();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF4C3FF7),
                                ),
                                child: const Text('Confirm'),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4C3FF7),
                      minimumSize: const Size(double.infinity, 48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
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
          ),
        ),
      ),
    );
  }

  bool containsWholeWord(String text, String query) {
    // Create a regular expression to match the query as a whole word
    final pattern =
        RegExp(r'\b' + RegExp.escape(query) + r'\b', caseSensitive: false);
    return pattern.hasMatch(text);
  }

  List<Map<String, dynamic>> _getProductsByCategory(String category) {
    if (_savingsProducts == null) return [];

    print('\n🔍 ========== FILTERING: $category ==========');
    print('📝 Search category: $category');

    final filteredProducts = _savingsProducts!.where((product) {
      final productName = product['name'].toString();
      final productDescription = (product['description'] ?? '').toString();

      // First try to match the entire category name
      final fullMatch = containsWholeWord(productName, category) ||
          containsWholeWord(productDescription, category);

      if (fullMatch) {
        print('''
🔎 Checking: ${product['name']}
  - Full category match found! ✅
  - Matched: "$category" in ${containsWholeWord(productName, category) ? 'name' : 'description'}
''');
        return true;
      }

      // If no full match, try matching individual words
      final categoryWords = category.split(' ');
      final matchedWords = <String>[];

      bool nameMatch = false;
      bool descriptionMatch = false;

      for (final word in categoryWords) {
        if (containsWholeWord(productName, word)) {
          nameMatch = true;
          matchedWords.add('$word (in name)');
        }
        if (containsWholeWord(productDescription, word)) {
          descriptionMatch = true;
          matchedWords.add('$word (in description)');
        }
      }

      print('''
🔎 Checking: ${product['name']}
  - Name: $productName
    Match by name? ${nameMatch ? '✅' : '❌'}
  - Description: $productDescription
    Match by description? ${descriptionMatch ? '✅' : '❌'}
  - Final result: ${(nameMatch || descriptionMatch) ? '✅ MATCHED' : '❌ NO MATCH'}
  - Matched words: ${matchedWords.join(', ')}
''');

      return nameMatch || descriptionMatch;
    }).toList();

    print('''
✨ Results for "$category":
  - Products checked: ${_savingsProducts!.length}
  - Matches found: ${filteredProducts.length}
  - Matching products: ${filteredProducts.map((p) => p['name']).join(', ')}
''');
    print('==========================================\n');

    return filteredProducts;
  }

  List<Map<String, dynamic>> _categories = [
    {
      'title': 'Loans',
      'icon': FontAwesomeIcons.handHoldingDollar,
      'color': const Color(0xFF4C3FF7),
      'filter': (product) =>
          product['name'].toString().toLowerCase().contains('loan') ||
          product['name'].toString().toLowerCase().contains('mobile') ||
          product['name'].toString().toLowerCase().contains('emergency') ||
          product['name'].toString().toLowerCase().contains('repair'),
    },
    {
      'title': 'Insurance',
      'icon': FontAwesomeIcons.shieldHalved,
      'color': const Color(0xFF00C853),
      'filter': (product) =>
          product['name'].toString().toLowerCase().contains('insurance') ||
          product['name'].toString().toLowerCase().contains('cover') ||
          product['name'].toString().toLowerCase().contains('protection') ||
          product['name'].toString().toLowerCase().contains('accident'),
    },
    {
      'title': 'Merry Go Round',
      'icon': FontAwesomeIcons.peopleGroup,
      'color': const Color(0xFFFF5722),
      'filter': (product) =>
          product['name'].toString().toLowerCase().contains('group') ||
          product['name'].toString().toLowerCase().contains('daily') ||
          product['name'].toString().toLowerCase().contains('weekly') ||
          product['name'].toString().toLowerCase().contains('monthly'),
    },
    {
      'title': 'Savings',
      'icon': FontAwesomeIcons.piggyBank,
      'color': const Color(0xFF2196F3),
      'filter': (product) =>
          product['name'].toString().toLowerCase().contains('saving') ||
          product['name'].toString().toLowerCase().contains('deposit'),
    },
    {
      'title': 'Green Mobility',
      'icon': FontAwesomeIcons.leaf,
      'color': const Color(0xFF4CAF50),
      'filter': (product) =>
          product['name'].toString().toLowerCase().contains('electric') ||
          product['name'].toString().toLowerCase().contains('carbon') ||
          product['name'].toString().toLowerCase().contains('battery'),
    },
    {
      'title': 'Discounts',
      'icon': FontAwesomeIcons.tags,
      'color': const Color(0xFFFF9800),
      'filter': (product) =>
          product['name'].toString().toLowerCase().contains('discount') ||
          product['name'].toString().toLowerCase().contains('offer') ||
          product['name'].toString().toLowerCase().contains('deal'),
    },
    {
      'title': 'Boda Jobs',
      'icon': FontAwesomeIcons.briefcase,
      'color': const Color(0xFF9C27B0),
      'filter': (product) =>
          product['name'].toString().toLowerCase().contains('job') ||
          product['name'].toString().toLowerCase().contains('delivery') ||
          product['name'].toString().toLowerCase().contains('task'),
    },
    {
      'title': 'Training & Safety',
      'icon': FontAwesomeIcons.graduationCap,
      'color': const Color(0xFF3F51B5),
      'filter': (product) =>
          product['name'].toString().toLowerCase().contains('training') ||
          product['name'].toString().toLowerCase().contains('course') ||
          product['name'].toString().toLowerCase().contains('safety'),
    },
  ];

  Widget _buildSummaryCard(
      String title, String value, IconData icon, List<Color> colors) {
    return Container(
      margin: const EdgeInsets.only(right: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: 24,
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TopMenuBar(
              title: 'Investments',
              subtitle: 'Grow your wealth',
            ),
            if (_error != null)
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Error: $_error',
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.85,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  final category = _categories[index];
                  final products = _getProductsByCategory(category['title']);
                  final hasProducts = products.isNotEmpty;

                  return GestureDetector(
                    onTap: hasProducts
                        ? () => _showProductDetails(
                            context, category['title'], products)
                        : null,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: category['color'].withOpacity(0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Container(
                            height: 100,
                            decoration: BoxDecoration(
                              color: category['color'],
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(16),
                              ),
                            ),
                            child: Center(
                              child: Icon(
                                category['icon'],
                                color: Colors.white,
                                size: 40,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              children: [
                                Text(
                                  category['title'],
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                ),
                                if (products.isNotEmpty) ...[
                                  const SizedBox(height: 8),
                                  Text(
                                    '${products.length} product${products.length != 1 ? 's' : ''}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: category['color'].withOpacity(0.8),
                                    ),
                                  ),
                                ],
                              ],
                            ),
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
}
