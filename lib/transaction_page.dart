import 'package:flutter/material.dart';
import 'package:ui/main.dart';
import 'filter_dialog_widget.dart';
import 'custom_bottom_navigation_bar.dart';

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
    'icon': Icons.category_outlined,           // Icon to display
    'iconColor': Color(0xff8B4513),           // Color of the icon
    'category': 'Miscellaneous',              // Transaction category
    'description': 'Pay Barbershop', // Details
    'amount': '- RM 120',                 // Transaction amount
    'dateTime': '28 Feb @ 10:00 AM',      // Date and time
    'color': Color(0xFFFAFAD2),          // Background color of the card
  },{
    'icon': Icons.health_and_safety_outlined,
    'iconColor': Color(0xffFF1493),
    'category': 'Healthcare',
    'description': 'Buy Vitamin',
    'amount': '- RM 80',
    'dateTime': '28 Feb @ 03:30 PM',
    'color': Color(0xFFFFE1F0), // Light beige
  },
  {
    'icon': Icons.emoji_transportation,
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
  },{
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
  },{
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
  },{
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
  },{
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
];


class TransactionPage extends StatefulWidget {
  @override
  _TransactionPageState createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  String selectedDuration = '30 days'; // Default selected duration
  String selectedSort = 'Newest'; // Default selected sort
  List<String> selectedCategories = []; // Selected categories
  
  int _selectedIndex = 1; // Track the selected tab

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  
  // Function to show a dialog with the description (explained in Step 3)
  void _showDescriptionDialog(BuildContext context, String description,Color color, Color iconColor) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: color,//Color.fromARGB(255, 255, 251, 211),
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
      appBar: AppBar(
        title: Text(
          'Transactions History',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list, color: Colors.black),
            onPressed: () {
              _showFilterDialog();
            },
          ),
        ],
        automaticallyImplyLeading: false, // Remove back arrow

      ),
      body: ListView(
        children: [
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.all(8.0),
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
      extendBody: true,
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }

  

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => FilterDialog(
        initialDuration: selectedDuration,
        initialSort: selectedSort,
        initialSelectedCategories: selectedCategories,
        onApply: (duration, sort, categories) {
          setState(() {
            selectedDuration = duration;
            selectedSort = sort;
            selectedCategories = categories;
          });
        },
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