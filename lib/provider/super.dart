import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SuperUserNotifier extends StateNotifier<bool> {
  SuperUserNotifier() : super(false);

  void loginAsSuperUser(String password) {
    // final superUserPassword = dotenv.env['SUPER_USER_PASSWORD'] ?? '';
    // final superUserPassword = "Hanumanji" ?? '';

    // if (password == superUserPassword) {
    //   state = true;
    // } else {
    //   throw Exception('Invalid Password');
    // }
  }

  void logout() => state = false;
}


final isSuperUserProvider = StateNotifierProvider<SuperUserNotifier, bool>((ref) => SuperUserNotifier());
