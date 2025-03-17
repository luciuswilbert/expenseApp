import 'package:flutter/material.dart';
import 'package:expense_app_project/data/transaction_data.dart'; // ✅ Import transaction data
import 'package:expense_app_project/utils/transaction_helpers.dart'; // ✅ Import helper functions
import 'package:expense_app_project/widgets/filter_dialog_widget.dart'; // ✅ Import filter dialog

class TransactionPage extends StatefulWidget {
  const TransactionPage({Key? key}) : super(key: key);

  @override
  _TransactionPageState createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
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
        padding: const EdgeInsets.all(8.0),
        itemCount: transactions.length, // ✅ Uses transaction data
        itemBuilder: (context, index) {
          final transaction = transactions[index];
          return TransactionCard(
            icon: Icon(
              getCategoryIcon(transaction['category']), // ✅ Assign icon dynamically
              color: getCategoryColor(transaction['category']), // ✅ Assign color dynamically
            ),
            category: transaction['category'],
            amount: transaction['amount'],
            dateTime: transaction['dateTime'],
            color: transaction['color'],
            onTap: () => _showDescriptionDialog(
              context,
              transaction['category'],
              transaction['description'],
              transaction['color'],
              getCategoryColor(transaction['category']), // ✅ Fetch dynamic icon color
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

  /// ✅ Function to show Transaction Description in a Popup Dialog
  void _showDescriptionDialog(
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
                /// ✅ Category Title
                Text(
                  category,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 10),

                /// ✅ Transaction Description
                Text(
                  description,
                  style: const TextStyle(fontSize: 16, color: Colors.black87),
                ),
                const SizedBox(height: 20),

                /// ✅ Close Button
                Align(
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white, // ✅ Text color
                      backgroundColor: iconColor, // ✅ Background color based on category
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
}

/// ✅ **Transaction Card Widget**
class TransactionCard extends StatelessWidget {
  final Icon icon;
  final String category;
  final String amount;
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
      onTap: onTap, // ✅ Opens the description dialog
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          children: [
            icon, // ✅ Displays the category icon
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// ✅ Category Name
                  Text(
                    category,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),

                  /// ✅ Date & Time
                  Text(
                    dateTime,
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ),

            /// ✅ Amount
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
