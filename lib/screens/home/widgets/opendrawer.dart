import 'dart:io';

import 'package:flutter/material.dart';
import 'package:personal_money_manager/db/user_created/user_created_db.dart';
import 'package:personal_money_manager/models/users/user_model.dart';
import 'package:personal_money_manager/screens/home/creat_account_page.dart';
//import 'create_account_page.dart';

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = UserDB().getUserData();

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(user?.name ?? 'User Name'),
            accountEmail: Text(user?.mobileNumber ?? 'user@example.com'),
            currentAccountPicture: CircleAvatar(
              backgroundImage: const NetworkImage('https://via.placeholder.com/150'),
            ),
          ),
          ListTile(
            leading: Icon(Icons.privacy_tip),
            title: Text('Privacy Policy'),
            onTap: () {
              // Handle Privacy Policy tap
            },
          ),
          ListTile(
            leading: Icon(Icons.info),
            title: Text('About'),
            onTap: () {
              // Handle About tap
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Log Out'),
            onTap: () {
              UserDB().clearUserData();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => CreateAccountPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}
