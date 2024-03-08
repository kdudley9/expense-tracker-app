import 'package:flutter/material.dart';
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
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddExpenseForm()),
            );
          },
          child: const Text('Add Expense'),
        ),
      ),
    );
  }
}
