import 'package:flutter/material.dart';
import 'feature/expenses/expenses_container.dart';

void main() {
  runApp(const ExpensesApp());
}

class ExpensesApp extends StatelessWidget {
  const ExpensesApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Учёт расходов',
      theme: ThemeData(
        primaryColor: const Color(0xFFFFC1CC),
        scaffoldBackgroundColor: const Color(0xFFFFF0F5),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFFFC1CC),
          foregroundColor: Colors.white,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFFFFC1CC),
          foregroundColor: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFFC1CC),
            foregroundColor: Colors.white,
            textStyle: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        colorScheme: const ColorScheme.light(
          primary: Color(0xFFFFC1CC),
          secondary: Color(0xFFFFE4E9),
        ),
        useMaterial3: false,
      ),
      home: const ExpensesContainer(),
    );
  }
}
