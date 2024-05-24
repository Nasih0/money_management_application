

import 'package:flutter/widgets.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:personal_money_manager/models/category/ctategory_model.dart';

const CATEGORY_DB_NAME = 'categoty_database';

abstract class CategoryDbFunctions {
  Future<List<CategoryModel>> getCategories();
  Future<void> insertCategory(CategoryModel value);
  Future<void> deleteCategory(String CategoryID);
}

class CategoryDB implements CategoryDbFunctions {
  CategoryDB._internal();

  static CategoryDB instance = CategoryDB._internal();

  factory CategoryDB() {
    return instance;
  }

  ValueNotifier<List<CategoryModel>> IncomeCategoryListListener =
      ValueNotifier([]);
  ValueNotifier<List<CategoryModel>> ExpenseCategoryListListener =
      ValueNotifier([]);

  @override
  Future<void> insertCategory(CategoryModel value) async {
    final _categoryDB = await Hive.openBox<CategoryModel>(CATEGORY_DB_NAME);
    await _categoryDB.put(value.id, value);
    refreshUI();
  }

  @override
  Future<List<CategoryModel>> getCategories() async {
    final _categoryDB = await Hive.openBox<CategoryModel>(CATEGORY_DB_NAME);
    return _categoryDB.values.toList();
  }

  Future<void> refreshUI() async {
    final _allCategories = await getCategories();
    IncomeCategoryListListener.value.clear();
    ExpenseCategoryListListener.value.clear();
    await Future.forEach(
      _allCategories,
      (CategoryModel Category) {
        if (Category.type == CategoryType.income) {
          IncomeCategoryListListener.value.add(Category);
        } else {
          ExpenseCategoryListListener.value.add(Category);
        }
      },
    );
    IncomeCategoryListListener.notifyListeners();
    ExpenseCategoryListListener.notifyListeners();
  }

  @override
  Future<void> deleteCategory(String CategoryID) async {
    final _categoryDB = await Hive.openBox<CategoryModel>(CATEGORY_DB_NAME);
    _categoryDB.delete(CategoryID);
    refreshUI();
  }

  getIncomeCategory(String s) {}

  getExpenseCategory(String s) {}
}
