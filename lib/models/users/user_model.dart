// user_model.dart

import 'package:hive_flutter/hive_flutter.dart';
  part 'user_model.g.dart';
  

@HiveType(typeId:4)
class UserModel {
@HiveField(0)
  final String name;
@HiveField(1)
  final String mobileNumber;
@HiveField(2)
  final String profileImage;

  UserModel({
    required this.name,
    required this.mobileNumber,
    required this.profileImage,
  });
}

