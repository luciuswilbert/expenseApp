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
 
  /// Returns the start and end date range for the selected time period
  Map<String, DateTime> getDateRangeForSelectedPeriod() {
    final now = DateTime.now();
    late DateTime startDate;
    late DateTime endDate;

    switch (selectedTimePeriod) {
      case 'Day':
        startDate = DateTime(now.year, now.month, now.day);
        endDate = startDate.add(const Duration(days: 1));
        break;

      case 'Week':
        // Ensure Monday is always the start of the week
        final today = DateTime(now.year, now.month, now.day);
        final int currentWeekday = today.weekday; // Monday = 1, Sunday = 7
        startDate = today.subtract(Duration(days: currentWeekday - 1)); // Monday
        endDate = startDate.add(const Duration(days: 7)); // Next Monday (exclusive)
        break;


      case 'Month':
        startDate = DateTime(now.year, now.month, 1);
        endDate = DateTime(now.year, now.month + 1, 1);
        break;

      case 'Year':
        startDate = DateTime(now.year, 1, 1);
        endDate = DateTime(now.year + 1, 1, 1);
        break;

      case 'All Time':
      default:
        startDate = DateTime(2000); // A very early default
        endDate = now.add(const Duration(days: 1)); // Include today's data
        break;
    }

    return {'start': startDate, 'end': endDate};
  }


  // Time period options
  List<String> get timePeriods {
    if (selectedChartType == 'Pie Chart') {
      return ['Day', 'Week', 'Month', 'Year', 'All Time'];
    }
    return ['Day', 'Week', 'Month', 'Year'];
  }

  
   /// Builds a dynamic Firestore query based on filters
  Query getTransactionsQuery(final user) {
    final range = getDateRangeForSelectedPeriod();
    final start = range['start']!;
    final end = range['end']!;

    Query query = FirebaseFirestore.instance
        .collection('users')
        .doc(user.email)
        .collection('transactions')
        .where('dateTime', isGreaterThanOrEqualTo: start)
        .where('dateTime', isLessThan: end)
        .orderBy('dateTime', descending: true);

    return query;
  }

 
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

            // Create categoryData from the fetched transactions
            var data = doc.data() as Map<String, dynamic>;
            return {
              'id': doc.id, // Document ID for editing/deleting
              'category': data['category'],
              'description': data['description'],
              'amount': data['amount'],
              'dateTime': (data['dateTime'] as Timestamp).toDate(), // Convert Timestamp to DateTim
            };
          }).toList();

          // Group the transactions by category and calculate the total for each
          Map<String, double> categoryData = {
            'Housing': 0,
            'Utilities': 0,
            'Food': 0,
            'Subscription': 0,
            'Groceries': 0,
            'Shopping': 0,
            'Healthcare': 0,
            'Transportation': 0,
            'Miscellaneous': 0,
          };

          for (var txn in transactions) {
            String category = txn['category'];
            double amount = txn['amount'];

            categoryData[category] = (categoryData[category] ?? 0) + amount;
          }

        final sortedCategoryData = Map.fromEntries(
          categoryData.entries.toList()
            ..sort((a, b) => b.value.compareTo(a.value)),
        );


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
                    if (selectedChartType == 'Pie Chart') {}
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
                  selectedChartType == 'Pie Chart' ? 'Categories' : 'Top Spending',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 0, 0, 0),
                  ),
                ),
              ),

              // Dynamic bottom section
              if (selectedChartType == 'Pie Chart')
                CategoryListWidget(
                  categories: sortedCategoryData,
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