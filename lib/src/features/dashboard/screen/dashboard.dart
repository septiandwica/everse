import 'package:compuvers/src/constants/colors.dart';
import 'package:compuvers/src/constants/text_strings.dart';
import 'package:compuvers/src/features/dashboard/screen/announce/announce.dart';
import 'package:compuvers/src/features/dashboard/screen/career/career.dart';
import 'package:compuvers/src/features/dashboard/screen/event/event.dart';
import 'package:compuvers/src/features/dashboard/screen/profile/profile_screen.dart';

import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class UserDashboard extends StatefulWidget {
  const UserDashboard({super.key});

  @override
  _UserDashboardState createState() => _UserDashboardState();
}

class _UserDashboardState extends State<UserDashboard> {
  int _currentIndex = 0; // To track the active page
  int _selectedIndex = 0;
  List<Widget> _pages = [];

  @override
  void initState() {
    super.initState();
    // Initialize the _pages list in initState
    _pages = [
      const EventPage(),  // This page has AppBar
      // AnnouncementPage(),  // No AppBar here
      const CareerPage(),  // No AppBar here
      ProfileScreen(),  // No AppBar here
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _currentIndex = index; // Display the selected page
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
// For other pages, no AppBar is shown
      body: _pages[_currentIndex], // Display page based on index
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 25),
        child: GNav(
          selectedIndex: _selectedIndex,
          onTabChange: _onItemTapped,
          rippleColor: cWhiteColor,
          hoverColor: cSecondaryColor,
          gap: 0,
          activeColor: cSecondaryColor,
          iconSize: 25,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          duration: Duration(milliseconds: 300),
          tabs: [
            GButton(
              icon: Icons.calendar_today,
              onPressed: () {
                _onItemTapped(0);
              },
            ),
            // GButton(
            //   icon: Icons.info,
            //   onPressed: () {
            //     _onItemTapped(1);
            //   },
            // ),
            GButton(
              icon: Icons.business_center,
              onPressed: () {
                _onItemTapped(2);
              },
            ),
            GButton(
              icon: Icons.account_circle,
              onPressed: () {
                _onItemTapped(3);
              },
            ),
          ],
        ),
      ),
    );
  }
}
