import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class ExpenseChart extends StatefulWidget {
  const ExpenseChart({super.key});

  @override
  State<ExpenseChart> createState() => ExpenseChartState();
}

class ExpenseChartState extends State<ExpenseChart> {
  List<Color> gradientColors = [
    const Color(0xFFDAA520), // Gold
    const Color.fromARGB(255, 239, 230, 207), // Soft gold
  ];

  int selectedTabIndex = 2; // Default to Month
  int selectedMonthIndex = 0; // This index corresponds to JAN=0, FEB=1, etc.
  final List<String> tabs = ['Day', 'Week', 'Month', 'Year'];

  // Add empty strings at the beginning and end for margins.
  final List<String> months = [
    'JAN',
    'FEB',
    'MAR',
    'APR',
    'MAY',
    'JUN',
    'JUL',
    'AUG',
    'SEP',
    'OCT',
    'NOV',
    'DEC',
  ];

  final List<double> expenses = [
    100,
    200,
    150,
    300,
    250,
    400,
    350,
    500,
    450,
    600,
    700,
    100,
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildTimeTabs(),
        const SizedBox(height: 20),
        if (selectedTabIndex == 2) // Show chart only for Month
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                height: 300,
                width: MediaQuery.of(context).size.width * 0.9,
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(color: Colors.transparent),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    // Set the width larger than the window so that you can scroll.
                    width: 1200,
                    child: LineChart(mainData()),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildTimeTabs() {
    return SizedBox(
      height: 50,
      child: Padding(
        padding: const EdgeInsets.only(left: 20), // Add left margin here
        child: SizedBox(
          height: 50,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: tabs.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedTabIndex = index;
                  });
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color:
                        selectedTabIndex == index
                            ? Colors.amber.withValues(alpha: 0.4)
                            : Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      tabs[index],
                      style: TextStyle(
                        color:
                            selectedTabIndex == index
                                ? Colors.amber.shade800
                                : Colors.grey,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  LineChartData mainData() {
    final spots = List.generate(
      expenses.length,
      (index) => FlSpot(index.toDouble(), expenses[index]),
    );

    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        horizontalInterval: 200,
        getDrawingHorizontalLine:
            (value) => FlLine(
              color: Colors.grey.withValues(alpha: 0.1),
              strokeWidth: 1,
            ),
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 40,
            interval: 1,
            getTitlesWidget: (value, meta) {
              final index = value.toInt();
              if (index < 0 || index >= months.length) return Container();

              EdgeInsets padding = EdgeInsets.zero;
              if (index == 0) {
                padding = const EdgeInsets.only(left: 16, top: 8);
              } else if (index == months.length - 1) {
                padding = const EdgeInsets.only(right: 16, top: 8);
              } else {
                padding = const EdgeInsets.only(top: 8);
              }

              return Padding(
                padding: padding,
                child: Text(
                  months[index],
                  style: TextStyle(
                    color:
                        index == selectedMonthIndex
                            ? Colors.amber
                            : Colors.grey,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              );
            },
          ),
        ),
        leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      ),
      borderData: FlBorderData(show: false),
      // Add viewport padding instead of data padding
      minX: -1,
      maxX: 12,
      minY: 0,
      maxY: 800,
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          getTooltipItems: (touchedSpots) {
            return touchedSpots.map((spot) {
              return LineTooltipItem(
                '${spot.y.toInt()}',
                TextStyle(
                  color: Colors.amber.shade800,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              );
            }).toList();
          },
        ),
        touchCallback: (FlTouchEvent event, LineTouchResponse? response) {
          if (event is FlTapUpEvent && response != null) {
            final index = response.lineBarSpots?.first.spotIndex;
            if (index != null && index < months.length) {
              setState(() => selectedMonthIndex = index);
            }
          }
        },
        handleBuiltInTouches: true,
      ),
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: true,
          gradient: LinearGradient(colors: gradientColors),
          barWidth: 2.5,
          isStrokeCapRound: true,
          dotData: const FlDotData(show: false),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors:
                  gradientColors
                      .map((color) => color.withValues(alpha: 0.1))
                      .toList(),
            ),
          ),
        ),
      ],
    );
  }
}
