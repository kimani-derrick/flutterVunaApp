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
      'icon': FontAwesomeIcons.handHoldingDollar,
      'color': const Color(0xFF1565C0),
      'title': 'Advances',
      'description': 'Quick financial solutions for your needs',
    },
    {
      'title': 'Insurance',
      'icon': FontAwesomeIcons.shieldHalved,
      'color': const Color(0xFF00C853),
      'description': 'Protect yourself and your business',
      'subcategories': [
        {
          'name': 'Bike Insurance',
          'icon': FontAwesomeIcons.motorcycle,
          'description': 'Comprehensive insurance coverage for your motorcycle',
          'benefits': [
            'Third party liability cover',
            'Accident coverage',
            'Theft protection',
            'Emergency roadside assistance'
          ]
        },
        {
          'name': 'Health Cover',
          'icon': FontAwesomeIcons.heartPulse,
          'description': 'Affordable health insurance for you and your family',
          'benefits': [
            'Outpatient coverage',
            'Inpatient coverage',
            'Maternity benefits',
            'Dental and optical cover'
          ]
        },
        {
          'name': 'Personal Accident',
          'icon': FontAwesomeIcons.personCircleCheck,
          'description': 'Protection against accidents and disabilities',
          'benefits': [
            'Accident medical expenses',
            'Permanent disability cover',
            'Loss of income protection',
            'Funeral expenses cover'
          ]
        },
        {
          'name': 'Business Cover',
          'icon': FontAwesomeIcons.buildingShield,
          'description':
              'Comprehensive protection for your business operations',
          'benefits': [
            'Property damage coverage',
            'Business interruption cover',
            'Public liability protection',
            'Employee coverage'
          ]
        }
      ]
    },
    {
      'title': 'Savings',
      'icon': FontAwesomeIcons.piggyBank,
      'color': const Color(0xFF2196F3),
      'description': 'Secure your future with smart savings',
      'subcategories': [
        {
          'name': 'Daily Savings',
          'icon': FontAwesomeIcons.wallet,
          'description': 'Flexible daily savings account with instant access',
          'benefits': [
            'No minimum balance',
            'Daily interest accrual',
            'Mobile money integration',
            'Free withdrawals'
          ]
        },
        {
          'name': 'Fixed Deposits',
          'icon': FontAwesomeIcons.vault,
          'description': 'High-yield fixed deposit accounts for better returns',
          'benefits': [
            'Competitive interest rates',
            'Flexible tenure options',
            'Automatic renewal',
            'Interest payout options'
          ]
        },
        {
          'name': 'Goal Savings',
          'icon': FontAwesomeIcons.bullseye,
          'description': 'Target-based savings for your specific goals',
          'benefits': [
            'Goal tracking tools',
            'Automated savings',
            'Bonus on achievement',
            'Flexible withdrawal options'
          ]
        },
        {
          'name': 'Emergency Fund',
          'icon': FontAwesomeIcons.umbrellaBeach,
          'description': 'Build your safety net for unexpected expenses',
          'benefits': [
            'Quick access when needed',
            'No penalty withdrawals',
            'Automatic top-up options',
            'Regular saving reminders'
          ]
        }
      ]
    },
    {
      'title': 'Merry Go Rounds',
      'icon': FontAwesomeIcons.peopleGroup,
      'color': const Color(0xFFFF5722),
      'description': 'Join group savings and support each other',
      'subcategories': [
        {
          'name': 'Daily Groups',
          'icon': FontAwesomeIcons.userGroup,
          'description': 'Join daily contribution groups for quick returns',
          'benefits': [
            'Daily payouts',
            'Small contribution amounts',
            'Flexible membership',
            'Mobile money integration'
          ]
        },
        {
          'name': 'Weekly Groups',
          'icon': FontAwesomeIcons.users,
          'description': 'Weekly contribution groups for medium-term savings',
          'benefits': [
            'Weekly distributions',
            'Moderate contribution size',
            'Group chat feature',
            'Payment reminders'
          ]
        },
        {
          'name': 'Monthly Groups',
          'icon': FontAwesomeIcons.peopleRoof,
          'description': 'Monthly contribution groups for larger savings',
          'benefits': [
            'Higher returns',
            'Larger pool amounts',
            'Structured payouts',
            'Group governance'
          ]
        },
        {
          'name': 'Create Group',
          'icon': FontAwesomeIcons.userPlus,
          'description': 'Start your own merry-go-round group',
          'benefits': [
            'Custom rules setting',
            'Member management',
            'Payment tracking',
            'Automated distributions'
          ]
        }
      ]
    },
    {
      'title': 'Green Mobility',
      'icon': FontAwesomeIcons.leaf,
      'color': const Color(0xFF4CAF50),
      'description': 'Earn rewards for eco-friendly choices',
      'subcategories': [
        {
          'name': 'Electric Bikes',
          'icon': FontAwesomeIcons.bolt,
          'description': 'Switch to eco-friendly electric motorcycles',
          'benefits': [
            'Lower running costs',
            'Zero emissions',
            'Government incentives',
            'Modern technology'
          ]
        },
        {
          'name': 'Carbon Credits',
          'icon': FontAwesomeIcons.earthAfrica,
          'description': 'Earn credits for reducing carbon emissions',
          'benefits': [
            'Monthly rewards',
            'Environmental impact',
            'Additional income',
            'Track your contribution'
          ]
        },
        {
          'name': 'Battery Charging',
          'icon': FontAwesomeIcons.batteryHalf,
          'description': 'Access our network of charging stations',
          'benefits': [
            'Wide station network',
            'Quick charging',
            'Loyalty points',
            'Real-time availability'
          ]
        },
        {
          'name': 'Battery Swap',
          'icon': FontAwesomeIcons.arrowsRotate,
          'description': 'Quick battery swap services for continuous riding',
          'benefits': [
            'Instant power',
            'No charging wait',
            'Battery warranty',
            'Multiple locations'
          ]
        }
      ]
    },
    {
      'title': 'Discounts',
      'icon': FontAwesomeIcons.tags,
      'color': const Color(0xFFFF9800),
      'description': 'Exclusive deals for members',
      'subcategories': [
        {
          'name': 'Bike Deals',
          'icon': FontAwesomeIcons.motorcycle,
          'description': 'Special offers on new and used motorcycles',
          'benefits': [
            'Exclusive pricing',
            'Verified sellers',
            'Financing options',
            'After-sale support'
          ]
        },
        {
          'name': 'Fuel Discounts',
          'icon': FontAwesomeIcons.gasPump,
          'description': 'Save money on your fuel purchases',
          'benefits': [
            'Daily discounts',
            'Multiple stations',
            'Point collection',
            'Digital vouchers'
          ]
        },
        {
          'name': 'Tyre Offers',
          'icon': FontAwesomeIcons.ring,
          'description': 'Quality tyres at discounted prices',
          'benefits': [
            'Top brands available',
            'Installation included',
            'Warranty coverage',
            'Regular promotions'
          ]
        },
        {
          'name': 'Spare Parts',
          'icon': FontAwesomeIcons.gear,
          'description': 'Discounted genuine spare parts',
          'benefits': [
            'Genuine parts only',
            'Competitive prices',
            'Wide selection',
            'Expert advice'
          ]
        }
      ]
    },
    {
      'title': 'Boda Jobs',
      'icon': FontAwesomeIcons.briefcase,
      'color': const Color(0xFF9C27B0),
      'description': 'Find opportunities and grow',
      'subcategories': [
        {
          'name': 'Deliveries',
          'icon': FontAwesomeIcons.box,
          'description': 'Connect with delivery opportunities in your area',
          'benefits': [
            'Flexible schedule',
            'Instant payments',
            'Route optimization',
            'Insurance coverage'
          ]
        },
        {
          'name': 'Advertising',
          'icon': FontAwesomeIcons.ad,
          'description': 'Earn extra by displaying advertisements',
          'benefits': [
            'Passive income',
            'Choose your ads',
            'Weekly payments',
            'No extra work'
          ]
        },
        {
          'name': 'Booking Agent',
          'icon': FontAwesomeIcons.userTie,
          'description': 'Become a booking agent for other riders',
          'benefits': [
            'Commission based',
            'Work from home',
            'Training provided',
            'Support system'
          ]
        },
        {
          'name': 'First Responder',
          'icon': FontAwesomeIcons.kitMedical,
          'description': 'Join our network of emergency first responders',
          'benefits': [
            'First aid training',
            'Emergency equipment',
            'Priority dispatch',
            'Additional income'
          ]
        },
        {
          'name': 'General Tasks',
          'icon': FontAwesomeIcons.listCheck,
          'description': 'Various short-term tasks and opportunities',
          'benefits': [
            'Daily tasks available',
            'Choose your work',
            'Immediate payment',
            'Rating system'
          ]
        }
      ]
    },
    {
      'title': 'Training & Safety',
      'icon': FontAwesomeIcons.graduationCap,
      'color': const Color(0xFF3F51B5),
      'description': 'Learn and stay safe on the road',
      'subcategories': [
        {
          'name': 'Online Courses',
          'icon': FontAwesomeIcons.laptop,
          'description': 'Learn at your own pace with our online courses',
          'benefits': [
            'Flexible learning',
            'Video tutorials',
            'Progress tracking',
            'Certification included'
          ]
        },
        {
          'name': 'Get Certified',
          'icon': FontAwesomeIcons.certificate,
          'description': 'Obtain professional certifications',
          'benefits': [
            'Recognized certificates',
            'Practical training',
            'Career advancement',
            'Job placement support'
          ]
        },
        {
          'name': 'Safety Alerts',
          'icon': FontAwesomeIcons.bell,
          'description': 'Real-time safety and traffic alerts',
          'benefits': [
            'Live updates',
            'Weather alerts',
            'Road conditions',
            'Emergency notifications'
          ]
        },
        {
          'name': 'Road Rules',
          'icon': FontAwesomeIcons.trafficLight,
          'description': 'Stay updated with traffic rules and regulations',
          'benefits': [
            'Regular updates',
            'Interactive quizzes',
            'Visual guides',
            'Local regulations'
          ]
        }
      ]
    },
  ];

  final List<Map<String, dynamic>> _products = [
    {
      'name': 'Mobile Advance',
      'description':
          'Get instant advances to purchase the latest smartphones with flexible repayment terms',
      'icon': FontAwesomeIcons.mobileScreen,
      'color': const Color(0xFF1565C0),
      'category': 'Advances',
    },
    {
      'name': 'Bike Advance',
      'description': 'Get your dream bike with our flexible advance options',
      'icon': FontAwesomeIcons.motorcycle,
      'color': const Color(0xFF1565C0),
      'category': 'Advances',
    },
    {
      'name': 'Emergency Advance',
      'description': 'Quick financial support when you need it most',
      'icon': FontAwesomeIcons.briefcaseMedical,
      'color': const Color(0xFF1565C0),
      'category': 'Advances',
    },
  ];

  void _showSubcategoryDetails(BuildContext context,
      Map<String, dynamic> subcategory, Color categoryColor) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.85,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (_, controller) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: categoryColor,
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
                        Icon(subcategory['icon'],
                            color: Colors.white, size: 32),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      subcategory['name'],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  controller: controller,
                  padding: const EdgeInsets.all(20),
                  children: [
                    Text(
                      subcategory['description'],
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Benefits',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...List.generate(
                      subcategory['benefits'].length,
                      (index) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          children: [
                            Icon(Icons.check_circle,
                                color: categoryColor, size: 20),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                subcategory['benefits'][index],
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: categoryColor,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Login to Access',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        // Add navigation to registration screen
                        // Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterScreen()));
                      },
                      child: Text(
                        'New User? Register Here',
                        style: TextStyle(
                          fontSize: 16,
                          color: categoryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSubcategoryCard(
      Map<String, dynamic> subcategory, Color categoryColor) {
    return GestureDetector(
      onTap: () => _showSubcategoryDetails(context, subcategory, categoryColor),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: categoryColor.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              subcategory['icon'],
              size: 32,
              color: categoryColor,
            ),
            const SizedBox(height: 12),
            Text(
              subcategory['name'],
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: categoryColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tap to learn more',
              style: TextStyle(
                fontSize: 12,
                color: categoryColor.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }

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
                    return _buildSubcategoryCard(
                        subcategory, category['color']);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMainCard(Map<String, dynamic> category) {
    return Container(
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
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
              color: category['color'],
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
              ],
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
                  children: [
                    const Center(
                      child: Text(
                        'Vuna',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'A digital platform specifically designed for Bodaboda cooperatives',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
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
                      child: _buildMainCard(category),
                    );
                  },
                  childCount: _categories.length,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      height: 56,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFF4C3FF7), Color(0xFF6C5DD3)],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF4C3FF7).withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginScreen(),
                              ),
                            );
                          },
                          borderRadius: BorderRadius.circular(16),
                          child: const Center(
                            child: Text(
                              'Get Started',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
