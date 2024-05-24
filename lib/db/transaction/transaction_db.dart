import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:personal_money_manager/models/transactions/transaction_model.dart';

const TRANSACTION_DB_NAME = 'transaction_db';

abstract class TransactionDBFunctions {
  Future<void> addTransaction(TransactionModel obj);
  Future<List<TransactionModel>> getAllTransactions();
  Future<void> transactionDelete(String id);
  Future<TransactionModel?> getTransactionById(String id);
}

class TransactionDB implements TransactionDBFunctions {
  TransactionDB._internal();
  static final TransactionDB instance = TransactionDB._internal();

  factory TransactionDB() {
    return instance;
  }

  ValueNotifier<List<TransactionModel>> transactonListNotifier =
      ValueNotifier([]);

  @override
  Future<void> addTransaction(TransactionModel obj) async {
    final _db = await Hive.openBox<TransactionModel>(TRANSACTION_DB_NAME);
    await _db.put(obj.id, obj);
    await refresh();
  }

  Future<void> refresh() async {
    final _list = await getAllTransactions();
    _list.sort((first, second) => second.date.compareTo(first.date));
    transactonListNotifier.value.clear();
    transactonListNotifier.value.addAll(_list);
    transactonListNotifier.notifyListeners();
  }

  @override
  Future<List<TransactionModel>> getAllTransactions() async {
    final _db = await Hive.openBox<TransactionModel>(TRANSACTION_DB_NAME);
    return _db.values.toList();
  }

  @override
  Future<void> transactionDelete(String id) async {
    final _db = await Hive.openBox<TransactionModel>(TRANSACTION_DB_NAME);
    await _db.delete(id);
    await refresh();
  }

  @override
  Future<TransactionModel?> getTransactionById(String id) async {
    final _db = await Hive.openBox<TransactionModel>(TRANSACTION_DB_NAME);
    return _db.get(id);
  }
}
