import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'login_screen.dart';

class MarketplaceScreen extends StatefulWidget {
  const MarketplaceScreen({Key? key}) : super(key: key);

  @override
  State<MarketplaceScreen> createState() => _MarketplaceScreenState();
}

class _MarketplaceScreenState extends State<MarketplaceScreen> {
  final List<Map<String, dynamic>> _categories = [
    {
      'title': 'Loans',
      'icon': FontAwesomeIcons.handHoldingDollar,
      'color': const Color(0xFF4C3FF7),
      'image':
          'https://images.unsplash.com/photo-1556742111-a301076d9d18?ixlib=rb-4.0.3&q=85&w=1600&auto=format',
      'description': 'Flexible financing options for your needs',
      'subcategories': [
        {'name': 'Mobile Phones', 'icon': FontAwesomeIcons.mobileScreen},
        {'name': 'Bike Loans', 'icon': FontAwesomeIcons.motorcycle},
        {'name': 'Emergency Loans', 'icon': FontAwesomeIcons.briefcaseMedical},
        {
          'name': 'Repair Financing',
          'icon': FontAwesomeIcons.screwdriverWrench
        },
      ]
    },
    {
      'title': 'Insurance',
      'icon': FontAwesomeIcons.shieldHalved,
      'color': const Color(0xFF00C853),
      'image':
          'https://images.unsplash.com/photo-1450101499163-c8848c66ca85?ixlib=rb-4.0.3&q=85&w=1600&auto=format',
      'description': 'Protect yourself and your business',
      'subcategories': [
        {'name': 'Bike Insurance', 'icon': FontAwesomeIcons.motorcycle},
        {'name': 'Health Cover', 'icon': FontAwesomeIcons.heartPulse},
        {
          'name': 'Personal Accident',
          'icon': FontAwesomeIcons.personCircleCheck
        },
        {'name': 'Business Cover', 'icon': FontAwesomeIcons.buildingShield},
      ]
    },
    {
      'title': 'Savings',
      'icon': FontAwesomeIcons.piggyBank,
      'color': const Color(0xFF2196F3),
      'image':
          'https://images.unsplash.com/photo-1579621970563-ebec7560ff3e?ixlib=rb-4.0.3&q=85&w=1600&auto=format',
      'description': 'Secure your future with smart savings',
      'subcategories': [
        {'name': 'Daily Savings', 'icon': FontAwesomeIcons.wallet},
        {'name': 'Fixed Deposits', 'icon': FontAwesomeIcons.vault},
        {'name': 'Goal Savings', 'icon': FontAwesomeIcons.bullseye},
        {'name': 'Emergency Fund', 'icon': FontAwesomeIcons.umbrellaBeach},
      ]
    },
    {
      'title': 'Merry Go Rounds',
      'icon': FontAwesomeIcons.peopleGroup,
      'color': const Color(0xFFFF5722),
      'image':
          'https://images.unsplash.com/photo-1582213782179-e0d53f98f2ca?ixlib=rb-4.0.3&q=85&w=1600&auto=format',
      'description': 'Join group savings and support each other',
      'subcategories': [
        {'name': 'Daily Groups', 'icon': FontAwesomeIcons.userGroup},
        {'name': 'Weekly Groups', 'icon': FontAwesomeIcons.users},
        {'name': 'Monthly Groups', 'icon': FontAwesomeIcons.peopleRoof},
        {'name': 'Create Group', 'icon': FontAwesomeIcons.userPlus},
      ]
    },
    {
      'title': 'Green Mobility',
      'icon': FontAwesomeIcons.leaf,
      'color': const Color(0xFF4CAF50),
      'image':
          'https://images.unsplash.com/photo-1582213782179-e0d53f98f2ca?ixlib=rb-4.0.3&q=85&w=1600&auto=format',
      'description': 'Earn rewards for eco-friendly choices',
      'subcategories': [
        {'name': 'Electric Bikes', 'icon': FontAwesomeIcons.bolt},
        {'name': 'Carbon Credits', 'icon': FontAwesomeIcons.earthAfrica},
        {'name': 'Battery Charging', 'icon': FontAwesomeIcons.batteryHalf},
        {'name': 'Battery Swap', 'icon': FontAwesomeIcons.arrowsRotate},
      ]
    },
    {
      'title': 'Discounts',
      'icon': FontAwesomeIcons.tags,
      'color': const Color(0xFFFF9800),
      'image':
          'https://images.unsplash.com/photo-1607082349566-187342175e2f?ixlib=rb-4.0.3&q=85&w=1600&auto=format',
      'description': 'Exclusive deals for members',
      'subcategories': [
        {'name': 'Bike Deals', 'icon': FontAwesomeIcons.motorcycle},
        {'name': 'Fuel Discounts', 'icon': FontAwesomeIcons.gasPump},
        {'name': 'Tyre Offers', 'icon': FontAwesomeIcons.ring},
        {'name': 'Spare Parts', 'icon': FontAwesomeIcons.gear},
      ]
    },
    {
      'title': 'Boda Jobs',
      'icon': FontAwesomeIcons.briefcase,
      'color': const Color(0xFF9C27B0),
      'image':
          'https://images.unsplash.com/photo-1669824774762-6b44c09de0f3?ixlib=rb-4.0.3&q=85&w=1600&auto=format',
      'description': 'Find opportunities and grow',
      'subcategories': [
        {'name': 'Deliveries', 'icon': FontAwesomeIcons.box},
        {'name': 'Advertising', 'icon': FontAwesomeIcons.ad},
        {'name': 'Booking Agent', 'icon': FontAwesomeIcons.userTie},
        {'name': 'First Responder', 'icon': FontAwesomeIcons.kitMedical},
        {'name': 'General Tasks', 'icon': FontAwesomeIcons.listCheck},
      ]
    },
    {
      'title': 'Training & Safety',
      'icon': FontAwesomeIcons.graduationCap,
      'color': const Color(0xFF3F51B5),
      'image':
          'https://images.unsplash.com/photo-1434626881859-194d67b2b86f?ixlib=rb-4.0.3&q=85&w=1600&auto=format',
      'description': 'Learn and stay safe on the road',
      'subcategories': [
        {'name': 'Online Courses', 'icon': FontAwesomeIcons.laptop},
        {'name': 'Get Certified', 'icon': FontAwesomeIcons.certificate},
        {'name': 'Safety Alerts', 'icon': FontAwesomeIcons.bell},
        {'name': 'Road Rules', 'icon': FontAwesomeIcons.trafficLight},
      ]
    },
  ];

