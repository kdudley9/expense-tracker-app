import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../database/expense_db.dart';
import 'add_expense_form.dart';

class CurrentExpensesPage extends StatefulWidget {
  const CurrentExpensesPage({super.key});

  @override
  State<CurrentExpensesPage> createState() => _CurrentExpensesPageState();
}

class _CurrentExpensesPageState extends State<CurrentExpensesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Monthly Expenses'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: ExpenseDB.getExpensesForMonth(
            DateFormat('MM').format(DateTime.now()), DateTime.now().year),
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromRGBO(57, 181, 74, 1),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddExpenseForm()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildExpenseList(List<Map<String, dynamic>> expenses) {
    return ListView.builder(
      itemCount: expenses.length,
      reverse: true,
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
