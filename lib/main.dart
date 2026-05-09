import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/inventory_screen.dart';
import 'screens/categories_screen.dart';

void main() {
  runApp(const StockCompApp());
}

class StockCompApp extends StatelessWidget {
  const StockCompApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StockComp',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFF0D0D1F),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF00B4D8),
          surface: Color(0xFF1A1A2E),
        ),
        textTheme: GoogleFonts.nunitoTextTheme(
          ThemeData.dark().textTheme,
        ),
      ),
      home: const MainNavigation(),
    );
  }
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const InventoryScreen(),
    const CategoriesScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        backgroundColor: const Color(0xFF1A1A2E),
        selectedItemColor: const Color(0xFF00B4D8),
        unselectedItemColor: Colors.white38,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory_2_outlined),
            activeIcon: Icon(Icons.inventory_2),
            label: 'StockComp',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category_outlined),
            activeIcon: Icon(Icons.category),
            label: 'Categories',
          ),
        ],
      ),
    );
  }
}