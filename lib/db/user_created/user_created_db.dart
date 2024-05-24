import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:personal_money_manager/models/users/user_model.dart';

const USER_DB = 'userBox';

abstract class UserDBFunctions {
  Future<void> saveUserData(UserModel user);
  UserModel? getUserData();
}

class UserDB implements UserDBFunctions {
  // Singleton pattern
  static final UserDB _instance = UserDB._internal();
  factory UserDB() => _instance;
  UserDB._internal();

  static Box<UserModel>? _userBox;
  static bool _initialized = false; // Flag to track initialization

  static Future<void> init() async {
    if (_initialized) {
      return; // Already initialized
    }

    final dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);

    try {
      _userBox = await Hive.openBox<UserModel>(USER_DB);
      _initialized = true; // Set initialized flag to true
    } catch (e) {
      // Handle any errors that occur during box opening
      print('Error opening user box: $e');
    }
  }

  @override
  Future<void> saveUserData(UserModel user) async {
    if (_userBox == null) {
      throw Exception('UserBox is not initialized');
    }
    await _userBox!.put('user', user);
  }

  @override
  UserModel? getUserData() {
    if (_userBox == null) {
      throw Exception('UserBox is not initialized');
    }

     Future<void> clearUserData() async {
    final box = await Hive.openBox<UserModel>(USER_DB);
    await box.clear();
  }
    return _userBox!.get('user');
  }

  void clearUserData() {}
}
