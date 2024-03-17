import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:expense_tracker/models/pie_chart.dart';
import '../database/expense_db.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  String _selectedMonth = DateFormat('MM').format(DateTime.now());
  int _selectedYear = DateTime.now().year;
  late Future<List<Map<String, dynamic>>> _expensesFuture;

  @override
  void initState() {
    super.initState();
    _expensesFuture = _getExpensesForSelectedMonth();
  }

  Future<List<Map<String, dynamic>>> _getExpensesForSelectedMonth() async {
    return ExpenseDB.getExpensesForMonth(_selectedMonth, _selectedYear);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Tracker'),
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: _expensesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.data!.isEmpty) {
                  return const Center(
                      child: Text('No expenses found for selected month'));
                } else {
                return Column(
                  children: [
                    SizedBox(
                      height: 250, // Adjust the height as needed
                      child: MyPieChart(),
                    ),
                     Expanded(child: _buildExpenseList(snapshot.data!)),
                  ],
                );
              }
            },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpenseList(List<Map<String, dynamic>> expenses) {
    return ListView.builder(
      itemCount: expenses.length,
      itemBuilder: (context, index) {
        final expense = expenses[index];
        final amount = expense['amount'] as double; // Cast amount to double
        final formattedAmount =
            amount.toStringAsFixed(2); // Format amount to two decimal places
        return ListTile(
          title: Text(
            expense['title'],
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          subtitle: Text(
            '${expense['category']}',
          ),
          trailing: Text(
            '\$$formattedAmount',
            style: const TextStyle(
              fontSize: 16,
              color: Color.fromRGBO(57, 181, 74, 1),
            ),
          ),
        );
      },
    );
  }



}


