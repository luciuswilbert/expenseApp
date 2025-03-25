import 'package:expense_app_project/utils/transaction_helpers.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:expense_app_project/pages/transaction/transaction_page.dart';
import 'package:expense_app_project/data/transaction_data.dart'; // ✅ Import transaction data


class BarChartWidget extends StatelessWidget {
  final List<Map<String, dynamic>> data;
  final double barWidthFactor = 50.0; // Adjust this value to control spacing

  const BarChartWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200, // Fixed height; adjust as needed
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Padding(
          padding: const EdgeInsets.all(1),
          child: SizedBox(
            width: data.length * barWidthFactor, // Dynamic width based on number of bars
            child: BarChart(
              BarChartData(
                barTouchData: BarTouchData(
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipColor: (_) => const Color.fromARGB(255, 115, 139, 96),
                    tooltipHorizontalAlignment: FLHorizontalAlignment.right,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      String month = data[group.x]['month'];
                      return BarTooltipItem(
                        '$month\n',
                        const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: rod.toY.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (double value, TitleMeta meta) {
                        int index = value.toInt();
                        if (index >= 0 && index < data.length) {
                          return SideTitleWidget(
                            meta: meta,
                            //axisSide: meta.axisSide, // Fixed parameter name
                            space: 16,
                            child: Text(
                              data[index]['month'].substring(0, 3),
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          );
                        }
                        return const Text('');
                      },
                      reservedSize: 38,
                    ),
                  ),
                  leftTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(show: false),
                gridData: const FlGridData(show: false),
                backgroundColor: const Color.fromARGB(0, 255, 235, 59),
                barGroups: List.generate(data.length, (i) {
                  return BarChartGroupData(
                    x: i,
                    barRods: [
                      BarChartRodData(
                        toY: data[i]['total'].toDouble() / 1100,
                        color: data[i]['total'].toDouble() < 1100
                            ? const Color(0xFFDDA520)
                            : const Color.fromARGB(255, 221, 32, 32),
                        width: 15,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(8),
                          bottom: Radius.circular(8),
                        ),
                        backDrawRodData: BackgroundBarChartRodData(
                          show: true,
                          toY: 1,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }
}






// Transaction List Widget
class TransactionListWidget extends StatelessWidget {
  //final TransactionPage transactionPage; // Add this line

  final List<Map<String, dynamic>> transactions;
  const TransactionListWidget({super.key, required this.transactions});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        padding: const EdgeInsets.only(top: 10),
        itemCount: 3, // ✅ Uses transaction data
        itemBuilder: (context, index) {
          final transaction = transactions[index];
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10), 
            child: ClipPath(
              clipper: RoundedRectClipper(radius: 24.0), // Match your card’s radius
              child: TransactionCard(
              icon: Icon(
                getCategoryIcon(transaction['category']), // ✅ Assign icon dynamically
                color: getCategoryColor(transaction['category']), // ✅ Assign color dynamically
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
                getCategoryColor(transaction['category']), // ✅ Fetch dynamic icon color
              ),
            ),
          ),);
        },
      );
  }
}