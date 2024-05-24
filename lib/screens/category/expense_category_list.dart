import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:personal_money_manager/db/category/category_db.dart';
import 'package:personal_money_manager/models/category/ctategory_model.dart';

class ExpenceCategoryList extends StatelessWidget {
  const ExpenceCategoryList({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: CategoryDB().ExpenseCategoryListListener,
      builder: (BuildContext ctx, List<CategoryModel> newlIst, Widget? _) {
        return ListView.separated(
          itemBuilder: (ctx, index) {
            final Category = newlIst[index];
            return Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Card(
                child: ListTile(
                  title: Text(Category.name),
                  trailing: IconButton(
                    onPressed: () {
                      CategoryDB.instance.deleteCategory(Category.id);
                    },
                    icon:  const Icon(Icons.delete),
                  ),
                ),
              ),
            );
          },
          separatorBuilder: (ctx, index) {
            return const SizedBox(height: 10);
          },
          itemCount: newlIst.length,
        );
      },
    );
  }
}
