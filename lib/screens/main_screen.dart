import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../models/user_model.dart';
import 'home_screen.dart';
import 'invest_screen.dart';
import 'profile_screen.dart';

class MainScreen extends StatefulWidget {
  final UserModel? user;
  final String username;
  final String password;

  const MainScreen({
    Key? key,
    this.user,
    required this.username,
    required this.password,
  }) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  late final List<Widget> _screens = [
    HomeScreen(
      user: widget.user,
      username: widget.username,
      password: widget.password,
    ),
    const InvestScreen(),
    ProfileScreen(user: widget.user),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      extendBody: true,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF6C5DD3),
                  Color(0xFF8B80F8),
                ],
              ),
            ),
            child: BottomNavigationBar(
              items: [
                _buildNavItem(FontAwesomeIcons.house, 'Home'),
                _buildNavItem(FontAwesomeIcons.chartLine, 'Invest'),
                _buildNavItem(FontAwesomeIcons.user, 'Profile'),
              ],
              currentIndex: _selectedIndex,
              selectedItemColor: Colors.white,
              unselectedItemColor: Colors.white.withOpacity(0.5),
              backgroundColor: Colors.transparent,
              type: BottomNavigationBarType.fixed,
              selectedFontSize: 12,
              unselectedFontSize: 12,
              iconSize: 20,
              elevation: 0,
              onTap: _onItemTapped,
            ),
          ),
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildNavItem(IconData icon, String label) {
    return BottomNavigationBarItem(
      icon: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          size: 20,
        ),
      ),
      activeIcon: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.white.withOpacity(0.1),
              blurRadius: 8,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Icon(
          icon,
          size: 20,
        ),
      ),
      label: label,
    );
  }
}
