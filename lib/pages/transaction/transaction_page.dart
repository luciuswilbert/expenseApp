import 'package:flutter/material.dart';
import 'package:expense_app_project/data/transaction_data.dart';
import 'package:expense_app_project/widgets/filter_dialog_widget.dart';

class TransactionPage extends StatefulWidget {
  const TransactionPage({Key? key}) : super(key: key);

  @override
  _TransactionPageState createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  /// ✅ Declare State Variables
  String selectedDuration = '30 days'; // Default selected duration
  String selectedSort = 'Newest'; // Default selected sorting
  List<String> selectedCategories = []; // List to store selected categories

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
              _showFilterDialog(); // ✅ Call the function to open the filter dialog
            },
          ),
        ],
        automaticallyImplyLeading: false, // Remove back arrow
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(8.0),
        itemCount:
            transactions.length, // ✅ Now uses the imported transaction list
        itemBuilder: (context, index) {
          final transaction = transactions[index];
          return TransactionCard(
            icon: Icon(transaction['icon'], color: transaction['iconColor']),
            category: transaction['category'],
            amount: transaction['amount'],
            dateTime: transaction['dateTime'],
            color: transaction['color'],
            onTap:
                () => _showDescriptionDialog(
                  context,
                  transaction['description'],
                  transaction['color'],
                  transaction['iconColor'],
                ),
          );
        },
      ),
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder:
          (context) => FilterDialog(
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

  /// Dialog to show transaction description
  void _showDescriptionDialog(
    BuildContext context,
    String description,
    Color color,
    Color iconColor,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Description',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
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
}

/// ✅ Transaction Card Widget (Reusable)
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
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          children: [
            icon,
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
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
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
