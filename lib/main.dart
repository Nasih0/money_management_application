import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:personal_money_manager/models/category/ctategory_model.dart';
import 'package:personal_money_manager/models/transactions/transaction_model.dart';
import 'package:personal_money_manager/models/users/user_model.dart';
import 'package:personal_money_manager/screens/add_transaction/screen_add_transaction.dart';
import 'package:personal_money_manager/screens/home/creat_account_page.dart';
import 'package:personal_money_manager/screens/home/screen_home.dart';
import 'package:personal_money_manager/db/user_created/user_created_db.dart';
import 'package:personal_money_manager/screens/splash_screen.dart'; // Add import for splash screen

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  if (!Hive.isAdapterRegistered(CategoryTypeAdapter().typeId)) {
    Hive.registerAdapter(CategoryTypeAdapter());
  }

  if (!Hive.isAdapterRegistered(CategoryModelAdapter().typeId)) {
    Hive.registerAdapter(CategoryModelAdapter());
  }

  if (!Hive.isAdapterRegistered(TransactionModelAdapter().typeId)) {
    Hive.registerAdapter(TransactionModelAdapter());
  }

  if (!Hive.isAdapterRegistered(UserModelAdapter().typeId)) {
    Hive.registerAdapter(UserModelAdapter());
  }

  await UserDB.init(); // Initialize the UserDB singleton

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      initialRoute: '/', // Change initial route to splash screen
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      routes: {
        '/': (context) => SplashScreen(), // Route to splash screen
        '/home': (context) => const ScreenHome(),
        '/create_account': (context) => const CreateAccountPage(),
        '/add_transaction': (context) => const ScreenAddTransaction(),
      },

      
    );
  }
 Future<bool> checkForExistingAccount() async {
  try {
    // Open the user box
    await Hive.openBox<UserModel>('user');

    // Check if the box is empty
    final userBox = Hive.box<UserModel>('user');
    if (userBox.isEmpty) {
      // If the box is empty, no user exists
      return false;
    } else {
      // If the box is not empty, a user exists
      return true;
    }
  } catch (e) {
    // Handle any errors that occur during box opening or access
    print('Error checking for existing account: $e');
    return false; // Assume no account exists in case of errors
  }
}
}
