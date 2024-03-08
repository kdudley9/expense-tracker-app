import 'package:expense_tracker/database/database_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';

class ExpenseDB {
  final tableName = 'expenses';

  Future<void> createTable(Database database) async {
    await database.execute("""CREATE TABLE IF NOT EXISTS $tableName (
      "id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      "title" TEXT NOT NULL,
      "category" TEXT NOT NULL,
      "amount" REAL NOT NULL,
      "createdAt" TEXT NOT NULL
    )
    """);
  }

  static Future<int> createExpense(
      {required String title,
      required String category,
      required double amount}) async {
    final database = await DatabaseService().database;

    final data = {
      'title': title,
      'category': category,
      'amount': amount,
      'createdAt': DateFormat('yyyy-MM-dd').format(DateTime.now())
    };
    return await database.insert('expenses', data,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<List<Map<String, dynamic>>> getExpenses() async {
    final database = await DatabaseService().database;
    return database.query('expenses', orderBy: 'id');
  }

  static Future<List<Map<String, dynamic>>> getExpense(int id) async {
    final database = await DatabaseService().database;
    return database.query('expenses',
        where: 'id = ?', whereArgs: [id], limit: 1);
  }

  static Future<void> delete(int id) async {
    final database = await DatabaseService().database;
    try {
      await database.delete('expenses', where: 'id = ?', whereArgs: [id]);
    } catch (err) {
      debugPrint('$err');
    }
  }
}
