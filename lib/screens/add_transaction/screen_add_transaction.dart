import 'package:flutter/material.dart';
import 'package:personal_money_manager/db/category/category_db.dart';
import 'package:personal_money_manager/db/transaction/transaction_db.dart';
import 'package:personal_money_manager/models/category/ctategory_model.dart';
import 'package:personal_money_manager/models/transactions/transaction_model.dart';

class ScreenAddTransaction extends StatefulWidget {
  static const routeName = '/add_transaction';

  const ScreenAddTransaction({Key? key}) : super(key: key);

  @override
  State<ScreenAddTransaction> createState() => _ScreenAddTransactionState();
}

class _ScreenAddTransactionState extends State<ScreenAddTransaction> {
  DateTime? _selectedDate;
  CategoryType? _selectedCategoryType;
  CategoryModel? _selectedCategoryModel;
  String? _categoryID;

  final _purposeTextEditingControler = TextEditingController();
  final _amountTextEditingControler = TextEditingController();

  @override
  void initState() {
    _selectedCategoryType = CategoryType.income;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Add your transaction',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _purposeTextEditingControler,
                decoration: InputDecoration(
                  hintText: 'Purpose',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _amountTextEditingControler,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Amount',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextButton.icon(
                onPressed: () async {
                  final _selectedDateTemp = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now().subtract(const Duration(days: 30)),
                    lastDate: DateTime.now(),
                  );

                  if (_selectedDateTemp == null) {
                    return;
                  } else {
                    print(_selectedDateTemp.toString());
                    setState(() {
                      _selectedDate = _selectedDateTemp;
                    });
                  }
                },
                icon: Icon(Icons.calendar_today),
                label: Text(
                  _selectedDate == null ? 'Select date' : _selectedDate!.toString(),
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Radio(
                        value: CategoryType.income,
                        groupValue: _selectedCategoryType,
                        onChanged: (newValue) {
                          setState(() {
                            _selectedCategoryType = CategoryType.income;
                            _categoryID = null;
                          });
                        },
                      ),
                      Text('Income'),
                    ],
                  ),
                  Row(
                    children: [
                      Radio(
                        value: CategoryType.expense,
                        groupValue: _selectedCategoryType,
                        onChanged: (newValue) {
                          setState(() {
                            _selectedCategoryType = CategoryType.expense;
                            _categoryID = null;
                          });
                        },
                      ),
                      Text('Expense'),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: DropdownButton<String>(
                  hint: Text('Select Category'),
                  value: _categoryID,
                  items: (_selectedCategoryType == CategoryType.income
                          ? CategoryDB().IncomeCategoryListListener
                          : CategoryDB().ExpenseCategoryListListener)
                      .value
                      .map((e) {
                    return DropdownMenuItem(
                      value: e.id,
                      child: Text(e.name),
                      onTap: () {
                        _selectedCategoryModel = e;
                      },
                    );
                  }).toList(),
                  onChanged: (selectedValue) {
                    print(selectedValue);
                    setState(() {
                      _categoryID = selectedValue;
                    });
                  },
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton.icon(
                  onPressed: () {
                    addTransaction();
                  },
                  icon: Icon(Icons.check),
                  label: Text('Submit'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> addTransaction() async {
    final _purposeText = _purposeTextEditingControler.text;
    final _amountText = _amountTextEditingControler.text;
    if (_purposeText.isEmpty) {
      return;
    }
    if (_amountText.isEmpty) {
      return;
    }

    final parsedAmount = double.tryParse(_amountText);
    if (parsedAmount == null) {
      return;
    }
    if (_selectedDate == null) {
      return;
    }
    if (_selectedCategoryModel == null) {
      return;
    }

    final _model = TransactionModel(
      purpose: _purposeText,
      amount: parsedAmount,
      date: _selectedDate!,
      type: _selectedCategoryType!,
      category: _selectedCategoryModel!,
    );

    await TransactionDB.instance.addTransaction(_model);
    Navigator.of(context).pop();
    TransactionDB.instance.refresh();
  }
}
