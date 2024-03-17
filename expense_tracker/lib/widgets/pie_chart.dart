import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:expense_tracker/database/expense_db.dart';
import 'package:intl/intl.dart';

class MyPieChart extends StatelessWidget {
  const MyPieChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.all(40.0), // Add padding of 15 around the pie chart
      child: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchExpenseData(), // Call a method to fetch expense data
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator(); // Show loading indicator while data is being fetched
          } else {
            if (snapshot.hasError) {
              return Text(
                  'Error: ${snapshot.error}'); // Show error if data fetching fails
            } else {
              return PieChart(
                PieChartData(
                  sections: buildPieChartSections(snapshot.data!),
                  centerSpaceRadius: 50.0,
                ),
              );
            }
          }
        },
      ),
    );
  }

  Future<List<Map<String, dynamic>>> fetchExpenseData() async {
    return ExpenseDB.getExpensesForMonth(
        DateFormat('MM').format(DateTime.now()), DateTime.now().year);
  }

  List<PieChartSectionData> buildPieChartSections(
      List<Map<String, dynamic>> expenses) {
    double totalAmount = 0;
    expenses.forEach((expense) {
      totalAmount += expense['amount'];
    });

    // Calculate the percentage contribution of each category to the total amount
    Map<String, double> categoryPercentage = {};
    expenses.forEach((expense) {
      String category = expense['category'];
      double amount = expense['amount'];
      double percentage = (amount / totalAmount) * 100;
      if (categoryPercentage.containsKey(category)) {
        categoryPercentage[category] =
            (categoryPercentage[category] ?? 0) + percentage;
      } else {
        categoryPercentage[category] = percentage;
      }
    });

    List<Color> colors = [
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.yellow,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.pink,
      Colors.indigo,
      Colors.cyan
    ];

    List<PieChartSectionData> sections = [];
    int index = 0;
    categoryPercentage.forEach((category, percentage) {
      sections.add(
        PieChartSectionData(
          value: percentage,
          title: '$category\n${percentage.toStringAsFixed(2)}%',
          titleStyle:
              const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          showTitle: true,
          titlePositionPercentageOffset: 1.3,
          radius: 70,
          color: colors[index % colors.length],
        ),
      );
      index++;
    });
    return sections;
  }
}
