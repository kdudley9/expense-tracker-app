import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../database/expense_db.dart';

class ExpenseHistoryPage extends StatefulWidget {
  const ExpenseHistoryPage({super.key});

  @override
  State<ExpenseHistoryPage> createState() => _ExpenseHistoryPageState();
}

class _ExpenseHistoryPageState extends State<ExpenseHistoryPage> {
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
        title: const Text('Expense History'),
      ),
      body: Column(
        children: [
          _buildMonthSelector(),
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
                  return _buildExpenseList(snapshot.data!);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthSelector() {
    return Container(
      margin: const EdgeInsets.only(left: 18),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          DropdownButton<int>(
            value: _selectedYear,
            items: List.generate(5, (index) => DateTime.now().year - index)
                .map((year) => DropdownMenuItem<int>(
                      value: year,
                      child: Text(year.toString()),
                    ))
                .toList(),
            onChanged: (year) {
              setState(() {
                _selectedYear = year!;
                _expensesFuture = _getExpensesForSelectedMonth();
              });
            },
          ),
          const SizedBox(width: 16),
          DropdownButton<String>(
            value: _selectedMonth,
            items: List.generate(
                    12, (index) => (index + 1).toString().padLeft(2, '0'))
                .map((month) => DropdownMenuItem<String>(
                      value: month,
                      child: Text(DateFormat('MMMM')
                          .format(DateTime.parse('2022-$month-01'))),
                    ))
                .toList(),
            onChanged: (month) {
              setState(() {
                _selectedMonth = month!;
                _expensesFuture = _getExpensesForSelectedMonth();
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildExpenseList(List<Map<String, dynamic>> expenses) {
    return ListView.builder(
      itemCount: expenses.length,
      reverse: true,
      itemBuilder: (context, index) {
        final expense = expenses[index];
        final amount = expense['amount'] as double;
        final formattedAmount = amount.toStringAsFixed(2);
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
