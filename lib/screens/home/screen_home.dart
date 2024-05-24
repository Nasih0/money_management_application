import 'package:flutter/material.dart';
import 'package:personal_money_manager/screens/add_transaction/screen_add_transaction.dart';
//import 'package:personal_money_manager/db/category/category_db.dart';
//import 'package:personal_money_manager/models/category/ctategory_model.dart';
import 'package:personal_money_manager/screens/category/category_add_popup.dart';
import 'package:personal_money_manager/screens/category/screen_category.dart';
//import 'package:personal_money_manager/screens/home/creat_account_page.dart';
import 'package:personal_money_manager/screens/home/widgets/bottom_navigation.dart';
import 'package:personal_money_manager/screens/transactions/screen_transaction.dart';

class ScreenHome extends StatelessWidget {
  const ScreenHome({super.key});

  static ValueNotifier<int> selectedIndexNotifier = ValueNotifier(0);

  final _pages = const [
    ScreenTransaction(),
    ScreenCategory(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar:  MoneyMangaerBottomNavigation
      (onIndexChanged: (index) {
         selectedIndexNotifier.value = index; }, ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          
           
            // ValueListenableBuilder and list view
            Expanded(
              child: ValueListenableBuilder(
                valueListenable: selectedIndexNotifier,
                builder: (BuildContext context, int updatedIndex, _) {
                  return _pages[updatedIndex];
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (selectedIndexNotifier.value == 0) {
            print('add transaction');
            Navigator.of(context).pushNamed(ScreenAddTransaction.routeName);
          } else {
            print('add category');
            showCategoryAddPopup(context);
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
