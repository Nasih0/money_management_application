import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'dart:io';

import 'package:personal_money_manager/models/users/user_model.dart';

class TopRowWidget extends StatelessWidget {
  final VoidCallback onHamburgerTap;

  const TopRowWidget({
    Key? key,
    required this.onHamburgerTap,
    required String name,
  }) : super(key: key);

 String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning';
    } else if (hour < 17) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
  }



  @override
  Widget build(BuildContext context) {
    final userBox = Hive.box<UserModel>('userBox'); // Change to UserModel type
    final UserModel? user = userBox.get('user');

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Builder(
            builder: (context) {
              return IconButton(
                icon: Icon(Icons.menu),
                onPressed: onHamburgerTap,
              );
            },
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
               getGreeting(),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Text(
                user?.name ?? 'User', // Display user's name or default 'User'
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          CircleAvatar(
            // Display user profile image if available
            backgroundImage: user?.profileImage != null
                ? FileImage(File(user!.profileImage))
                : null,
            radius: 20,
            child: user?.profileImage == null ? Icon(Icons.person) : null,
          ),
        ],
      ),
    );
  }
}
