class Expense {
  final String id;
  final double amount;
  final String category;
  final String? description;
  final DateTime date;

  Expense({
    required this.id,
    required this.amount,
    required this.category,
    this.description,
    required this.date,
  });

  Expense copyWith({
    String? id,
    double? amount,
    String? category,
    String? description,
    DateTime? date,
  }) {
    return Expense(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      description: description ?? this.description,
      date: date ?? this.date,
    );
  }
}
