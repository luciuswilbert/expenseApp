import 'package:expense_app_project/pages/Onboard/onboard.dart';
import 'package:flutter/material.dart';
import 'package:expense_app_project/pages/profile/profile_page.dart';
import 'package:expense_app_project/widgets/bottom_nav_bar.dart';
import 'package:expense_app_project/pages/Onboard/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Expense App',
      theme: ThemeData(
        primaryColor: const Color(0xffDAA520),
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const SplashScreen(
        nextScreen: OnboardingScreen(),
      ), // Show splash first
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 3;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _getSelectedPage(_selectedIndex),
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xffDAA520), // Goldenrod
        shape: const CircleBorder(),
        onPressed: () {
          // TODO: Add action for Add Expense
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _getSelectedPage(int index) {
    switch (index) {
      case 0:
        return const Center(child: Text("Home (Coming Soon)"));
      case 1:
        return const Center(child: Text("Transaction (Coming Soon)"));
      case 2:
        return const Center(child: Text("Summary (Coming Soon)"));
      case 3:
      default:
        return const ProfilePage();
    }
  }
}
