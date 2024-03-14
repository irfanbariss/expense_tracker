import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
import 'package:expense_tracker/models/expense.dart';

class NewExpense extends StatefulWidget {
  const NewExpense({super.key, required this.onAddExpense});

  final void Function(Expense expense) onAddExpense;

  @override
  State<StatefulWidget> createState() {
    return _NewExpenseState();
  }
}

class _NewExpenseState extends State<NewExpense> {
  // var _enteredTitle;
  // void _saveTitleInput(String inputValue) {
  //   _enteredTitle = inputValue;
  // }

  String capitalize(String str) =>
      str[0].toUpperCase() + str.substring(1).toLowerCase();

  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedDate;
  Category _selectedCategory = Category.leisure;

  void _presentDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: firstDate,
      lastDate: now,
    );
    setState(() {
      _selectedDate = pickedDate;
    });
  }

  void _showDialog() {
    if (Platform.isIOS) {
      showCupertinoDialog(
        context: context,
        builder: (ctx) => CupertinoAlertDialog(
          title: const Text("Invalid Input!"),
          content: const Text(
              "Please make sure you filled all the fields correctly."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: const Text('Okay'),
            )
          ],
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text("Invalid Input!"),
          content: const Text(
              "Please make sure you filled all the fields correctly."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: const Text('Okay'),
            )
          ],
        ),
      );
    }
  }

// validating expense form

  void _submitExpenseData() {
    final enteredAmount =
        double.tryParse(_amountController.text); // ex. '200' => 200
    final amountIsInvalid = enteredAmount == null || enteredAmount <= 0;
    if (_titleController.text.trim().isEmpty ||
        amountIsInvalid ||
        _selectedDate == null) {
      _showDialog();

      return;
    }
    // save new expense
    widget.onAddExpense(
      Expense(
          title: capitalize(_titleController.text),
          amount: enteredAmount,
          date: _selectedDate!,
          category: _selectedCategory),
    );
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;
    return LayoutBuilder(builder: (ctx, constraints) {
      return SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(16, 32, 16, keyboardSpace + 48),
          child: Column(
            children: [
              TextField(
                // onChanged: _saveTitleInput,
                controller: _titleController,
                maxLength: 50,
                decoration: const InputDecoration(
                  label: Text('Title'),
                ),
                keyboardType: TextInputType.name,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                        controller: _amountController,
                        // maxLength: 20,
                        decoration: const InputDecoration(
                          prefixText: '\$ ',
                          label: Text('Amount'),
                        ),
                        keyboardType: TextInputType.number),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          _selectedDate == null
                              ? 'No Date Selected'
                              : formatter.format(_selectedDate!),
                        ), // ! ekleyerek selectedDate'in null olamayacağını söylüyoruz
                        IconButton(
                          onPressed: _presentDatePicker,
                          icon: const Icon(Icons.calendar_month),
                        )
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              Row(children: [
                DropdownButton(
                    value: _selectedCategory,
                    items: Category.values
                        .map(
                          (category) => DropdownMenuItem(
                            value: category,
                            child: Text(
                              capitalize(category.name),
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      if (value == null) {
                        return;
                      }
                      setState(() {
                        _selectedCategory = value;
                      });
                    }),
                const Spacer(),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Cancel')),
                // const Spacer(),
                ElevatedButton(
                  onPressed: _submitExpenseData,
                  child: const Text('Save Expense'),
                )
              ])
            ],
          ),
        ),
      );
    });
  }
}
