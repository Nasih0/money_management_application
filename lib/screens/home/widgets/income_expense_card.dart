import 'package:flutter/material.dart';
import 'package:personal_money_manager/db/transaction/transaction_db.dart';
import 'package:personal_money_manager/models/category/ctategory_model.dart';

class IncomeExpenseWidget extends StatefulWidget {
  const IncomeExpenseWidget(
      {Key? key, required int totalIncome, required int totalExpense})
      : super(key: key);

  @override
  _IncomeExpenseWidgetState createState() => _IncomeExpenseWidgetState();
}

class _IncomeExpenseWidgetState extends State<IncomeExpenseWidget> {
  double totalIncome = 0.0;
  double totalExpense = 0.0;

  @override
  void initState() {
    super.initState();
    // Fetch dynamic total income and total expense from TransactionDB
    fetchDynamicTotals();
  }

  Future<void> fetchDynamicTotals() async {
    final transactions = await TransactionDB.instance.getAllTransactions();
    double incomeSum = 0.0;
    double expenseSum = 0.0;

    for (final transaction in transactions) {
      if (transaction.type == CategoryType.income) {
        incomeSum += transaction.amount;
      } else {
        expenseSum += transaction.amount;
      }
    }

    setState(() {
      totalIncome = incomeSum;
      totalExpense = expenseSum;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 380,
      height: 140,
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      padding: EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 14, 14, 14),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 3,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Income section
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Income',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 255, 255, 255),
                ),
              ),
              SizedBox(height: 8),
              // Show dynamic total income here
              Text(
                '\$$totalIncome',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.green,
                ),
              ),
            ],
          ),
          // Expense section
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Expense',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 255, 255, 255),
                ),
              ),
              SizedBox(height: 8),
              // Show dynamic total expense here
              Text(
                '\$$totalExpense',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
