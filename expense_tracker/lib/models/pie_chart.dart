import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:expense_tracker/database/expense_db.dart';

class MyPieChart extends StatelessWidget {
  const MyPieChart({Key? key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(40.0), // Add padding of 15 around the pie chart
      child: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchExpenseData(), // Call a method to fetch expense data
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator(); // Show loading indicator while data is being fetched
          } else {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}'); // Show error if data fetching fails
            } else {
              return PieChart(
                PieChartData(
                  sections: buildPieChartSections(snapshot.data!), // Build pie chart sections using fetched data
                ),
              );
            }
          }
        },
      ),
    );
  }

  Future<List<Map<String, dynamic>>> fetchExpenseData() async {
    // Fetch expenses data from database
    return ExpenseDB.getExpenses();
  }

  List<PieChartSectionData> buildPieChartSections(List<Map<String, dynamic>> expenses) {
    // Calculate total amount of all expenses
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
        categoryPercentage[category] = (categoryPercentage[category] ?? 0) + percentage;
      } else {
        categoryPercentage[category] = percentage;
      }
    });

    // Build pie chart sections
    List<PieChartSectionData> sections = [];
    categoryPercentage.forEach((category, percentage) {
      sections.add(
        PieChartSectionData(
          value: percentage,
          title: '$category\n${percentage.toStringAsFixed(2)}%', // Display category and its percentage contribution
          showTitle: true,
          titlePositionPercentageOffset: 1.2, // Position title outside of the pie chart
          radius: 70,
          color: const Color(0xFF2B362D),
        ),
      );
    });
    return sections;
  }
}
