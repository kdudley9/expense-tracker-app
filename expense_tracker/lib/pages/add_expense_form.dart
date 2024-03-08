import 'package:expense_tracker/database/expense_db.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddExpenseForm extends StatefulWidget {
  const AddExpenseForm({super.key});

  @override
  State<AddExpenseForm> createState() => _AddExpenseFormState();
}

class _AddExpenseFormState extends State<AddExpenseForm> {
  final _formKey = GlobalKey<FormState>();
  List<String> categories = [
    'Food & Dining',
    'Transportation',
    'Housing',
    'Utilities',
    'Entertainment',
    'Health & Fitness',
    'Shopping',
    'Personal Care',
    'Education',
    'Miscellaneous'
  ];
  String? selectedCategory;
  List<Map<String, dynamic>> _currentExpenses = [];

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  void _refreshCurrentExpenses() async {
    final data = await ExpenseDB.getExpenses();
    setState(() {
      _currentExpenses = data;
      print('CURRENT EXPENSES /////// $_currentExpenses ///////');
    });
  }

  @override
  void initState() {
    super.initState;
    _refreshCurrentExpenses();
  }

  Future<void> _addExpense() async {
    await ExpenseDB.createExpense(
        title: _titleController.text,
        category: _categoryController.text,
        amount: double.parse(_amountController.text));
    _refreshCurrentExpenses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add an Expense'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 50,
                ),
                TextFormField(
                  controller: _titleController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter expense name';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter expense name',
                    labelText: 'Name',
                    prefixIcon: Icon(
                      Icons.sell,
                      color: Color.fromRGBO(57, 181, 74, 1),
                    ),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                DropdownButtonFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a category';
                    }
                    return null;
                  },
                  hint: const Text('Select category'),
                  value: selectedCategory,
                  icon: const Icon(Icons.keyboard_arrow_down),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Category',
                    prefixIcon: Icon(
                      Icons.inventory,
                      color: Color.fromRGBO(57, 181, 74, 1),
                    ),
                  ),
                  items: categories.map((String items) {
                    return DropdownMenuItem(
                      value: items,
                      child: Text(items),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedCategory = newValue!;
                      _categoryController.text = newValue;
                    });
                  },
                ),
                const SizedBox(
                  height: 50,
                ),
                TextFormField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                        RegExp(r'^\d+\.?\d{0,2}')),
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter dollar amount';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(
                      Icons.attach_money,
                      color: Color.fromRGBO(57, 181, 74, 1),
                    ),
                    hintText: 'Enter dollar amount',
                    labelText: 'Amount',
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        const Color.fromRGBO(57, 181, 74, 1)),
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                  ),
                  child: const Text('Add'),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _addExpense();
                      _titleController.text = '';
                      _categoryController.text = '';
                      Navigator.of(context).pop();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
