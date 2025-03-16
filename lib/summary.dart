import 'package:flutter/material.dart';
import './line_chart.dart';
import 'dart:developer';

void main() {
  runApp(const ExpenseSummaryApp());
}

class ExpenseSummaryApp extends StatelessWidget {
  const ExpenseSummaryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const ExpenseSummaryPage(),
    );
  }
}

class ExpenseSummaryPage extends StatefulWidget {
  const ExpenseSummaryPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ExpenseSummaryPageState createState() => _ExpenseSummaryPageState();
}

class _ExpenseSummaryPageState extends State<ExpenseSummaryPage> {
  String selectedChart = "Line Chart"; // ✅ Fixed missing variable

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long),
            label: 'Transaction',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Summary',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        selectedItemColor: Colors.amber,
        unselectedItemColor: Colors.grey,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.amber,
        child: const Icon(Icons.add, size: 30),
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: DropdownButton<String>(
              value: selectedChart,
              onChanged: (String? newValue) {
                setState(() {
                  selectedChart = newValue!;
                });
              },
              items:
                  <String>[
                    "Line Chart",
                    "Pie Chart",
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child:
                selectedChart == "Line Chart"
                    ? SizedBox(
                      width: 1000, // Make it large to allow scrolling
                      child: ExpenseChart(),
                    )
                    : Center(
                      child: Text("Pie Chart Placeholder"),
                    ), // Replace with your pie chart
          ),
          const SizedBox(height: 35),

          Padding(
            padding: const EdgeInsets.only(left: 25, top: 10, bottom: 10),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  Text(
                    "Top Spending",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 130),
                  IconButton(
                    onPressed: () {
                      // Add your sort logic here
                      log('Sort button pressed');
                    },
                    icon: Icon(Icons.sort, size: 26),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 5),
          _buildTopSpendingList(), // ✅ Moved inside class
        ],
      ),
    );
  }

  /// ✅ **Top Spending List**
  Widget _buildTopSpendingList() {
    return Expanded(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildExpenseTile(
            "Housing",
            "Pay Monthly Rent",
            "- RM 1150",
            Colors.red,
            Icons.house,
          ),
          _buildExpenseTile(
            "Utilities",
            "Pay Electricity",
            "- RM 500",
            Colors.purple,
            Icons.receipt,
          ),
          _buildExpenseTile(
            "Food",
            "Buy a ramen",
            "- RM 32",
            Colors.green,
            Icons.food_bank_rounded,
          ),
        ],
      ),
    );
  }

  Widget _buildExpenseTile(
    String title,
    String subtitle,
    String amount,
    MaterialColor color,
    IconData iconData,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          /// **Icon + Title + Subtitle in a Row**
          Row(
            children: [
              Icon(iconData, color: color, size: 40), // Icon on the left
              const SizedBox(width: 12), // Spacing between icon and text
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                ],
              ),
            ],
          ),

          /// **Amount on the right**
          Text(
            amount,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}
