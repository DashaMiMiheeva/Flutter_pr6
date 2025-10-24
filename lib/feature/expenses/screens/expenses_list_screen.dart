import 'package:flutter/material.dart';
import '../models/expense.dart';
import '../widgets/expense_row.dart';
import '../widgets/expense_table.dart';

class ExpensesListScreen extends StatelessWidget {
  final List<Expense> expenses;
  final VoidCallback onAddTap;
  final void Function(String id) onDelete;
  final void Function(Expense expense)? onEdit;

  final void Function(DateTime date) onFilter;
  final VoidCallback onClearFilter;
  final DateTime? selectedDate;

  const ExpensesListScreen({
    Key? key,
    required this.expenses,
    required this.onAddTap,
    required this.onDelete,
    this.onEdit,
    required this.onFilter,
    required this.onClearFilter,
    this.selectedDate,
  }) : super(key: key);

  double _sumAll() => expenses.fold(0.0, (s, e) => s + e.amount);

  Future<void> _pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365 * 5)),
      lastDate: DateTime.now(),
    );
    if (picked != null) onFilter(picked);
  }

  @override
  Widget build(BuildContext context) {
    final total = _sumAll();
    final dateLabel = selectedDate != null
        ? 'Фильтр: ${selectedDate!.day.toString().padLeft(2, '0')}.${selectedDate!.month.toString().padLeft(2, '0')}.${selectedDate!.year}'
        : 'Все расходы';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Мои расходы'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_alt),
            tooltip: 'Фильтр по месяцу',
            onPressed: () => _pickDate(context),
          ),
          if (selectedDate != null)
            IconButton(
              icon: const Icon(Icons.clear),
              tooltip: 'Сбросить фильтр',
              onPressed: onClearFilter,
            ),
        ],
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            color: Colors.grey[100],
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    dateLabel,
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ),
                Text(
                  '${total.toStringAsFixed(2)} ₽',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Expanded(
            child: ExpenseTable(
              expenses: expenses,
              onDelete: onDelete,
              onTap: onEdit,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: onAddTap,
        child: const Icon(Icons.add),
      ),
    );
  }
}
