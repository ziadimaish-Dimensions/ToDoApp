import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:to_do_app/features/home/home_screen.dart';

class BottomNavBarWidget extends StatefulWidget {
  const BottomNavBarWidget({super.key});

  @override
  State<BottomNavBarWidget> createState() => _BottomNavBarWidgetState();
}

class _BottomNavBarWidgetState extends State<BottomNavBarWidget> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: SafeArea(
        child: GNav(
          rippleColor: Colors.grey[300]!,
          hoverColor: Colors.grey[100]!,
          gap: 8,
          activeColor: Colors.white,
          iconSize: 24,
          duration: const Duration(milliseconds: 400),
          tabBackgroundColor: Colors.transparent,
          color: Colors.white,
          backgroundColor: const Color(0xFF363636),
          tabs: [
            _buildGButton(0, Icons.mail, Icons.mail_outline),
            _buildGButton(
                1, Icons.calendar_month, Icons.calendar_month_outlined),
            _buildGButton(2, Icons.add, Icons.add),
            _buildGButton(3, Icons.access_time_filled, Icons.access_time),
            _buildGButton(4, Icons.person, Icons.person_outline),
          ],
          selectedIndex: _selectedIndex,
          onTabChange: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
        ),
      ),
    );
  }

  GButton _buildGButton(int index, IconData activeIcon, IconData inactiveIcon) {
    return GButton(
      icon: _selectedIndex == index ? activeIcon : inactiveIcon,
      text: '',
    );
  }

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.w600);

  static const List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    Text(
      'Calendar',
      style: optionStyle,
    ),
    Text(
      'Search',
      style: optionStyle,
    ),
    Text(
      'Focus',
      style: optionStyle,
    ),
    Text(
      'Profile',
      style: optionStyle,
    ),
  ];
}
