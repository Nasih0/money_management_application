import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:personal_money_manager/db/user_created/user_created_db.dart';
import 'package:personal_money_manager/models/users/user_model.dart';

class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({Key? key}) : super(key: key);

  @override
  _CreateAccountPageState createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  File? _profileImage;

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: source);
    if (pickedImage != null) {
      setState(() {
        _profileImage = File(pickedImage.path);
      });
    }
  }

  Future<void> _submit() async {
    if (_nameController.text.isEmpty ||
        _mobileController.text.isEmpty ||
        _profileImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all fields and select an image')),
      );
      return;
    }

    final newUser = UserModel(
      name: _nameController.text,
      mobileNumber: _mobileController.text,
      profileImage: _profileImage!.path,
    );

    await UserDB().saveUserData(newUser);

    resetAppState(); // Reset the app state after creating a new account

    Navigator.pushReplacementNamed(context, '/home');
  }

  // Function to reset the app state
  void resetAppState() {
    // Clear existing data or perform any necessary app state reset
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     
      appBar: AppBar(
        title: const Text(
          'Create Your Account',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage:
                    _profileImage != null ? FileImage(_profileImage!) : null,
                child: _profileImage == null
                    ? IconButton(
                        icon: Icon(Icons.add_a_photo, size: 30),
                        onPressed: () {
                          _pickImage(ImageSource.gallery);
                        },
                      )
                    : null,
              ),
              SizedBox(height: 30),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Enter your name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _mobileController,
                decoration: InputDecoration(
                  labelText: 'Enter your mobile number',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  prefixIcon: Icon(Icons.phone),
                ),
                keyboardType: TextInputType.phone,
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: _submit,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 15.0, horizontal: 30.0),
                  child: Text('Submit', style: TextStyle(fontSize: 18)),
                ),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