  void _showSubcategories(BuildContext context, Map<String, dynamic> category) {
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
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: category['color'],
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(20)),
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(category['icon'], color: Colors.white, size: 24),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      category['title'],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      category['description'],
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: GridView.builder(
                  controller: controller,
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1.3,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: category['subcategories'].length,
                  itemBuilder: (context, index) {
                    final subcategory = category['subcategories'][index];
                    return GestureDetector(
                      onTap: () => _showLoginDialog(context),
                      child: Container(
                        decoration: BoxDecoration(
                          color: category['color'].withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: category['color'].withOpacity(0.2),
                            width: 2,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              subcategory['icon'],
                              color: category['color'],
                              size: 32,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              subcategory['name'],
                              style: TextStyle(
                                color: category['color'],
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
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
      ),
    );
  }

  void _showLoginDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Join VunaSacco'),
        content: const Text(
            'Sign up or login to access this feature and enjoy exclusive benefits for Bodaboda riders.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Later'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4C3FF7),
            ),
            child: const Text('Get Started'),
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
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF4C3FF7), Color(0xFF6C5DD3)],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'VunaSacco',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'A digital platform specifically designed for Bodaboda cooperatives',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.85,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final category = _categories[index];
                    return GestureDetector(
                      onTap: () => _showSubcategories(context, category),
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 100,
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(16),
                                ),
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    category['color'],
                                    category['color'].withOpacity(0.8),
                                  ],
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    category['title'],
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
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
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  childCount: _categories.length,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
