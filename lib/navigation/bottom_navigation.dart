import 'package:flutter/material.dart';

import '../screens/placeholders/placeholder_screen.dart';
import '../screens/services/campus_services_screen.dart';

/// The reusable bar itself (only draws the 5 tabs).
class AppBottomNavigation extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const AppBottomNavigation({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: currentIndex,
      onDestinationSelected: onTap,
      destinations: const [
        NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Home'),
        NavigationDestination(icon: Icon(Icons.event_outlined), selectedIcon: Icon(Icons.event), label: 'Events'),
        NavigationDestination(icon: Icon(Icons.groups_outlined), selectedIcon: Icon(Icons.groups), label: 'Clubs'),
        NavigationDestination(icon: Icon(Icons.apps_outlined), selectedIcon: Icon(Icons.apps), label: 'Services'),
        NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Profile'),
      ],
    );
  }
}

/// Holds the 5 screens and switches between them.
///
/// INTEGRATION: teammates pass their real screens through the constructor.
/// Any screen that is not passed falls back to a placeholder.
/// The Services tab always uses CampusServicesScreen (your module).
class MainNavigation extends StatefulWidget {
  final Widget? homeScreen; // whoever owns Home
  final Widget? eventsScreen; // Member 2
  final Widget? clubsScreen; // Member 3
  final Widget? profileScreen; // Member 1
  final int initialIndex;

  const MainNavigation({
    super.key,
    this.homeScreen,
    this.eventsScreen,
    this.clubsScreen,
    this.profileScreen,
    this.initialIndex = 0,
  });

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  late int _currentIndex = widget.initialIndex;

  @override
  Widget build(BuildContext context) {
    final screens = <Widget>[
      widget.homeScreen ?? const PlaceholderScreen(title: 'Home', icon: Icons.home),
      widget.eventsScreen ?? const PlaceholderScreen(title: 'Events', icon: Icons.event),
      widget.clubsScreen ?? const PlaceholderScreen(title: 'Clubs', icon: Icons.groups),
      const CampusServicesScreen(),
      widget.profileScreen ?? const PlaceholderScreen(title: 'Profile', icon: Icons.person),
    ];

    return Scaffold(
      // IndexedStack keeps each tab alive, so scroll position is not lost.
      body: IndexedStack(index: _currentIndex, children: screens),
      bottomNavigationBar: AppBottomNavigation(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }
}
