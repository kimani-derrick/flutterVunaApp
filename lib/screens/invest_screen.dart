import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../services/investment_service.dart';
import '../models/user_model.dart';
import '../widgets/top_menu_bar.dart';
import '../services/cache_service.dart';

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
  late BuildContext _rootContext;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _rootContext = context;
  }

  Future<void> _initializeData() async {
    setState(() {
      _isLoading = true;
    });
    await _loadData();
  }

  Future<void> _loadData() async {
    try {
      // Try to get cached data first
      final cachedProducts = await CacheService.getData('savings_products');

      if (cachedProducts != null) {
        setState(() {
          _savingsProducts = List<Map<String, dynamic>>.from(cachedProducts);
          _isLoading = false;
        });
      } else {
        await _fetchFreshData();
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchFreshData() async {
    debugPrint('\n🔄 Starting _fetchFreshData...');
    try {
      setState(() {
        _isLoading = true;
      });
      debugPrint('⏳ Loading state set to true');

      // Fetch your data here
      debugPrint('📡 Fetching fresh data...');
      final products = await InvestmentService.getSavingsProducts();

      // Cache the fresh data
      await CacheService.setData('savings_products', products);

      if (!mounted) return;
      setState(() {
        _savingsProducts = products;
        _isLoading = false;
      });
      debugPrint('✅ Fresh data loaded successfully');
    } catch (e) {
      debugPrint('❌ Error in _fetchFreshData: $e');
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _onRefresh() async {
    debugPrint('\n🔄 Manual refresh triggered for investment screen');
    debugPrint('🗑️ Clearing investment products cache...');
    // Clear cache when manually refreshing
    await CacheService.removeItem(InvestmentService.PRODUCTS_CACHE_KEY);
    debugPrint('✅ Investment products cache cleared');
    await _fetchFreshData();
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
                                  onPressed: () => category == 'Savings'
                                      ? _showActivationAlert(context, product)
                                      : _showInvestmentForm(context, product),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF4C3FF7),
                                    minimumSize:
                                        const Size(double.infinity, 48),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: Text(
                                    category == 'Savings'
                                        ? 'Activate'
                                        : 'Invest Now',
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

  void _showActivationAlert(
      BuildContext context, Map<String, dynamic> product) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Activate Savings Account'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Are you sure you want to activate a ${product['name']} savings account under your profile?',
            ),
            const SizedBox(height: 16),
            const Text(
              'Product Details:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text('Name: ${product['name']}'),
            if (product['description'] != null)
              Text('Description: ${product['description']}'),
            Text('Interest Rate: ${product['nominalAnnualInterestRate']}%'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                final clientId = widget.user?.id;
                if (clientId == null) {
                  throw Exception('Client ID not found');
                }

                // Show loading indicator
                ScaffoldMessenger.of(_rootContext).showSnackBar(
                  const SnackBar(
                    content: Row(
                      children: [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        ),
                        SizedBox(width: 16),
                        Text('Sending activation request...'),
                      ],
                    ),
                    duration: Duration(seconds: 1),
                  ),
                );

                final result = await InvestmentService.activateSavingsAccount(
                  clientId,
                  product['id'],
                );

                if (!mounted) return;

                // Approve the savings account
                debugPrint('\n🔄 Starting approval process...');
                final approvalResult =
                    await InvestmentService.approveSavingsAccount(
                  result['savingsId'],
                );

                if (!mounted) return;

                // Activate the approved savings account
                debugPrint('\n🔄 Starting activation process...');
                final activationResult =
                    await InvestmentService.activateApprovedSavingsAccount(
                  result['savingsId'],
                );

                if (!mounted) return;

                debugPrint('\n🎯 Attempting to show success dialog...');

                // Close the activation confirmation dialog
                Navigator.pop(dialogContext);

                // Use Future.delayed to ensure the first dialog is fully closed
                Future.delayed(const Duration(milliseconds: 300), () {
                  if (!mounted) return;

                  // Show success notification
                  showDialog(
                    context: _rootContext,
                    builder: (BuildContext successDialogContext) {
                      debugPrint('🎨 Building success dialog UI...');
                      return AlertDialog(
                        title: const Padding(
                          padding: EdgeInsets.only(bottom: 8.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.check_circle,
                                  color: Colors.green, size: 24),
                              SizedBox(width: 8),
                              Flexible(
                                child: Text(
                                  'Activation Successful',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            ],
                          ),
                        ),
                        content: const Text(
                          'Your savings account has been activated successfully!',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding:
                            const EdgeInsets.fromLTRB(24, 16, 24, 24),
                        titlePadding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                        actionsPadding:
                            const EdgeInsets.fromLTRB(24, 0, 24, 24),
                        actions: [
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.only(top: 8),
                            child: ElevatedButton(
                              onPressed: () {
                                debugPrint(
                                    '👆 Success dialog OK button pressed');
                                Navigator.pop(successDialogContext);
                                debugPrint('🔄 Refreshing products data...');
                                _fetchFreshData();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF4C3FF7),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                minimumSize: const Size(double.infinity, 45),
                              ),
                              child: const Text(
                                'OK',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ).then((_) {
                    debugPrint('✅ Success dialog closed');
                  });
                  debugPrint('📱 Success dialog display attempted');
                });
              } catch (e) {
                if (!mounted) return;

                // Close the activation confirmation dialog
                Navigator.pop(dialogContext);

                // Show error notification with a slight delay
                Future.delayed(const Duration(milliseconds: 300), () {
                  if (!mounted) return;

                  showDialog(
                    context: _rootContext,
                    builder: (BuildContext errorDialogContext) => AlertDialog(
                      title: const Row(
                        children: [
                          Icon(Icons.error_outline,
                              color: Colors.red, size: 28),
                          SizedBox(width: 8),
                          Text('Activation Failed'),
                        ],
                      ),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Failed to activate savings account.'),
                          const SizedBox(height: 8),
                          const Text(
                            'Error Details:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            e.toString(),
                            style: TextStyle(color: Colors.red[700]),
                          ),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(errorDialogContext),
                          child: const Text('Close'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(errorDialogContext);
                            // Show activation dialog again
                            _showActivationAlert(_rootContext, product);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4C3FF7),
                          ),
                          child: const Text('Try Again'),
                        ),
                      ],
                    ),
                  );
                });
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4C3FF7),
            ),
            child: const Text('Activate'),
          ),
        ],
      ),
    );
  }

  bool containsWholeWord(String text, String query) {
    // Create a regular expression to match the query as a whole word
    final pattern =
        RegExp(r'\b' + RegExp.escape(query) + r'\b', caseSensitive: false);
    return pattern.hasMatch(text);
  }

  List<Map<String, dynamic>> _getProductsByCategory(String categoryTitle) {
    if (_savingsProducts == null) return [];

    print('\n🔍 ========== FILTERING: $categoryTitle ==========');

    // Find the category configuration
    final category = _categories.firstWhere(
      (cat) => cat['title'] == categoryTitle,
      orElse: () => {'filter': (product) => false},
    );

    final filteredProducts = _savingsProducts!.where((product) {
      final matches = category['filter'](product);

      print('''
🔎 Checking: ${product['name']}
  - Category: $categoryTitle
  - Matches filter? ${matches ? '✅' : '❌'}
''');

      return matches;
    }).toList();

    print('''
✨ Results for "$categoryTitle":
  - Products checked: ${_savingsProducts!.length}
  - Matches found: ${filteredProducts.length}
  - Matching products: ${filteredProducts.map((p) => p['name']).join(', ')}
''');
    print('==========================================\n');

    return filteredProducts;
  }

  final List<Map<String, dynamic>> _categories = [
    {
      'title': 'Advances',
      'icon': FontAwesomeIcons.handHoldingDollar,
      'color': const Color(0xFF4C3FF7),
      'description': 'Flexible financing options for your needs',
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
      'description': 'Protect yourself and your business',
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
      'description': 'Join group savings and support each other',
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
      'description': 'Secure your future with smart savings',
      'filter': (product) =>
          product['name'].toString().toLowerCase().contains('saving') ||
          product['name'].toString().toLowerCase().contains('deposit'),
    },
    {
      'title': 'Green Mobility',
      'icon': FontAwesomeIcons.leaf,
      'color': const Color(0xFF4CAF50),
      'description': 'Earn rewards for eco-friendly choices',
      'filter': (product) =>
          product['name'].toString().toLowerCase().contains('electric') ||
          product['name'].toString().toLowerCase().contains('carbon') ||
          product['name'].toString().toLowerCase().contains('battery'),
    },
    {
      'title': 'Discounts',
      'icon': FontAwesomeIcons.tags,
      'color': const Color(0xFFFF9800),
      'description': 'Exclusive deals for members',
      'filter': (product) =>
          product['name'].toString().toLowerCase().contains('discount') ||
          product['name'].toString().toLowerCase().contains('offer') ||
          product['name'].toString().toLowerCase().contains('deal'),
    },
    {
      'title': 'Boda Jobs',
      'icon': FontAwesomeIcons.briefcase,
      'color': const Color(0xFF9C27B0),
      'description': 'Find opportunities and grow',
      'filter': (product) =>
          product['name'].toString().toLowerCase().contains('job') ||
          product['name'].toString().toLowerCase().contains('delivery') ||
          product['name'].toString().toLowerCase().contains('task'),
    },
    {
      'title': 'Training & Safety',
      'icon': FontAwesomeIcons.graduationCap,
      'color': const Color(0xFF3F51B5),
      'description': 'Learn and stay safe on the road',
      'filter': (product) =>
          {
            'training',
            'course',
            'certification',
            'learn',
            'education',
            'workshop'
          }.any((word) =>
              product['name'].toString().toLowerCase().contains(word)) ||
          product['description']
              .toString()
              .toLowerCase()
              .contains('training') ||
          product['description'].toString().toLowerCase().contains('education'),
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

  Widget _buildCategoryCard(Map<String, dynamic> category, bool hasProducts) {
    final products = _getProductsByCategory(category['title']);
    return GestureDetector(
      onTap: hasProducts
          ? () => _showProductDetails(context, category['title'], products)
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
                mainAxisSize: MainAxisSize.min,
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
                  const SizedBox(height: 4),
                  Text(
                    category['description'],
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                  if (products.isNotEmpty) ...[
                    const SizedBox(height: 4),
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
  }

  @override
  void dispose() {
    _investmentAmountController.dispose();
    _investmentPeriodController.dispose();
    _purposeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TopMenuBar(
                title: 'Investments',
                subtitle: 'Grow your wealth',
                userName: widget.user?.displayName,
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
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : GridView.builder(
                        padding: const EdgeInsets.all(16),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.75,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                        itemCount: _categories.length,
                        itemBuilder: (context, index) {
                          final category = _categories[index];
                          final products =
                              _getProductsByCategory(category['title']);
                          final hasProducts = products.isNotEmpty;
                          return _buildCategoryCard(category, hasProducts);
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
