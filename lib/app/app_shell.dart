import 'package:flutter/material.dart';

import '../core/widgets/app_bottom_nav.dart';
import '../features/home/screens/home_screen.dart';
import '../features/calculators/screens/calculators_screen.dart';
import '../features/metals/screens/metals_screen.dart';
import '../features/profile/screens/profile_screen.dart';

class AppShell extends StatefulWidget {
  final int initialIndex;

  const AppShell({super.key, this.initialIndex = 0});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  late int _currentIndex;

  static const List<Widget> _pages = [
    HomeScreen(),
    CalculatorsScreen(),
    MetalsScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: AppBottomNav(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
