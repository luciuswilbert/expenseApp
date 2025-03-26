import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_app_project/pages/transaction/transaction_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
 import 'package:flutter/material.dart';
 import 'pie_chart.dart';
 import 'line_chart.dart';
 import 'package:expense_app_project/utils/transaction_helpers.dart';
 
 class SummaryPage extends StatefulWidget {
   const SummaryPage({super.key});
 
   @override
   _SummaryPageState createState() => _SummaryPageState();
 }
 
 class _SummaryPageState extends State<SummaryPage> {
   String selectedTimePeriod = 'Month';
   String selectedChartType = 'Pie Chart';
   bool showPercentages = false;
 
   // Time period options
   final List<String> timePeriods = ['Day', 'Week', 'Month', 'Year'];
  
   /// Builds a dynamic Firestore query based on filters
  Query getTransactionsQuery(final user) {
    Query query = FirebaseFirestore.instance
        .collection('users')
        .doc(user.email)
        .collection('transactions');

    query = query.orderBy('amount', descending: true).limit(3);
    // Add more sorting options as needed

    return query;
  }
   // Dummy data (replace with your actual data source)
   final Map<String, double> categoryData = {
     'Housing': 120,
     'Utilities': 80,
     'Food': 32,
     'Subscription':32,
     'Groceries': 300,
     'Shopping' : 100,
     'Healthcare' : 30,
     'Transportation' : 50,
     'Miscellaneous': 140
   };
 
   final Map<String, Color> categoryColors = {
     'Housing': getCategoryColor('Housing'),
     'Utilities': getCategoryColor('Utilities'),
     'Food': getCategoryColor('Food'),
     'Subscription':getCategoryColor('Subscription'),
     'Groceries':getCategoryColor('Groceries'),
     'Shopping':getCategoryColor('Shopping'),
     'Healthcare':getCategoryColor('Healthcare'),
     'Transportation':getCategoryColor('Transportation'),
     'Miscellaneous':getCategoryColor('Miscellaneous'),
   };
 
   final List<Map<String, dynamic>> timeSeriesData = [
     {'month': 'Jan', 'total': 1000.0},
     {'month': 'Feb', 'total': 1000.0},
     {'month': 'Mar', 'total': 1000.0},
     {'month': 'Apr', 'total': 1100.0},
     {'month': 'May', 'total': 1230.0},
     {'month': 'Jun', 'total': 1150.0},
     {'month': 'Jul', 'total': 1050.0},
     {'month': 'Aug', 'total': 900.0},
     {'month': 'Sep', 'total': 850.0},
     {'month': 'Oct', 'total': 1000.0},
     {'month': 'Nov', 'total': 1000.0},
     {'month': 'Dec', 'total': 1000.0},
    
   ];
 
   /*final List<Map<String, dynamic>> topTransactions = [{
     'category': 'Groceries',
     'description': 'Buy some grocery items from the supermarket',
     'amount': 120.00,
     'dateTime': '28 Feb @ 10:00 AM',
     'color': const Color(0xFFFCEED4), // Background color of the card
   },
   {
     'category': 'Subscription',
     'description': 'Disney+ Annual subscription renewal',
     'amount': 80.00,
     'dateTime': '28 Feb @ 03:30 PM',
     'color': const Color(0xFFEADDCB), // Light beige
   },
   {
     'category': 'Food',
     'description': 'Buy a ramen from the local restaurant',
     'amount': 32.00,
     'dateTime': '28 Feb @ 07:30 PM',
     'color': const Color(0xFFE1DEBC), // Light green
   },
   ];
 */
   @override
   Widget build(BuildContext context) {
      final user = FirebaseAuth.instance.currentUser; 
     return Scaffold(
       backgroundColor: Colors.white,
       appBar: AppBar(
         title: const Text('Summary'),
         centerTitle: true,
         backgroundColor: Colors.white,
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
              'dateTime': (data['dateTime'] as Timestamp).toDate(), // Convert Timestamp to DateTim
            };
          }).toList();
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            //crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Time period selection
              ToggleButtons(
                isSelected: timePeriods.map((period) => period == selectedTimePeriod).toList(),
                onPressed: (index) {
                  setState(() {
                    selectedTimePeriod = timePeriods[index];
                    // TODO: Fetch data based on selectedTimePeriod
                  });
                },
                borderRadius: BorderRadius.circular(8),
                selectedColor: Colors.black,
                fillColor: Color(0xffdda520),
                children: timePeriods.map((period) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(period),
                )).toList(),
              ),
              const SizedBox(height: 16),
              Align(
              alignment: Alignment.centerRight,
              // Chart type dropdown
              child: DropdownButton<String>(
                dropdownColor: Colors.white,
                value: selectedChartType,
                items: ['Pie Chart', 'Line Chart']
                    .map((type) => DropdownMenuItem(value: type, child: Text(type)))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedChartType = value!;
                    // Reset percentage toggle when switching charts
                    if (selectedChartType == 'Line Chart') showPercentages = false;
                  });
                },
                focusColor: Colors.white,
              )),
              const SizedBox(height: 16),
              // Chart display
              if (selectedChartType == 'Pie Chart') ...[
                SizedBox(
                  height: 200,
                  child: PieChartWidget(data: categoryData, colors: categoryColors),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    
                    IconButton(
                      icon: Icon(Icons.percent, color: showPercentages ? Color(0xffdaa520) : Colors.grey),
                      onPressed: () {
                        setState(() {
                          showPercentages = !showPercentages;
                        });
                      },
                    ),
                  ],
                ),
              ] else
                SizedBox(
                  height: 200,
                  child: BarChartWidget(data: timeSeriesData),
                ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Top Spending',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(255, 0, 0, 0),
                  ),
                ),
              ),
              // Dynamic bottom section
              if (selectedChartType == 'Pie Chart')
                CategoryListWidget(
                  categories: categoryData,
                  colors: categoryColors,
                  showPercentages: showPercentages,
                )
              else
                  TransactionListWidget(transactions: transactions),
  
            ],
          ),
        );
        },
      ),
    );
   }
 }