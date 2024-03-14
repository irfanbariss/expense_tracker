import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/widgets/expenses_list/expense_item.dart';
import 'package:flutter/material.dart';

class ExpensesList extends StatelessWidget {
  const ExpensesList(
      {super.key, required this.expenses, required this.onRemoveExpense});

  final void Function(Expense expense) onRemoveExpense;
  final List<Expense> expenses;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemBuilder: (ctx, idx) => Dismissible(
              key: ValueKey(expenses[idx]),
              onDismissed: (direction) {
                onRemoveExpense(expenses[idx]);
              },
              background: Container(
                color: Theme.of(context).colorScheme.error.withOpacity(0.75),
                margin: EdgeInsets.symmetric(
                    horizontal: Theme.of(context).cardTheme.margin!.horizontal),
              ),
              child: ExpenseItem(expenses[idx]),
            ),
        itemCount: expenses.length);
  }
}
