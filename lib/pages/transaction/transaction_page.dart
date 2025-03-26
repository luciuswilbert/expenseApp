import 'package:expense_app_project/pages/add_expense/add_expense.dart';
import 'package:flutter/material.dart';
import 'package:expense_app_project/data/transaction_data.dart'; // ✅ Import transaction data
import 'package:expense_app_project/utils/transaction_helpers.dart'; // ✅ Import helper functions
import 'package:expense_app_project/widgets/filter_dialog_widget.dart'; // ✅ Import filter dialog
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart'; // For date formatting

class TransactionPage extends StatefulWidget {
  const TransactionPage({Key? key}) : super(key: key);

  @override
  TransactionPageState createState() => TransactionPageState();
}

class TransactionPageState extends State<TransactionPage> {
  String selectedDuration = 'Month'; // Default view
  String selectedSort = 'Newest'; // Default sorting
  List<String> selectedCategories = []; // Store selected categories

  @override
  Widget build(BuildContextContext) {
    final user = FirebaseAuth.instance.currentUser; // Get current user's ID

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Transactions History',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),

        ),
        backgroundColor: const Color(0xffDAA520),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list, color: Colors.black),
            onPressed: () {
              _showFilterDialog(); // Open the filter dialog
            },
          ),
        ],
        automaticallyImplyLeading: false,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: getTransactionsQuery(user).snapshots(),
        builder: (context, snapshot) {
          // Handle loading state
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // Handle error state
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          // Handle no data state
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No transactions found.'));
          }

          // Parse Firestore data into a list
          List<Map<String, dynamic>> transactions = snapshot.data!.docs.map((doc) {
            var data = doc.data() as Map<String, dynamic>;
            return {
              'id': doc.id, // Document ID for editing/deleting
              'category': data['category'],
              'description': data['description'],
              'amount': data['amount'],
              'dateTime': (data['dateTime'] as Timestamp).toDate(), // Convert Timestamp to DateTime
            };
          }).toList();

          // Build the transaction list
          return ListView.builder(
            padding: const EdgeInsets.only(top: 8.0, bottom: 80.0, left: 8.0, right: 8.0),
            itemCount: transactions.length,
            itemBuilder: (context, index) {
              final transaction = transactions[index];
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                child: ClipPath(
                  clipper: RoundedRectClipper(radius: 24.0),
                  child: Slidable(
                    closeOnScroll: true,
                    key: Key(transaction['id']), // Use document ID as unique key
                    endActionPane: ActionPane(
                      motion: const StretchMotion(),
                      children: [
                        CustomSlidableAction(
                          onPressed: (context) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AddExpensePage(
                                  expenseCategory: transaction['category'],
                                  totalAmount: transaction['amount'],
                                  description: transaction['description'],
                                  transactionId: transaction['id'], // Pass ID for editing
                                ),
                              ),
                            );
                          },
                          backgroundColor: const Color(0xffdaa520),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.edit, color: Colors.white, size: 26),
                              SizedBox(height: 4),
                            ],
                          ),
                        ),
                        CustomSlidableAction(
                          onPressed: (context) {
                            deleteTransaction(user, transaction['id']);
                          },
                          backgroundColor: Colors.red,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.delete, color: Colors.white, size: 26),
                              SizedBox(height: 4),
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
                      dateTime: formatDateTime(transaction['dateTime']),
                      //color: getBgCategoryColor(transaction['category']),
                      onTap: () => showDescriptionDialog(
                        context,
                        transaction['category'],
                        transaction['description'],
                        getBgCategoryColor(transaction['category']),
                        getCategoryColor(transaction['category']),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  /// Builds a dynamic Firestore query based on filters
  Query getTransactionsQuery(final user) {
    Query query = FirebaseFirestore.instance
        .collection('users')
        .doc(user.email)
        .collection('transactions');

    // Apply duration filter
    // Apply new time period filter
    DateTime now = DateTime.now();
    DateTime startDate;

    switch (selectedDuration) {
      case 'Day':
        startDate = DateTime(now.year, now.month, now.day);
        break;

      case 'Week':
        final today = DateTime(now.year, now.month, now.day); // Strips time
        int weekday = today.weekday; // Monday = 1, Sunday = 7
        startDate = today.subtract(Duration(days: weekday - 1)); // Go back to Monday
        break;


      case 'Month':
        startDate = DateTime(now.year, now.month, 1);
        break;

      case 'Year':
        startDate = DateTime(now.year, 1, 1);
        break;

      case 'All Time':
      default:
        startDate = DateTime(2000); // A very early default
        break;
    }

    query = query.where('dateTime', isGreaterThanOrEqualTo: Timestamp.fromDate(startDate));


    // Apply category filter
    if (selectedCategories.isNotEmpty) {
      query = query.where('category', whereIn: selectedCategories);
    }

    // Apply sorting
    if (selectedSort == 'Newest') {
      query = query.orderBy('dateTime', descending: true);
    } else if (selectedSort == 'Oldest') {
      query = query.orderBy('dateTime', descending: false);
    } else if (selectedSort == 'Highest') {
      query = query.orderBy('amount', descending: true);
    } else if (selectedSort == 'Lowest') {
      query = query.orderBy('amount', descending: false);
    }

    return query;
  }

  /// Deletes a transaction from Firestore
  void deleteTransaction(final user, String transactionId) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.email)
          .collection('transactions')
          .doc(transactionId)
          .delete();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to delete transaction: $e")),
      );
    }
  }

  /// Shows the filter dialog
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

  /// Formats DateTime for display
  String formatDateTime(DateTime dateTime) {
    return DateFormat('dd MMM @ hh:mm a').format(dateTime);
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
  final VoidCallback onTap;

  const TransactionCard({
    super.key,
    required this.icon,
    required this.category,
    required this.amount,
    required this.dateTime,
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
          color: getBgCategoryColor(category),
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