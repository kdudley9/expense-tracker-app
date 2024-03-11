import 'package:expense_tracker/pages/current_expenses_page.dart';
import 'package:expense_tracker/pages/expense_history_page.dart';
import 'package:expense_tracker/pages/home_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense Tracker',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  final List _pages = [
    const HomePage(),
    const CurrentExpensesPage(),
    const ExpenseHistoryPage(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          labelTextStyle: MaterialStateProperty.resolveWith(
            (states) => states.contains(MaterialState.selected)
                ? const TextStyle(color: Colors.white)
                : const TextStyle(color: Colors.black),
          ),
        ),
        child: NavigationBar(
          selectedIndex: _selectedIndex,
          onDestinationSelected: (int index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          backgroundColor: const Color.fromRGBO(57, 181, 74, 1),
          indicatorColor: Colors.transparent,
          labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
          destinations: const [
            NavigationDestination(
              selectedIcon: Icon(Icons.home, color: Colors.white, size: 30.0),
              icon: Icon(Icons.home_outlined, color: Colors.black, size: 30.0),
              label: 'Home',
            ),
            NavigationDestination(
              selectedIcon:
                  Icon(Icons.payments, color: Colors.white, size: 30.0),
              icon: Icon(Icons.payments_outlined,
                  color: Colors.black, size: 30.0),
              label: 'Expenses',
            ),
            NavigationDestination(
              selectedIcon:
                  Icon(Icons.history, color: Colors.white, size: 30.0),
              icon:
                  Icon(Icons.history_outlined, color: Colors.black, size: 30.0),
              label: 'History',
            ),
          ],
        ),
      ),
    );
  }
}
