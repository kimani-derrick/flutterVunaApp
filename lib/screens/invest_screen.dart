import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class InvestScreen extends StatelessWidget {
  const InvestScreen({Key? key}) : super(key: key);

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
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          icon,
                          color: Colors.white,
                          size: 32,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
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
        'title': 'All',
        'icon': FontAwesomeIcons.compass,
        'colors': [const Color(0xFF6B4EFF), const Color(0xFF9747FF)],
        'image': 'https://images.unsplash.com/photo-1460925895917-afdab827c52f?ixlib=rb-4.0.3&q=85&w=500&auto=format',
      },
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
        'title': 'SACCOs',
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
          Container(
            padding: const EdgeInsets.fromLTRB(16, 48, 16, 16),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF6B4EFF),
                  Color(0xFF9747FF),
                ],
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(25),
                bottomRight: Radius.circular(25),
              ),
              boxShadow: [
                BoxShadow(
                  color: Color(0x1A000000),
                  blurRadius: 10,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                const Icon(
                  FontAwesomeIcons.compass,
                  color: Colors.white,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Explore Investments',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.7),
                        ),
                      ),
                      const Text(
                        'Find the perfect opportunity',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.search, color: Colors.white),
                  onPressed: () {
                    // TODO: Implement search functionality
                  },
                ),
              ],
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
                return _buildInvestmentCard(
                  category['title'],
                  category['icon'],
                  category['colors'] as List<Color>,
                  category['image'] as String,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
