import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:personal_money_manager/db/category/category_db.dart';
import 'package:personal_money_manager/screens/category/expense_category_list.dart';
import 'package:personal_money_manager/screens/category/income_category_list.dart';

class ScreenCategory extends StatefulWidget {
  const ScreenCategory({super.key});

  @override
  State<ScreenCategory> createState() => _ScreenCategoryState();
}

class _ScreenCategoryState extends State<ScreenCategory>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    CategoryDB().refreshUI();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          TabBar(
            
           indicatorSize: TabBarIndicatorSize.label,
           indicatorColor:Colors.black12,
           
           
            controller: _tabController,
            tabs: [
              Tab(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(10) // Color for the first tab
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text('Income',style: TextStyle(color: (Colors.white)),),
                  ),
                  
                ),
                
              ),
              Tab(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.red, 
                    borderRadius: BorderRadius.circular(10)// Color for the first tab
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text('Expense',style: TextStyle(color: (Colors.white)),),
                  ),
                ),
              ),
              
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                IncomeCategoryList(),
                ExpenceCategoryList(),
              ],
            ),
          )
        ],
      ),
    );
  }
}
