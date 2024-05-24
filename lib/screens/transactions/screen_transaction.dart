import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:personal_money_manager/db/category/category_db.dart';
import 'package:personal_money_manager/db/transaction/transaction_db.dart';
import 'package:personal_money_manager/models/category/ctategory_model.dart';
import 'package:personal_money_manager/models/transactions/transaction_model.dart';
import 'package:personal_money_manager/screens/home/widgets/income_expense_card.dart';
import 'package:personal_money_manager/screens/home/widgets/opendrawer.dart';
import 'package:personal_money_manager/screens/home/widgets/top_row.dart';

class ScreenTransaction extends StatefulWidget {
  const ScreenTransaction({Key? key}) : super(key: key);

  @override
  State<ScreenTransaction> createState() => _ScreenTransactionState();
}

class _ScreenTransactionState extends State<ScreenTransaction> {
  double totalIncome = 0.0;
  double totalExpense = 0.0;

  @override
  Widget build(BuildContext context) {
    TransactionDB.instance.refresh();
    CategoryDB.instance.refreshUI();

    return Scaffold(
        drawer: CustomDrawer(),
        body: Builder(builder: (context) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TopRowWidget(
                name: '', // Provide the user's name here or handle null
                onHamburgerTap: () {
                  Scaffold.of(context).openDrawer();
                },
              ),
              FutureBuilder<Map<String, double>>(
                future: _fetchDynamicTotals(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError || snapshot.data == null) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  return IncomeExpenseWidget(
                    totalIncome:
                        (snapshot.data!['totalIncome'] ?? 0).toDouble().toInt(),
                    totalExpense: (snapshot.data!['totalExpense'] ?? 0)
                        .toDouble()
                        .toInt(),
                  );
                },
              ),
              const Padding(
                padding: EdgeInsets.only(left: 20, top: 10),
                child: Text(
                  "Transactions",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                ),
              ),
              Expanded(
                child: ValueListenableBuilder(
                  valueListenable:
                      TransactionDB.instance.transactonListNotifier,
                  builder: (BuildContext ctx, List<TransactionModel> newList,
                      Widget? _) {
                    if (newList.isEmpty) {
                      return Center(
                        child: Text(
                          'Add your transactions',
                          style: TextStyle(fontSize: 20, color: Colors.grey),
                        ),
                      );
                    }
                    return ListView.separated(
                      padding: const EdgeInsets.all(10),
                      itemBuilder: (ctx, index) {
                        final _value = newList[index];
                        if (_value == null) {
                          return SizedBox
                              .shrink(); // Handle possible null values
                        }
                        return Slidable(
                          key: Key(_value.id ?? 'null'),
                          startActionPane: ActionPane(
                            motion: ScrollMotion(),
                            children: [
                              SlidableAction(
                                onPressed: (ctx) {
                                  _deleteTransaction(_value.id ?? '');
                                },
                                icon: Icons.delete,
                                label: 'Delete',
                                backgroundColor:
                                    const Color.fromARGB(255, 255, 255, 255),
                              )
                            ],
                          ),
                          child: Card(
                            elevation: null,
                            color: Colors.white,
                            child: ListTile(
                              leading: CircleAvatar(
                                radius: 40,
                                child: Text(
                                  _parseDate(_value.date),
                                  textAlign: TextAlign.center,
                                ),
                                backgroundColor:
                                    _value.type == CategoryType.income
                                        ? Colors.green
                                        : Colors.red,
                              ),
                              title: Text(
                                'Rs ${_value.amount}',
                                style: TextStyle(fontSize: 20),
                              ),
                              subtitle: Text(
                                _value.purpose ?? '',
                                style: TextStyle(fontSize: 17),
                              ),
                              trailing: Icon(_value.type == CategoryType.income
                                  ? Icons.arrow_downward
                                  : Icons.arrow_upward),
                              iconColor: (_value.type == CategoryType.income
                                  ? Colors.green
                                  : Colors.red),
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (ctx, index) {
                        return const SizedBox(
                          height: 10,
                        );
                      },
                      itemCount: newList.length,
                    );
                  },
                ),
              ),
            ],
          );
        }));
  }

  String _parseDate(DateTime date) {
    return DateFormat.MMMd().format(date);
  }

  Future<Map<String, double>> _fetchDynamicTotals() async {
    final transactions = await TransactionDB.instance.getAllTransactions();
    double totalIncome = 0.0;
    double totalExpense = 0.0;

    for (final transaction in transactions) {
      if (transaction.type == CategoryType.income) {
        totalIncome += transaction.amount;
      } else {
        totalExpense += transaction.amount;
      }
    }

    return {'totalIncome': totalIncome, 'totalExpense': totalExpense};
  }

  Future<void> _deleteTransaction(String id) async {
    if (id.isEmpty) {
      print("Transaction ID is empty. Aborting deletion.");
      return;
    }

    try {
      final transaction = await TransactionDB.instance.getTransactionById(id);
      if (transaction != null) {
        print(
            "Deleting transaction with ID: $id, Amount: ${transaction.amount}");
        await TransactionDB.instance.transactionDelete(id);
        print("Transaction with ID $id deleted successfully.");

        await TransactionDB.instance.refresh();
        print("Transaction list refreshed.");

        setState(() {
          if (transaction.type == CategoryType.income) {
            totalIncome -= transaction.amount;
          } else {
            totalExpense -= transaction.amount;
          }
        });
        print(
            "State updated. TotalIncome: $totalIncome, TotalExpense: $totalExpense");
      } else {
        print("No transaction found with ID $id.");
      }
    } catch (e) {
      print("An error occurred while deleting the transaction: $e");
    }
  }
}
