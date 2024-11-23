import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../services/investment_service.dart';

class InvestScreen extends StatefulWidget {
  const InvestScreen({Key? key}) : super(key: key);

  @override
  State<InvestScreen> createState() => _InvestScreenState();
}

class _InvestScreenState extends State<InvestScreen> {
  List<Map<String, dynamic>>? _savingsProducts;
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchSavingsProducts();
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
      
      setState(() {
        _savingsProducts = products;
        _isLoading = false;
      });
    } catch (e) {
      print('❌ ERROR: Failed to fetch products: $e');
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  void _showProductDetails(BuildContext context, String category, List<Map<String, dynamic>> products) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        builder: (_, controller) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                category,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  controller: controller,
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        title: Text(product['name']),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Interest Rate: ${product['nominalAnnualInterestRate']}%'),
                            Text('Currency: ${product['currency']['displayLabel']}'),
                            if (product['description'] != null)
                              Text('Description: ${product['description']}'),
                          ],
                        ),
                        isThreeLine: true,
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

  bool containsWholeWord(String text, String query) {
    // Create a regular expression to match the query as a whole word
    final pattern = RegExp(r'\b' + RegExp.escape(query) + r'\b', caseSensitive: false);
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

  Widget _buildInvestmentCard(String title, IconData icon, List<Color> gradientColors, String imageUrl) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: gradientColors[0].withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              // Background Image
              Positioned.fill(
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(color: gradientColors[0]);
                  },
                ),
              ),
              // Gradient Overlay
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        gradientColors[0].withOpacity(0.9),
                        gradientColors[1].withOpacity(0.85),
                      ],
                    ),
                  ),
                ),
              ),
              // Content
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    // TODO: Navigate to specific investment category
                  },
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            icon,
                            color: Colors.white,
                            size: 32,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Text(
                            title,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              shadows: [
                                Shadow(
                                  offset: Offset(0, 1),
                                  blurRadius: 3,
                                  color: Color(0x66000000),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> categories = [
      {
        'title': 'Money Market Funds',
        'icon': FontAwesomeIcons.moneyBillTrendUp,
        'colors': [const Color(0xFF00C897), const Color(0xFF00A572)],
        'image': 'https://images.unsplash.com/photo-1611974789855-9c2a0a7236a3?ixlib=rb-4.0.3&q=85&w=500&auto=format',
      },
      {
        'title': 'Pension',
        'icon': FontAwesomeIcons.piggyBank,
        'colors': [const Color(0xFF4DABF7), const Color(0xFF2B95E9)],
        'image': 'https://images.unsplash.com/photo-1531206715517-5c0ba140b2b8?ixlib=rb-4.0.3&q=85&w=500&auto=format',
      },
      {
        'title': 'SACCO',
        'icon': FontAwesomeIcons.handshake,
        'colors': [const Color(0xFFFF6B6B), const Color(0xFFFF4949)],
        'image': 'https://images.unsplash.com/photo-1582213782179-e0d53f98f2ca?ixlib=rb-4.0.3&q=85&w=500&auto=format',
      },
      {
        'title': 'Real Estate',
        'icon': FontAwesomeIcons.building,
        'colors': [const Color(0xFFFFA726), const Color(0xFFFF9100)],
        'image': 'https://images.unsplash.com/photo-1560518883-ce09059eeffa?ixlib=rb-4.0.3&q=85&w=500&auto=format',
      },
      {
        'title': 'Insurance',
        'icon': FontAwesomeIcons.shieldHalved,
        'colors': [const Color(0xFF7E57C2), const Color(0xFF5E35B1)],
        'image': 'https://images.unsplash.com/photo-1450101499163-c8848c66ca85?ixlib=rb-4.0.3&q=85&w=500&auto=format',
      },
      {
        'title': 'Stocks',
        'icon': FontAwesomeIcons.chartLine,
        'colors': [const Color(0xFF26A69A), const Color(0xFF00897B)],
        'image': 'https://images.unsplash.com/photo-1590283603385-17ffb3a7f29f?ixlib=rb-4.0.3&q=85&w=500&auto=format',
      },
      {
        'title': 'Chama',
        'icon': FontAwesomeIcons.peopleGroup,
        'colors': [const Color(0xFFEF5350), const Color(0xFFE53935)],
        'image': 'https://images.unsplash.com/photo-1517245386807-bb43f82c33c4?ixlib=rb-4.0.3&q=85&w=500&auto=format',
      },
      {
        'title': 'Charity',
        'icon': FontAwesomeIcons.heart,
        'colors': [const Color(0xFFEC407A), const Color(0xFFD81B60)],
        'image': 'https://images.unsplash.com/photo-1532629345422-7515f3d16bb6?ixlib=rb-4.0.3&q=85&w=500&auto=format',
      },
    ];

    return Scaffold(
      body: Column(
        children: [
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
                childAspectRatio: 1,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                final products = _getProductsByCategory(category['title']);
                final hasProducts = products.isNotEmpty;
                
                return Stack(
                  children: [
                    Card(
                      clipBehavior: Clip.antiAlias,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: InkWell(
                        onTap: hasProducts 
                          ? () => _showProductDetails(context, category['title'], products)
                          : null,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                category['colors'][0],
                                category['colors'][1],
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: Stack(
                            children: [
                              // Background image with gradient overlay
                              Positioned.fill(
                                child: Image.network(
                                  category['image'],
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned.fill(
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        category['colors'][0].withOpacity(0.8),
                                        category['colors'][1].withOpacity(0.8),
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                  ),
                                ),
                              ),
                              // Content
                              Container(
                                width: double.infinity,
                                height: double.infinity,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.2),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        category['icon'],
                                        color: Colors.white,
                                        size: 32,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 8),
                                      child: Text(
                                        category['title'],
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          shadows: [
                                            Shadow(
                                              offset: Offset(0, 1),
                                              blurRadius: 3,
                                              color: Color(0x66000000),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    if (hasProducts) ...[
                                      const SizedBox(height: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.3),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Text(
                                          '${products.length} product${products.length != 1 ? 's' : ''}',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    if (_isLoading)
                      Positioned.fill(
                        child: Container(
                          color: Colors.black26,
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
