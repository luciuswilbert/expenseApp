import 'package:expense_app_project/pages/add_expense/add_expense.dart';
import 'package:flutter/material.dart';
import 'package:expense_app_project/data/transaction_data.dart'; // ✅ Import transaction data
import 'package:expense_app_project/utils/transaction_helpers.dart'; // ✅ Import helper functions
import 'package:expense_app_project/widgets/filter_dialog_widget.dart'; // ✅ Import filter dialog
import 'package:flutter_slidable/flutter_slidable.dart';

class TransactionPage extends StatefulWidget {
  const TransactionPage({Key? key}) : super(key: key);

  @override
  TransactionPageState createState() => TransactionPageState();
}

class TransactionPageState extends State<TransactionPage> {
  /// ✅ Declare State Variables
  String selectedDuration = '30 days'; // Default selected duration
  String selectedSort = 'Newest'; // Default sorting
  List<String> selectedCategories = []; // Store selected categories

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Transactions History',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          /// ✅ Filter Icon (Top Right)
          IconButton(
            icon: const Icon(Icons.filter_list, color: Colors.black),
            onPressed: () {
              _showFilterDialog(); // ✅ Open the filter dialog
            },
          ),
        ],
        automaticallyImplyLeading: false, // Remove back arrow
      ),
      body: ListView.builder(
        padding: const EdgeInsets.only(top: 8.0, bottom: 80.0, left: 8.0, right: 8.0),
        itemCount: transactions.length,
        itemBuilder: (context, index) {
          final transaction = transactions[index];
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10), 
            child: ClipPath(
              clipper: RoundedRectClipper(radius: 24.0), // Match your card’s radius
              child: Slidable(
                closeOnScroll: true,
                key: Key(index.toString()),  // Use a unique key (e.g., index or transaction ID if available)
                endActionPane: ActionPane(
                  motion: const StretchMotion(),  // Defines how the actions slide in
                  children: [
                    CustomSlidableAction(
                      onPressed: (context) {
                      // Action for the second button
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddExpensePage(
                              expenseCategory: transaction['category'],
                              totalAmount: transaction['amount'],
                              description: transaction['description'],
                            ),
                          ),
                        );
                      },
                      backgroundColor: Color(0xffdaa520),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.edit, color: Colors.white,size: 26,), // Icon color
                          SizedBox(height: 4), // Spacing between icon and text
                          
                        ],
                      ),
                    ),
                    CustomSlidableAction(
                      onPressed: (context) {
                      // Action for the second button
                      setState(() {
                          transactions.removeAt(index);
                        });
                      },
                      backgroundColor: Colors.red,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.delete, color: Colors.white,size: 26,), // Icon color
                          SizedBox(height: 4), // Spacing between icon and text
                          
                        ],
                      ),
                    ),
                  ],
                ),
                child: TransactionCard(
                  icon: Icon(
                    getCategoryIcon(transaction['category']),
                    color: getCategoryColor(transaction['category']),
                  ),
                  category: transaction['category'],
                  amount: transaction['amount'],
                  dateTime: transaction['dateTime'],
                  color: transaction['color'],
                  onTap: () => showDescriptionDialog(
                    context,
                    transaction['category'],
                    transaction['description'],
                    transaction['color'],
                    getCategoryColor(transaction['category']),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /// ✅ Function to show the Filter Dialog
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

// Show Description Daialog  
void showDescriptionDialog(
  BuildContext context,
  String category,
  String description,
  Color backgroundColor,
  Color iconColor,
) {
  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                category,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                description,
                style: const TextStyle(fontSize: 16, color: Colors.black87),
              ),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.center,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: iconColor,
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

/// ✅ **Transaction Card Widget**
class TransactionCard extends StatelessWidget {
  final Icon icon;
  final String category;
  final double amount;
  final String dateTime;
  final Color color;
  final VoidCallback onTap;

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
      onTap: onTap, // Opens the description dialog
      borderRadius: BorderRadius.circular(24), // Matches the card’s curved edges
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color,
        ),
        child: Row(
          children: [
            icon, // Displays the category icon
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category Name
                  Text(
                    category,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                  // Date & Time
                  Text(
                    dateTime,
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ),
            // Amount
            Text(
              '- RM ${amount}',
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
class RoundedRectClipper extends CustomClipper<Path> {
  final double radius;
  RoundedRectClipper({this.radius = 24.0}); // Adjust this to match your card’s corner radius

  @override
  Path getClip(Size size) {
    final path = Path();
    final rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Radius.circular(radius),
    );
    path.addRRect(rect);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}