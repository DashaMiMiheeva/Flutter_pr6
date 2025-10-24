import 'package:flutter/material.dart';
import 'package:test_flutter/feature/expenses/screens/add_expense_screen.dart';
import 'package:test_flutter/feature/expenses/screens/expenses_list_screen.dart';
import 'models/expense.dart';

enum _Screen { list, add }

class ExpensesContainer extends StatefulWidget {
  const ExpensesContainer({Key? key}) : super(key: key);

  @override
  State<ExpensesContainer> createState() => _ExpensesContainerState();
}

class _ExpensesContainerState extends State<ExpensesContainer> {
  _Screen _current = _Screen.list;
  final List<Expense> _expenses = [];
  Expense? _recentlyDeleted;
  int? _recentlyDeletedIndex;

  final List<String> _categories = ['Еда', 'Транспорт', 'Покупки', 'Развлечения', 'Прочее'];

  DateTime? _selectedDate; // null = все расходы

  void _showAdd() => setState(() => _current = _Screen.add);
  void _showList() => setState(() => _current = _Screen.list);

  void _setFilterDate(DateTime date) {
    setState(() => _selectedDate = date);
  }

  void _clearFilter() {
    setState(() => _selectedDate = null);
  }

  List<Expense> get _filteredExpenses {
    if (_selectedDate == null) return _expenses;

    return _expenses.where((e) {
      final sameDay = e.date.year == _selectedDate!.year &&
          e.date.month == _selectedDate!.month &&
          e.date.day == _selectedDate!.day;
      return sameDay;
    }).toList();
  }

  void _createExpense({
    required double amount,
    required String category,
    String? description,
    required DateTime date,
  }) {
    final newExpense = Expense(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      amount: amount,
      category: category,
      description: description,
      date: date,
    );
    setState(() {
      _expenses.insert(0, newExpense);
      _current = _Screen.list;
    });
  }

  void _deleteExpense(String id) {
    final index = _expenses.indexWhere((e) => e.id == id);
    if (index == -1) return;
    setState(() {
      _recentlyDeleted = _expenses.removeAt(index);
      _recentlyDeletedIndex = index;
    });
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Расход удалён'),
        action: SnackBarAction(
          label: 'Отменить',
          onPressed: () {
            if (_recentlyDeleted != null && _recentlyDeletedIndex != null) {
              setState(() {
                _expenses.insert(_recentlyDeletedIndex!, _recentlyDeleted!);
                _recentlyDeleted = null;
                _recentlyDeletedIndex = null;
              });
            }
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget child;
    switch (_current) {
      case _Screen.list:
        child = ExpensesListScreen(
          expenses: List.unmodifiable(_filteredExpenses),
          onAddTap: _showAdd,
          onDelete: _deleteExpense,
          onEdit: null,
          onFilter: _setFilterDate,
          onClearFilter: _clearFilter,
          selectedDate: _selectedDate,
        );
        break;
      case _Screen.add:
        child = AddExpenseScreen(
          categories: _categories,
          onSave: ({required amount, required category, description, required date}) {
            _createExpense(amount: amount, category: category, description: description, date: date);
          },
        );
        break;
    }

    return AnimatedSwitcher(duration: const Duration(milliseconds: 200), child: child);
  }
}
