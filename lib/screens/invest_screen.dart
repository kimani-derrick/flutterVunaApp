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
  - Description: ${product['description']}
  - Interest Rate: ${product['nominalAnnualInterestRate']}%
  - Currency: ${product['currency']['displayLabel']}
  - Account Rule: ${product['accountingRule']['value']}
  - Interest Compounding: ${product['interestCompoundingPeriodType']['value']}
  - Interest Posting: ${product['interestPostingPeriodType']['value']}
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
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
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
                                  product['name'],
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
                                Text(
                                  'Interest Compounding: ${product['interestCompoundingPeriodType']['value']}',
                                  style: const TextStyle(fontSize: 14),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Interest Posting: ${product['interestPostingPeriodType']['value']}',
                                  style: const TextStyle(fontSize: 14),
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
      'title': 'Money Market Funds',
      'icon': FontAwesomeIcons.moneyBillTrendUp,
      'colors': [const Color(0xFFFFFFFF), const Color(0xFFF8F9FA)],
      'image':
          'https://images.unsplash.com/photo-1611974789855-9c2a0a7236a3?ixlib=rb-4.0.3&q=100&w=1500&auto=format&fit=crop',
    },
    {
      'title': 'Pension',
      'icon': FontAwesomeIcons.piggyBank,
      'colors': [const Color(0xFFFFFFFF), const Color(0xFFF8F9FA)],
      'image':
          'https://images.unsplash.com/photo-1531206715517-5c0ba140b2b8?ixlib=rb-4.0.3&q=100&w=1500&auto=format&fit=crop',
    },
    {
      'title': 'SACCO',
      'icon': FontAwesomeIcons.handshake,
      'colors': [const Color(0xFFFFFFFF), const Color(0xFFF8F9FA)],
      'image':
          'https://images.unsplash.com/photo-1582213782179-e0d53f98f2ca?ixlib=rb-4.0.3&q=100&w=1500&auto=format&fit=crop',
    },
    {
      'title': 'Real Estate',
      'icon': FontAwesomeIcons.building,
      'colors': [const Color(0xFFFFFFFF), const Color(0xFFF8F9FA)],
      'image':
          'https://images.unsplash.com/photo-1560518883-ce09059eeffa?ixlib=rb-4.0.3&q=100&w=1500&auto=format&fit=crop',
    },
    {
      'title': 'Insurance',
      'icon': FontAwesomeIcons.shieldHalved,
      'colors': [const Color(0xFFFFFFFF), const Color(0xFFF8F9FA)],
      'image':
          'https://images.unsplash.com/photo-1450101499163-c8848c66ca85?ixlib=rb-4.0.3&q=100&w=1500&auto=format&fit=crop',
    },
    {
      'title': 'Stocks',
      'icon': FontAwesomeIcons.chartLine,
      'colors': [const Color(0xFFFFFFFF), const Color(0xFFF8F9FA)],
      'image':
          'https://images.unsplash.com/photo-1611974789855-9c2a0a7236a3?ixlib=rb-4.0.3&q=100&w=1500&auto=format&fit=crop',
    },
    {
      'title': 'Chama',
      'icon': FontAwesomeIcons.peopleGroup,
      'colors': [const Color(0xFFFFFFFF), const Color(0xFFF8F9FA)],
      'image':
          'https://images.unsplash.com/photo-1517245386807-bb43f82c33c4?ixlib=rb-4.0.3&q=100&w=1500&auto=format&fit=crop',
    },
    {
      'title': 'Charity',
      'icon': FontAwesomeIcons.heart,
      'colors': [const Color(0xFFFFFFFF), const Color(0xFFF8F9FA)],
      'image':
          'https://images.unsplash.com/photo-1532629345422-7515f3d16bb6?ixlib=rb-4.0.3&q=100&w=1500&auto=format&fit=crop',
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
                  childAspectRatio: 1.0,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  final category = _categories[index];
                  final products = _getProductsByCategory(category['title']);
                  final hasProducts = products.isNotEmpty;

                  return Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: InkWell(
                      onTap: hasProducts
                          ? () => _showProductDetails(
                              context, category['title'], products)
                          : null,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.network(
                            category['image'],
                            fit: BoxFit.cover,
                          ),
                          Positioned.fill(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 8),
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.9),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        category['icon'],
                                        color: Colors.black,
                                        size: 24,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.9),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        category['title'],
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    if (products.isNotEmpty) ...[
                                      const SizedBox(height: 4),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.9),
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                        child: Text(
                                          '${products.length} product${products.length != 1 ? 's' : ''}',
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 10,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
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
