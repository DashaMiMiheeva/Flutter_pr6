import 'package:flutter/material.dart';
import '../models/expense.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ExpenseRow extends StatelessWidget {
  final Expense expense;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const ExpenseRow({
    Key? key,
    required this.expense,
    this.onTap,
    this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dateStr = "${expense.date.day.toString().padLeft(2,'0')}.${expense.date.month.toString().padLeft(2,'0')}.${expense.date.year}";
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        leading: CachedNetworkImage(
          imageUrl: expense.imageUrl,
          width: 40,
          height: 40,
          placeholder: (context, url) => const CircularProgressIndicator(strokeWidth: 2),
          errorWidget: (context, url, error) => const Icon(Icons.broken_image),
        ),
        onTap: onTap,
        title: Text(
          expense.category,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(expense.description ?? dateStr),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('${expense.amount.toStringAsFixed(2)} ₽', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 4),
            Text(dateStr, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
          ],
        ),
      ),
    );
  }
}
