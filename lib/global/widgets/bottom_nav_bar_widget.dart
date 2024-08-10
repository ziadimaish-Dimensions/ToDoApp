import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:to_do_app/features/tasks/views/tasks_screen.dart';
import 'package:to_do_app/features/settings/view/settings_screen.dart';

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
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF363636),
            boxShadow: [
              BoxShadow(
                blurRadius: 20,
                color: Colors.black.withOpacity(0.1),
              ),
            ],
          ),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
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
                _buildGButton(0, Icons.add, Icons.add),
                _buildGButton(1, Icons.person, Icons.person_outline),
              ],
              selectedIndex: _selectedIndex,
              onTabChange: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
            ),
          ),
        ),
      ),
    );
  }

  GButton _buildGButton(int index, IconData activeIcon, IconData inactiveIcon) {
    return GButton(
      icon: _selectedIndex == index ? activeIcon : inactiveIcon,
      text: '',
      iconActiveColor: Colors.white,
      iconColor: Colors.white,
      iconSize: 24,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
    );
  }

  static const List<Widget> _widgetOptions = <Widget>[
    TaskScreen(),
    SettingsScreen(),
  ];
}
