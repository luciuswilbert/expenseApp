import 'package:expense_app_project/pages/add_expense/ocr_add_expense.dart';
import 'package:expense_app_project/pages/login_register/google_profile.dart';
import 'package:expense_app_project/pages/login_register/login_register_screen.dart';
import 'package:expense_app_project/pages/login_register/login_screen.dart';
import 'package:expense_app_project/pages/login_register/profile_success_screen.dart';
import 'package:expense_app_project/pages/login_register/saving_profile_screen.dart';
import 'package:expense_app_project/pages/login_register/sign_up_screen.dart';
import 'package:expense_app_project/providers/google.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:expense_app_project/providers/firebase_options.dart';
import 'package:expense_app_project/pages/home/home_page.dart';
import 'package:expense_app_project/pages/Onboard/onboard.dart';
import 'package:expense_app_project/widgets/bottom_nav_bar.dart';
import 'package:expense_app_project/pages/profile/profile_page.dart';
import 'package:expense_app_project/pages/Onboard/splash_screen.dart';
import 'package:expense_app_project/pages/add_expense/add_expense.dart';
import 'package:expense_app_project/pages/transaction/transaction_page.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

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
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp, // Restricts to portrait mode only
  ]).then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => GoogleSignInProvider()),
      ],

      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Expense App',
        theme: ThemeData(primarySwatch: Colors.orange),
        initialRoute: "/",
        routes: {
          "/saving-profile": (context) => const SavingProfileScreen(),
          "/profile-success": (context) => const ProfileSuccessScreen(),
          "/":
              (context) => SplashScreen(
                nextScreen: LoginRegisterScreen(),
              ), // Make sure this is correct
          "/homepage": (context) => const MainScreen(),
          "/login": (context) => LoginScreen(),
          "/sign-up": (context) => SignUpScreen(),
          "/profile": (context) => ProfileScreen(),
          "/ocr": (context) => OCRAddExpensePage(),
        },
      ),
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
