import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:personal_money_manager/db/category/category_db.dart';
import 'package:personal_money_manager/models/category/ctategory_model.dart';

ValueNotifier<CategoryType> selectedCategoryNotifier =
    ValueNotifier(CategoryType.income);

Future<void> showCategoryAddPopup(BuildContext context) async {
  final _nameEditingController = TextEditingController();
  showDialog(
      context: context,
      builder: (ctx) {
        return SimpleDialog(
          title: Text("Add categories"),
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: _nameEditingController,
                decoration: const InputDecoration(
                    hintText: 'Category name', border: OutlineInputBorder()),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: const Row(
                children: [
                  RadioButton(title: 'Income', type: CategoryType.income),
                  RadioButton(title: 'expense', type: CategoryType.expense),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  final _name = _nameEditingController.text;
                  if (_name.isEmpty) {
                    return;
                  }
                  final _type = selectedCategoryNotifier.value;
                  final _category = CategoryModel(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    name: _name,
                    type: _type,
                  );

                  CategoryDB().insertCategory(_category);
                  Navigator.of(ctx).pop();
                },
                child: Text("add",style: TextStyle(color: Colors.white),),
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.blue),
                ),
              ),
            )
          ],
        );
      });
}

class RadioButton extends StatelessWidget {
  final String title;
  final CategoryType type;
  const RadioButton({
    Key? key,
    required this.title,
    required this.type,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ValueListenableBuilder(
            valueListenable: selectedCategoryNotifier,
            builder: (BuildContext, CategoryType newCategory, Widget? _) {
              return Radio<CategoryType>(
                value: type,
                groupValue: selectedCategoryNotifier.value,
                onChanged: (value) {
                  if (value == null) {
                    return;
                  }
                  selectedCategoryNotifier.value = value;
                  selectedCategoryNotifier.notifyListeners();
                },
                activeColor: Colors.blue,
              );
            }),
        Text(title),
      ],
    );
  }
}
