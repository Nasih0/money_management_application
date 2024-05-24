import 'package:flutter/material.dart';
import 'package:personal_money_manager/screens/home/creat_account_page.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    navigateToCreateAccount(context);
  }

  Future<void> navigateToCreateAccount(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 3)); // Wait for 3 seconds
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (_) => const CreateAccountPage(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'lib/images/Moneyapp.png',
              width: 300,
              height: 300,
            ),
            SizedBox(
                height:
                    20), // Add some spacing between the logo and the progress indicator
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: SizedBox(
                width: 150, // Adjust the width as needed
                child: LinearProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                  backgroundColor: Colors.grey[300],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
