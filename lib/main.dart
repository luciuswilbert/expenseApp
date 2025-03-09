import 'package:flutter/material.dart';
import 'package:ui/onboarding.dart';
import 'splash_screen.dart';
import 'transaction_page.dart';
import 'custom_bottom_navigation_bar.dart';
void main() => runApp(const MyApp());
final List<Map<String, dynamic>> transactions = [
  {
    'icon': Icons.shopping_cart,           // Icon to display
    'iconColor': Color(0xffFCAC12),           // Color of the icon
    'category': 'Groceries',              // Transaction category
    'description': 'Buy some grocery items from the supermarket', // Details
    'amount': '- RM 120',                 // Transaction amount
    'dateTime': '28 Feb @ 10:00 AM',      // Date and time
    'color': Color(0xFFFCEED4),          // Background color of the card
  },{
    'icon': Icons.subscriptions,
    'iconColor': Color(0xff8B4513),
    'category': 'Subscription',
    'description': 'Disney+ Annual subscription renewal',
    'amount': '- RM 80',
    'dateTime': '28 Feb @ 03:30 PM',
    'color': Color(0xFFEADDCB), // Light beige
  },
  {
    'icon': Icons.fastfood,
    'iconColor': Color(0xff556B2F),
    'category': 'Food',
    'description': 'Buy a ramen from the local restaurant',
    'amount': '- RM 32',
    'dateTime': '28 Feb @ 07:30 PM',
    'color': Color(0xFFE1DEBC), // Light green
  },
  {
    'icon': Icons.shopping_bag,
    'iconColor': Color(0xffFF2D55),
    'category': 'Shopping',
    'description': 'Buy a pair of shoes from the mall',
    'amount': '- RM 32',
    'dateTime': '28 Feb @ 07:30 PM',
    'color': Color(0xFFFFD8D1), // Light pink
  },
  {
    'icon': Icons.shopping_cart,           // Icon to display
    'iconColor': Color(0xffFCAC12),           // Color of the icon
    'category': 'Groceries',              // Transaction category
    'description': 'Buy some grocery items from the supermarket', // Details
    'amount': '- RM 120',                 // Transaction amount
    'dateTime': '28 Feb @ 10:00 AM',      // Date and time
    'color': Color(0xFFFCEED4),          // Background color of the card
  },
];

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: SplashScreen(
        nextScreen: OnboardingScreen(), // Replace MyHomePage with your main screen widget
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isBalanceVisible = true;

  int _selectedIndex = 0; // Track the selected tab

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Function to show a dialog with the description (explained in Step 3)
  void _showDescriptionDialog(BuildContext context, String description, Color color, Color iconColor) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: color,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Description', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Text(description, style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: color, // Text color
                      backgroundColor: iconColor, // Background color
                    ),
                    child: const Text('Close'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBody: true,
      body: Column(
        children: [
          // Header and Total Balance Section
          Container(
            height: 260,
            padding: const EdgeInsets.only(top: 40, bottom: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.zero, bottom: Radius.elliptical(MediaQuery.sizeOf(context).width/2,25.5),),
              gradient: LinearGradient(
                colors: [const Color(0xFFF0E68C), Color(0xFFDAA520)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Column(
              children: [
                Stack(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text('Good afternoon,', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black)),
                            Text('Lucius Wilbert Tjoa', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black)),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      right: 10,
                      child: IconButton(
                        icon: Stack(
                          children: [
                            const Icon(Icons.notifications, color: Colors.black),
                            Positioned(
                              top: 0,
                              right: 0,
                              child: Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(color: Color(0xffDAA520), shape: BoxShape.circle),
                              ),
                            ),
                          ],
                        ),
                        onPressed: () {
                          print("Notification icon tapped");
                        },
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Text('Total Balance', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: Colors.black)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('RM ', style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.black)),
                          Text(_isBalanceVisible ? '2,440.00' : '****', style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.black)),
                          const SizedBox(width: 8),
                          IconButton(
                            icon: Icon(_isBalanceVisible ? Icons.visibility : Icons.visibility_off, color: Colors.black),
                            onPressed: () {
                              setState(() {
                                _isBalanceVisible = !_isBalanceVisible;
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Transactions History Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Transactions History', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => TransactionPage()));
                    print("See all tapped");
                  },
                  child: const Text('See all', style: TextStyle(color: Colors.grey)),
                ),
              ],
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            //physics: NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(8),
            itemCount: transactions.length,
            itemBuilder: (context, index) {
              final transaction = transactions[index];
              return TransactionCard(
                icon: Icon(transaction['icon'], color: transaction['iconColor']),
                category: transaction['category'],
                amount: transaction['amount'],
                dateTime: transaction['dateTime'],
                color: transaction['color'],
                onTap: () => _showDescriptionDialog(context, transaction['description'],transaction['color'],transaction['iconColor']),
              );
            },
          ),
        ],
      ),
      // **Floating Action Button**
      floatingActionButton: FloatingActionButton(

        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        onPressed: () {
          print("Add transaction tapped");
        },
        backgroundColor: Color(0xffDAA520),
        child: const Icon(Icons.add, color: Colors.white, size: 40,),
        
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // **Bottom Navigation Bar**
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}

// **Transaction Card Widget**
class TransactionCard extends StatelessWidget {
  final Icon icon;              // Icon widget with color
  final String category;        // Transaction category
  final String amount;          // Transaction amount
  final String dateTime;        // Date and time
  final Color color;            // Card background color
  final VoidCallback onTap;     // Function to call when tapped

  const TransactionCard({
    super.key,
    required this.icon,
    required this.category,
    required this.amount,
    required this.dateTime,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,  // Triggers the dialog when tapped
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5,horizontal: 10),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          children: [
            icon,  // Displays the icon
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    dateTime,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              amount,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}