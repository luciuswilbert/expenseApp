import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_app_project/pages/transaction/transaction_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'pie_chart.dart';
import 'bar_chart.dart';
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
        startDate = today.subtract(
          Duration(days: currentWeekday - 1),
        ); // Monday
        endDate = startDate.add(
          const Duration(days: 7),
        ); // Next Monday (exclusive)
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
      return ['Day', 'Week', 'Month', 'Year', 'All'];
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
    'Subscription': getCategoryColor('Subscription'),
    'Groceries': getCategoryColor('Groceries'),
    'Shopping': getCategoryColor('Shopping'),
    'Healthcare': getCategoryColor('Healthcare'),
    'Transportation': getCategoryColor('Transportation'),
    'Miscellaneous': getCategoryColor('Miscellaneous'),
  };

  List<Map<String, dynamic>> generateBarChartData(
    List<Map<String, dynamic>> transactions,
    double monthlyBudget,
  ) {
    Map<String, double> barData = {};

    // Step 1: Group transactions based on selected time period
    for (var txn in transactions) {
      DateTime date = txn['dateTime'];
      String key;

      switch (selectedTimePeriod) {
        case 'Day':
          final hour = date.hour;
          if (hour >= 0 && hour < 6) {
            key = '00–06';
          } else if (hour >= 6 && hour < 12) {
            key = '06–12';
          } else if (hour >= 12 && hour < 18) {
            key = '12–18';
          } else {
            key = '18–24';
          }
          break;
        case 'Week':
          key = DateFormat('EEE').format(date); // e.g., "Mon", "Tue"
          break;
        case 'Month':
          key = DateFormat('MMM').format(date); // ✅ e.g. "Jan"
          break;
        case 'Year':
          key = date.year.toString(); // e.g., "Jan", "Feb"
          break;
        default:
          key = 'Unknown';
      }

      final amount = (txn['amount'] as num).toDouble();
      barData[key] = (barData[key] ?? 0) + amount;
    }

    // Step 2: Define labels in order based on time period
    List<String> labels;
    switch (selectedTimePeriod) {
      case 'Day':
        labels = ['00–06', '06–12', '12–18', '18–24'];
        break;
      case 'Week':
        labels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
        break;
      case 'Month':
        labels = [
          'Jan',
          'Feb',
          'Mar',
          'Apr',
          'May',
          'Jun',
          'Jul',
          'Aug',
          'Sep',
          'Oct',
          'Nov',
          'Dec',
        ];
        break;
      case 'Year':
        final years =
            transactions
                .map((txn) => txn['dateTime'].year.toString())
                .toSet()
                .toList()
              ..sort();
        labels = years;
        break;
      default:
        labels = [];
    }

    // Step 3: Calculate expected (ideal) amount per slot
    double expectedPerSlot = 0;
    switch (selectedTimePeriod) {
      case 'Day':
        expectedPerSlot = monthlyBudget / 30 / 24; // 30 days * 24 hours
        break;
      case 'Week':
        expectedPerSlot = monthlyBudget / 4 / 7; // 4 weeks * 7 days
        break;
      case 'Month':
        int daysInMonth =
            DateTime(DateTime.now().year, DateTime.now().month + 1, 0).day;
        expectedPerSlot = monthlyBudget / daysInMonth;
        break;
      case 'Year':
        expectedPerSlot = monthlyBudget / 12;
        break;
      default:
        expectedPerSlot = 0;
    }

    // Step 4: Return data for the chart
    return labels.map((label) {
      return {
        'label': label,
        'total': barData[label] ?? 0,
        'expected': expectedPerSlot,
      };
    }).toList();
  }

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
          List<Map<String, dynamic>> transactions =
              snapshot.data!.docs.map((doc) {
                // Create categoryData from the fetched transactions
                var data = doc.data() as Map<String, dynamic>;
                return {
                  'id': doc.id, // Document ID for editing/deleting
                  'category': data['category'],
                  'description': data['description'],
                  'amount': data['amount'],
                  'dateTime':
                      (data['dateTime'] as Timestamp)
                          .toDate(), // Convert Timestamp to DateTim
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

          // 🔁 Loop through to fill category totals
          for (var txn in transactions) {
            String category = txn['category'];
            double amount = txn['amount'];
            categoryData[category] = (categoryData[category] ?? 0) + amount;
          }

          // ✅ Get budget dynamically from Firestore
          return FutureBuilder<DocumentSnapshot>(
            future:
                FirebaseFirestore.instance
                    .collection('users')
                    .doc(user?.email)
                    .get(),
            builder: (context, userSnapshot) {
              if (userSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (userSnapshot.hasError || !userSnapshot.hasData) {
                return const Center(child: Text('Error loading user data'));
              }

              // ✅ Extract budget
              final userData =
                  userSnapshot.data!.data() as Map<String, dynamic>;
              final monthlyBudget =
                  double.tryParse(userData['budget'].toString()) ?? 0.0;

              // ✅ Generate chart data using budget
              final barChartData = generateBarChartData(
                transactions,
                monthlyBudget,
              );

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
                      isSelected:
                          timePeriods
                              .map((period) => period == selectedTimePeriod)
                              .toList(),
                      onPressed: (index) {
                        setState(() {
                          selectedTimePeriod = timePeriods[index];
                          // TODO: Fetch data based on selectedTimePeriod
                        });
                      },
                      borderRadius: BorderRadius.circular(8),
                      selectedColor: Colors.black,
                      fillColor: Color(0xffdda520),
                      children:
                          timePeriods
                              .map(
                                (period) => Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  child: Text(period),
                                ),
                              )
                              .toList(),
                    ),
                    const SizedBox(height: 16),
                    Align(
                      alignment: Alignment.centerRight,
                      // Chart type dropdown
                      child: DropdownButton<String>(
                        dropdownColor: Colors.white,
                        value: selectedChartType,
                        items:
                            ['Pie Chart', 'Bar Chart']
                                .map(
                                  (type) => DropdownMenuItem(
                                    value: type,
                                    child: Text(type),
                                  ),
                                )
                                .toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedChartType = value!;
                            // Reset percentage toggle when switching charts
                            if (selectedChartType == 'Pie Chart') {}
                            if (selectedChartType == 'Line Chart')
                              showPercentages = false;
                          });
                        },
                        focusColor: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Chart display
                    if (selectedChartType == 'Pie Chart') ...[
                      SizedBox(
                        height: 200,
                        child: PieChartWidget(
                          data: categoryData,
                          colors: categoryColors,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.percent,
                              color:
                                  showPercentages
                                      ? Color(0xffdaa520)
                                      : Colors.grey,
                            ),
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
                        child: BarChartWidget(data: barChartData),
                      ),
                    const SizedBox(height: 16),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        selectedChartType == 'Pie Chart'
                            ? 'Categories'
                            : 'Top Spending',
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
          );
        },
      ),
    );
  }
}
