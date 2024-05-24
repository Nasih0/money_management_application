import 'package:flutter/material.dart';
import 'package:personal_money_manager/screens/home/screen_home.dart';

class MoneyMangaerBottomNavigation extends StatelessWidget {
  const MoneyMangaerBottomNavigation({super.key, required Null Function(dynamic index) onIndexChanged});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: ScreenHome.selectedIndexNotifier,
     builder: (BuildContext ctx, int updatedIndex, Widget? _){
      return BottomNavigationBar(
        currentIndex: updatedIndex,
        onTap: (newIndex) {
          ScreenHome.selectedIndexNotifier.value = newIndex;
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'transcations'),
          BottomNavigationBarItem(icon: Icon(Icons.category), label: 'category'),
        ],
      );
     },
    );
  }
}
