import 'package:flutter/material.dart';

class AddExpenseScreen extends StatefulWidget {
  final void Function({
  required double amount,
  required String category,
  String? description,
  required DateTime date,
  }) onSave;
  final List<String> categories;

  const AddExpenseScreen({
    Key? key,
    required this.onSave,
    required this.categories,
  }) : super(key: key);

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  String? _selectedCategory;
  final _descriptionController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    if (widget.categories.isNotEmpty) {
      _selectedCategory = widget.categories.first;
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365 * 5)),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      final amount = double.parse(_amountController.text.replaceAll(',', '.'));
      final category = _selectedCategory ?? 'Прочее';
      final description = _descriptionController.text.trim().isEmpty ? null : _descriptionController.text.trim();
      widget.onSave(amount: amount, category: category, description: description, date: _selectedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateStr = "${_selectedDate.day.toString().padLeft(2,'0')}.${_selectedDate.month.toString().padLeft(2,'0')}.${_selectedDate.year}";
    return Scaffold(
      appBar: AppBar(title: const Text('Добавить расход')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(labelText: 'Сумма', prefixText: '₽ '),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Введите сумму';
                  final parsed = double.tryParse(v.replaceAll(',', '.'));
                  if (parsed == null || parsed <= 0) return 'Введите корректную сумму > 0';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: const InputDecoration(labelText: 'Категория'),
                items: widget.categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                onChanged: (v) => setState(() => _selectedCategory = v),
                validator: (v) => (v == null || v.isEmpty) ? 'Выберите категорию' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Описание (необязательно)'),
                maxLines: 2,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Text('Дата: $dateStr'),
                  const Spacer(),
                  TextButton(onPressed: _pickDate, child: const Text('Изменить дату')),
                ],
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submit,
                  child: const Text('Сохранить'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
