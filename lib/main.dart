import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:expense_app_project/widget_tree.dart';
import 'package:expense_app_project/firebase_options.dart';
import 'package:expense_app_project/pages/home/home_page.dart';
import 'package:expense_app_project/pages/Onboard/onboard.dart';
import 'package:expense_app_project/widgets/bottom_nav_bar.dart';
import 'package:expense_app_project/pages/profile/profile_page.dart';
import 'package:expense_app_project/pages/Onboard/splash_screen.dart';
import 'package:expense_app_project/pages/add_expense/add_expense.dart';
import 'package:expense_app_project/pages/transaction/transaction_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print("🔥 Firebase initialized successfully!"); // Debug message
  } catch (e) {
    print("❌ Firebase initialization failed: $e");
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Expense App',
      theme: ThemeData(primarySwatch: Colors.orange),
      home: const WidgetTree(),
    );
  }
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

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
  int _selectedIndex = 0;

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
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddExpensePage()),
          );
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _getSelectedPage(int index) {
    switch (index) {
      case 0:
        return const Center(child: HomePage());
      case 1:
        return TransactionPage();
      case 2:
        return const Center(child: Text("Summary (Coming Soon)"));
      case 3:
      default:
        return const ProfilePage();
    }
  }
}
