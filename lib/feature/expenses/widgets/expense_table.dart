import 'package:flutter/material.dart';
import '../models/expense.dart';
import 'expense_row.dart';

class ExpenseTable extends StatelessWidget {
  final List<Expense> expenses;
  final void Function(String id) onDelete;
  final void Function(Expense expense)? onTap;

  const ExpenseTable({
    Key? key,
    required this.expenses,
    required this.onDelete,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (expenses.isEmpty) {
      return const Center(
        child: Text(
          'Нет расходов для отображения',
          style: TextStyle(fontSize: 16),
        ),
      );
    }

    return ListView.builder(
      itemCount: expenses.length,
      itemBuilder: (context, index) {
        final e = expenses[index];
        return Dismissible(
          key: ValueKey(e.id),
          direction: DismissDirection.endToStart,
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          onDismissed: (_) => onDelete(e.id),
          child: ExpenseRow(
            expense: e,
            onTap: onTap != null ? () => onTap!(e) : null,
          ),
        );
      },
    );
  }
}
